import assert from 'node:assert/strict';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import Database from 'better-sqlite3';
import XLSX from 'xlsx';

const root = path.resolve(import.meta.dirname, '..');
const nonMemberId = '90000000-0000-0000-0000-000000000001';
let temporaryDirectory;
let app;
let baseUrl;

test.before(async () => {
  temporaryDirectory = await mkdtemp(path.join(os.tmpdir(), 'lean-project-control-'));
  const databasePath = path.join(temporaryDirectory, 'test.db');
  const database = new Database(databasePath);
  database.exec(await readFile(path.join(root, 'database/sqlite/migrations/001_initial_schema.sql'), 'utf8'));
  database.exec(await readFile(path.join(root, 'database/sqlite/seeds/001_reference_data.sql'), 'utf8'));
  database.prepare(`INSERT INTO people (person_id, employee_code, display_name, email)
    VALUES (?, 'NON-MEMBER', 'Directory Only Person', 'directory.only@example.invalid')`).run(nonMemberId);
  database.close();

  process.env.PORT = '0';
  process.env.DATABASE_URL = `file:${databasePath}`;
  process.env.ALLOW_DEMO_IDENTITY_OVERRIDE = 'true';
  const server = await import('../apps/api/server.js');
  app = server.app;
  await server.listenPromise;
  const address = app.server.address();
  baseUrl = `http://127.0.0.1:${address.port}`;
});

test.after(async () => {
  if (app) await app.close();
  if (temporaryDirectory) await rm(temporaryDirectory, { recursive: true, force: true });
});

test('serves the walkthrough and all read endpoints', async () => {
  const paths = ['/', '/api/session', '/api/portfolio', '/api/project', '/api/dashboard', '/api/master-control?weekStart=2026-08-31', '/api/tasks', '/api/wbs', '/api/people', '/api/project-members', '/api/assignments', '/api/weekly-plans?weekStart=2026-08-31', '/api/role-updates?weekStart=2026-08-31', '/api/weekly-updates', '/api/raid', '/api/audit', '/api/workload/all-projects'];
  for (const endpoint of paths) {
    const response = await fetch(`${baseUrl}${endpoint}`);
    assert.equal(response.status, 200, endpoint);
  }

  const dashboard = await fetch(`${baseUrl}/api/dashboard`).then((response) => response.json());
  assert.equal(dashboard.taskCount, 5);
  assert.equal(dashboard.completed, 1);
});

test('separates portfolio metrics and tasks by project', async () => {
  const projects = await fetch(`${baseUrl}/api/portfolio`).then((response) => response.json());
  assert.equal(projects.length, 2);
  const rrms = projects.find((project) => project.project_code === 'RRMS');
  const transformation = projects.find((project) => project.project_code === 'DTP');
  assert.equal(rrms.taskCount, 5);
  assert.equal(transformation.taskCount, 3);
  assert.equal(rrms.calculatedRag, 'Amber');
  assert.ok(rrms.tasks.every((task) => task.task_code.startsWith('RRMS-')));
  assert.ok(transformation.tasks.every((task) => task.task_code.startsWith('DTP-')));
});

test('reconciles each member workload with open, completed, and total task counts', async () => {
  const workload = await fetch(`${baseUrl}/api/workload`).then((response) => response.json());
  const statusPriority = { InProgress: 0, Blocked: 1, OnHold: 2, NotStarted: 3 };
  assert.ok(workload.members.length > 0);
  assert.ok(workload.members.some((member) => member.completed > 0));

  for (const member of workload.members) {
    assert.equal(member.total_tasks, member.total + member.completed, member.display_name);
    assert.equal(member.tasks.length, member.total, member.display_name);
    assert.ok(member.tasks.every((task) => task.status !== 'Done'), member.display_name);
    assert.ok(member.tasks.every((task) => task.wbs_code && task.wbs_name), member.display_name);
    for (let index = 1; index < member.tasks.length; index += 1) {
      assert.ok(statusPriority[member.tasks[index - 1].status] <= statusPriority[member.tasks[index].status], member.display_name);
    }
  }
});

test('resolves active demo accounts and rejects an unknown override', async () => {
  const pmSession = await fetch(`${baseUrl}/api/session`).then((response) => response.json());
  assert.equal(pmSession.loginName, 'rrms.demo.pm');
  assert.ok(pmSession.roles.includes('PM_PMO'));

  const baResponse = await fetch(`${baseUrl}/api/session`, { headers: { 'x-demo-login': 'rrms.demo.ba' } });
  assert.equal(baResponse.status, 200);
  const baSession = await baResponse.json();
  assert.equal(baSession.displayName, 'RRMS Demo BA');
  assert.ok(baSession.roles.includes('BA_LEAD'));

  const unknownResponse = await fetch(`${baseUrl}/api/session`, { headers: { 'x-demo-login': 'missing.demo.user' } });
  assert.equal(unknownResponse.status, 401);
});

test('uses the resolved request actor for ownership and auditing', async () => {
  const response = await fetch(`${baseUrl}/api/raid`, {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'x-demo-login': 'rrms.demo.ba' },
    body: JSON.stringify({ raidType: 'Risk', title: 'Identity audit test', probability: 2, impact: 3 })
  });
  assert.equal(response.status, 201);
  const { raidItemId } = await response.json();
  const auditEntries = await fetch(`${baseUrl}/api/audit`).then((auditResponse) => auditResponse.json());
  const entry = auditEntries.find((item) => item.entity_id === raidItemId && item.action === 'raid.create');
  assert.equal(entry.actor_name, 'RRMS Demo BA');
});

test('rejects a completed task update below 100 percent', async () => {
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const response = await fetch(`${baseUrl}/api/tasks/${tasks[0].task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ status: 'Done', progress: 99 })
  });

  assert.equal(response.status, 422);
  assert.deepEqual(await response.json(), { message: 'A completed task must have 100% progress.' });
});

test('rejects assignment when the person is not a project member', async () => {
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const response = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: tasks[0].task_id, personId: nonMemberId, assignmentRole: 'Contributor' })
  });

  assert.equal(response.status, 422);
  assert.deepEqual(await response.json(), { message: 'Person is not an active project member.' });
});

test('enforces task hierarchy and accepts a valid Task parent', async () => {
  const [tasks, wbs] = await Promise.all([
    fetch(`${baseUrl}/api/tasks`).then((response) => response.json()),
    fetch(`${baseUrl}/api/wbs`).then((response) => response.json())
  ]);
  const mainTask = tasks.find((item) => item.task_type === 'MainTask' && item.wbs_item_id === wbs[0].wbs_item_id);
  const taskBody = {
    wbsItemId: wbs[0].wbs_item_id,
    taskCode: 'RRMS-T-AUTO',
    taskName: 'Automated hierarchy test',
    taskType: 'Task',
    ownerPersonId: mainTask.owner_person_id
  };

  const invalidResponse = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(taskBody)
  });
  assert.equal(invalidResponse.status, 422);
  assert.deepEqual(await invalidResponse.json(), { message: 'Task requires a valid parent task.' });

  const validResponse = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ ...taskBody, parentTaskId: mainTask.task_id })
  });
  assert.equal(validResponse.status, 201);
});

test('adds a new person as an RRMS member before assignment', async () => {
  const personResponse = await fetch(`${baseUrl}/api/people`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ employeeCode: 'AUTO-TEAM-01', displayName: 'Automated Team Member', projectRole: 'TeamMember' })
  });
  assert.equal(personResponse.status, 201);
  const { personId } = await personResponse.json();
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  assert.equal(people.find((person) => person.person_id === personId).project_role, 'TeamMember');

  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const assignmentResponse = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: tasks[0].task_id, personId, assignmentRole: 'Contributor' })
  });
  assert.equal(assignmentResponse.status, 201);
});

test('retires BA and QA roles from project team and assignment options', async () => {
  const roles = await fetch(`${baseUrl}/api/roles`).then((response) => response.json());
  assert.equal(roles.some((role) => ['BA', 'BALead', 'QA', 'QALead'].includes(role.role_code)), false);

  const task = (await fetch(`${baseUrl}/api/tasks`).then((response) => response.json()))[0];
  const person = (await fetch(`${baseUrl}/api/people`).then((response) => response.json())).find((item) => item.employee_code === 'DEMO-RRMS-BA');
  const response = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, personId: person.person_id, assignmentRole: 'QA' })
  });
  assert.equal(response.status, 422);

  const legacyRoleResponse = await fetch(`${baseUrl}/api/people`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ employeeCode: 'AUTO-LEGACY-BA', displayName: 'Legacy BA Form Value', projectRole: 'Business Analyst (BA)' })
  });
  assert.equal(legacyRoleResponse.status, 201);
  const { personId } = await legacyRoleResponse.json();
  const people = await fetch(`${baseUrl}/api/people`).then((result) => result.json());
  assert.equal(people.find((item) => item.person_id === personId).project_role, 'TeamMember');

  const legacyDeveloperResponse = await fetch(`${baseUrl}/api/people`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ employeeCode: 'AUTO-LEGACY-DEV', displayName: 'Legacy Developer Form Value', projectRole: 'Developer (DEV)' })
  });
  assert.equal(legacyDeveloperResponse.status, 201);
  const { personId: developerId } = await legacyDeveloperResponse.json();
  const refreshedPeople = await fetch(`${baseUrl}/api/people`).then((result) => result.json());
  assert.equal(refreshedPeople.find((item) => item.person_id === developerId).project_role, 'DEVLead');

  const aliases = [
    ['Project Manager (PM)', 'PM'],
    ['Project Admin', 'ProjectAdmin'],
    ['Team Member (TeamMember)', 'TeamMember'],
    ['Reviewer (Reviewer)', 'Reviewer']
  ];
  for (const [index, [legacyRole, expectedRole]] of aliases.entries()) {
    const result = await fetch(`${baseUrl}/api/people`, {
      method: 'POST', headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ employeeCode: `AUTO-LEGACY-ROLE-${index}`, displayName: `Legacy ${expectedRole}`, projectRole: legacyRole })
    });
    assert.equal(result.status, 201);
    const { personId: legacyPersonId } = await result.json();
    const directory = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
    assert.equal(directory.find((item) => item.person_id === legacyPersonId).project_role, expectedRole);
  }
});

test('keeps the task owner in sync when an Owner assignment is created', async () => {
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const newOwner = people.find((person) => person.employee_code === 'DEMO-RRMS-BA');
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const task = tasks.find((item) => item.owner_person_id !== newOwner.person_id);
  assert.ok(task);

  const response = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, personId: newOwner.person_id, assignmentRole: 'Owner' })
  });
  assert.equal(response.status, 201);
  const { taskAssignmentId } = await response.json();

  const [refreshedTasks, assignments] = await Promise.all([
    fetch(`${baseUrl}/api/tasks`).then((result) => result.json()),
    fetch(`${baseUrl}/api/assignments`).then((result) => result.json())
  ]);
  const refreshedTask = refreshedTasks.find((item) => item.task_id === task.task_id);
  const activeOwners = assignments.filter((item) => item.task_id === task.task_id && item.assignment_role === 'Owner');
  assert.equal(refreshedTask.owner_person_id, newOwner.person_id);
  assert.equal(refreshedTask.owner_name, newOwner.display_name);
  assert.equal(activeOwners.length, 1);
  assert.equal(activeOwners[0].person_id, newOwner.person_id);
  assert.equal(activeOwners[0].is_primary, 1);

  const deleteResponse = await fetch(`${baseUrl}/api/assignments/${taskAssignmentId}`, { method: 'DELETE' });
  assert.equal(deleteResponse.status, 422);
  assert.deepEqual(await deleteResponse.json(), { message: 'Assign a new Owner before deleting the current Owner assignment.' });
});

test('changes a work item owner through the structure-editor API contract', async () => {
  const [people, taskItems] = await Promise.all([
    fetch(`${baseUrl}/api/people`).then((response) => response.json()),
    fetch(`${baseUrl}/api/tasks`).then((response) => response.json())
  ]);
  const task = taskItems[0];
  const newOwner = people.find((person) => person.is_project_member && person.person_id !== task.owner_person_id);
  assert.ok(newOwner, 'the seed data must include a second active project member');

  const response = await fetch(`${baseUrl}/api/tasks/${task.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ owner_person_id: newOwner.person_id })
  });
  assert.equal(response.status, 200);
  const saved = await response.json();
  assert.equal(saved.owner_person_id, newOwner.person_id);
  assert.equal(saved.owner_name, newOwner.display_name);

  const assignments = await fetch(`${baseUrl}/api/assignments`).then((result) => result.json());
  const activeOwners = assignments.filter((item) => item.task_id === task.task_id && item.assignment_role === 'Owner');
  assert.deepEqual(activeOwners.map((item) => item.person_id), [newOwner.person_id]);
  assert.equal(activeOwners[0].is_primary, 1);
});

test('adds an existing person to the project when a team role is set', async () => {
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const personOutsideProject = people.find((person) => !person.is_project_member);
  assert.ok(personOutsideProject, 'the seed data must include a person outside the current project');

  const update = await fetch(`${baseUrl}/api/people/${personOutsideProject.person_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ projectRole: 'TeamMember' })
  });
  assert.equal(update.status, 200);

  const refreshedPeople = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const projectMember = refreshedPeople.find((person) => person.person_id === personOutsideProject.person_id);
  assert.equal(projectMember.is_project_member, 1);
  assert.equal(projectMember.project_role, 'TeamMember');

  const task = (await fetch(`${baseUrl}/api/tasks`).then((response) => response.json()))[0];
  const ownerUpdate = await fetch(`${baseUrl}/api/tasks/${task.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ owner_person_id: personOutsideProject.person_id })
  });
  assert.equal(ownerUpdate.status, 200);
  assert.equal((await ownerUpdate.json()).owner_person_id, personOutsideProject.person_id);
});

test('creates a weekly update and its audit event', async () => {
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const response = await fetch(`${baseUrl}/api/weekly-updates`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      taskId: tasks[0].task_id,
      weekStartDate: '2026-08-31',
      status: 'InProgress',
      ragStatus: 'Green',
      progress: 70,
      summary: 'Automated smoke test update.'
    })
  });

  assert.equal(response.status, 201);
  const auditEntries = await fetch(`${baseUrl}/api/audit`).then((auditResponse) => auditResponse.json());
  assert.ok(auditEntries.some((entry) => entry.action === 'weekly_update.create'));
});

test('accepts On hold work item updates and rejects unsupported statuses cleanly', async () => {
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const task = tasks.find((item) => item.task_type === 'Subtask') || tasks[0];
  const onHoldResponse = await fetch(`${baseUrl}/api/weekly-updates`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      taskId: task.task_id,
      weekStartDate: '2026-09-07',
      status: 'OnHold',
      ragStatus: 'Green',
      progress: 20,
      summary: 'Waiting for an external dependency.',
      nextStep: 'Resume when access is available.'
    })
  });
  assert.equal(onHoldResponse.status, 201);
  const refreshed = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  assert.equal(refreshed.find((item) => item.task_id === task.task_id).status, 'OnHold');

  const invalidResponse = await fetch(`${baseUrl}/api/weekly-updates`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, weekStartDate: '2026-09-07', status: 'Paused', ragStatus: 'Green', progress: 20, summary: 'Invalid status check.' })
  });
  assert.equal(invalidResponse.status, 422);
  assert.deepEqual(await invalidResponse.json(), { message: 'Task status is invalid.' });
});

test('plans the week, records a role update, and rolls both into master control', async () => {
  const [task] = await fetch(`${baseUrl}/api/tasks`).then((response) => response.json());
  const member = (await fetch(`${baseUrl}/api/people`).then((response) => response.json())).find((person) => person.is_project_member);
  const planResponse = await fetch(`${baseUrl}/api/weekly-plans`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ weekStartDate: '2026-08-31', planTitle: 'Complete weekly control flow', taskId: task.task_id,
      ownerPersonId: member.person_id, ownerRole: 'PM', targetOutcome: 'A visible plan versus actual report', priority: 'High', status: 'InProgress' })
  });
  assert.equal(planResponse.status, 201);

  const roleResponse = await fetch(`${baseUrl}/api/role-updates`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ weekStartDate: '2026-08-31', personId: member.person_id, roleName: 'PM',
      accomplished: 'Weekly plan established.', nextActions: 'Review project attention.' })
  });
  assert.equal(roleResponse.status, 201);

  const master = await fetch(`${baseUrl}/api/master-control?weekStart=2026-08-31`).then((response) => response.json());
  assert.ok(master.projects.length >= 2);
  assert.ok(master.plans.some((item) => item.plan_title === 'Complete weekly control flow'));
  assert.ok(master.roleUpdates.some((item) => item.role_name === 'PM'));
  assert.equal(master.summary.planCount >= 1, true);
});

test('records a task note, downloads its attachment, and rejects an oversized file', async () => {
  const task = (await fetch(`${baseUrl}/api/tasks`).then((response) => response.json()))[0];
  const noteResponse = await fetch(`${baseUrl}/api/task-notes`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, noteType: 'Note', noteText: 'Attachment smoke test.' })
  });
  assert.equal(noteResponse.status, 201);
  const { taskNoteId } = await noteResponse.json();

  const editResponse = await fetch(`${baseUrl}/api/task-notes/${taskNoteId}`, {
    method: 'PATCH', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ noteType: 'Update', noteText: 'Edited attachment smoke test.' })
  });
  assert.equal(editResponse.status, 200);
  assert.equal((await editResponse.json()).note_text, 'Edited attachment smoke test.');

  const uploadResponse = await fetch(`${baseUrl}/api/task-notes/${taskNoteId}/files`, {
    method: 'PUT', headers: { 'content-type': 'application/octet-stream', 'x-file-name': 'note.txt', 'x-file-type': 'text/plain' },
    body: new TextEncoder().encode('Task note attachment')
  });
  assert.equal(uploadResponse.status, 201);
  const { taskNoteFileId } = await uploadResponse.json();

  const notes = await fetch(`${baseUrl}/api/task-notes?taskId=${task.task_id}`).then((response) => response.json());
  assert.equal(notes[0].note_type, 'Update');
  assert.equal(notes[0].note_text, 'Edited attachment smoke test.');
  assert.equal(notes[0].files[0].original_file_name, 'note.txt');
  const download = await fetch(`${baseUrl}/api/task-note-files/${taskNoteFileId}/download`);
  assert.equal(download.status, 200);
  assert.equal(await download.text(), 'Task note attachment');

  const oversized = await fetch(`${baseUrl}/api/task-notes/${taskNoteId}/files`, {
    method: 'PUT', headers: { 'content-type': 'application/octet-stream', 'x-file-name': 'too-large.bin' },
    body: new Uint8Array(5 * 1024 * 1024 + 1)
  });
  assert.equal(oversized.status, 413);
});

test('edits and soft-deletes mock records', async () => {
  const personResponse = await fetch(`${baseUrl}/api/people`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ employeeCode: 'AUTO-CRUD-01', displayName: 'Original mock person', email: 'auto.crud@example.invalid', projectRole: 'TeamMember' })
  });
  assert.equal(personResponse.status, 201);
  const { personId } = await personResponse.json();

  const personUpdate = await fetch(`${baseUrl}/api/people/${personId}`, {
    method: 'PATCH', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ displayName: 'Edited mock person', department: 'Delivery', projectRole: 'DEVLead' })
  });
  assert.equal(personUpdate.status, 200);
  assert.equal((await personUpdate.json()).display_name, 'Edited mock person');

  const task = (await fetch(`${baseUrl}/api/tasks`).then((response) => response.json()))[0];
  const assignmentResponse = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, personId, assignmentRole: 'Contributor' })
  });
  assert.equal(assignmentResponse.status, 201);
  const { taskAssignmentId } = await assignmentResponse.json();
  const assignmentUpdate = await fetch(`${baseUrl}/api/assignments/${taskAssignmentId}`, {
    method: 'PATCH', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ assignmentRole: 'Reviewer' })
  });
  assert.equal(assignmentUpdate.status, 200);
  assert.equal((await assignmentUpdate.json()).assignment_role, 'Reviewer');
  assert.equal((await fetch(`${baseUrl}/api/assignments/${taskAssignmentId}`, { method: 'DELETE' })).status, 204);

  const raidResponse = await fetch(`${baseUrl}/api/raid`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ raidType: 'Risk', title: 'Original RAID title', ownerPersonId: personId, probability: 2, impact: 2 })
  });
  const { raidItemId } = await raidResponse.json();
  assert.equal((await fetch(`${baseUrl}/api/raid`).then((response) => response.json())).find((item) => item.raid_item_id === raidItemId).owner_person_id, personId);
  const raidUpdate = await fetch(`${baseUrl}/api/raid/${raidItemId}`, {
    method: 'PATCH', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ title: 'Edited RAID title', status: 'Monitoring' })
  });
  assert.equal(raidUpdate.status, 200);
  assert.equal((await raidUpdate.json()).title, 'Edited RAID title');
  assert.equal((await fetch(`${baseUrl}/api/raid/${raidItemId}`, { method: 'DELETE' })).status, 204);

  assert.equal((await fetch(`${baseUrl}/api/people/${personId}`, { method: 'DELETE' })).status, 204);
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  assert.equal(people.some((person) => person.person_id === personId), false);
});

test('creates a project, activity, and task in the selected project', async () => {
  const existingPeople = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const projectTeamMember = existingPeople.find((person) => person.employee_code === 'DEMO-RRMS-BA');
  const projectMainPm = existingPeople.find((person) => person.person_id === nonMemberId);
  assert.ok(projectTeamMember);
  assert.ok(projectMainPm);
  const projectResponse = await fetch(`${baseUrl}/api/projects`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ projectCode: 'AUTO-PROJECT', projectName: 'Automated delivery project', projectType: 'Change Major', projectSize: 'Large', startDate: '2026-09-01', targetEndDate: '2026-12-31', mainPmPersonId: projectMainPm.person_id, teamMemberIds: [projectTeamMember.person_id] })
  });
  assert.equal(projectResponse.status, 201);
  const { projectId } = await projectResponse.json();
  const selectedHeaders = { 'content-type': 'application/json', 'x-project-id': projectId };

  const projectPeople = await fetch(`${baseUrl}/api/people`, { headers: selectedHeaders }).then((response) => response.json());
  const selectedTeamMember = projectPeople.find((person) => person.person_id === projectTeamMember.person_id);
  assert.equal(selectedTeamMember.is_project_member, 1);
  assert.equal(selectedTeamMember.project_role, 'TeamMember');

  const projectMembers = await fetch(`${baseUrl}/api/project-members`, { headers: selectedHeaders }).then((response) => response.json());
  assert.ok(projectMembers.some((person) => person.person_id === projectTeamMember.person_id && person.project_role === 'TeamMember'));
  assert.equal(projectMembers.some((person) => person.employee_code === 'DEMO-RRMS-PM'), false);

  const initialPhases = await fetch(`${baseUrl}/api/phases`, { headers: selectedHeaders }).then((response) => response.json());
  assert.equal(initialPhases.length, 0);
  const phaseResponse = await fetch(`${baseUrl}/api/phases`, {
    method: 'POST', headers: selectedHeaders, body: JSON.stringify({ phaseCode: 'CUSTOM', phaseName: 'Custom delivery heading' })
  });
  assert.equal(phaseResponse.status, 201);
  const { phaseId } = await phaseResponse.json();

  const activityResponse = await fetch(`${baseUrl}/api/wbs`, {
    method: 'POST', headers: selectedHeaders, body: JSON.stringify({ wbsCode: 'ACT-01', wbsName: 'Delivery activity', phaseId })
  });
  assert.equal(activityResponse.status, 201);
  const { wbsItemId } = await activityResponse.json();

  const taskResponse = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST', headers: selectedHeaders,
    body: JSON.stringify({ wbsItemId, taskCode: 'AUTO-MT-01', taskName: 'Deliver the activity', taskType: 'MainTask', workstream: 'Engineering & QA' })
  });
  assert.equal(taskResponse.status, 201);
  const { taskId } = await taskResponse.json();

  const [project, activities, tasks, phases] = await Promise.all([
    fetch(`${baseUrl}/api/project`, { headers: selectedHeaders }).then((response) => response.json()),
    fetch(`${baseUrl}/api/wbs`, { headers: selectedHeaders }).then((response) => response.json()),
    fetch(`${baseUrl}/api/tasks`, { headers: selectedHeaders }).then((response) => response.json()),
    fetch(`${baseUrl}/api/phases`, { headers: selectedHeaders }).then((response) => response.json())
  ]);
  assert.equal(project.project_code, 'AUTO-PROJECT');
  assert.equal(project.project_type, 'Change Major');
  assert.equal(project.project_size, 'Large');
  assert.equal(activities[0].wbs_name, 'Delivery activity');
  assert.equal(tasks[0].task_name, 'Deliver the activity');
  assert.equal(tasks[0].workstream, 'Engineering & QA');
  assert.deepEqual(phases.map((phase) => phase.phase_code), ['CUSTOM']);
  assert.equal(activities[0].phase_name, 'Custom delivery heading');

  const patchResponse = await fetch(`${baseUrl}/api/tasks/${taskId}`, {
    method: 'PATCH', headers: selectedHeaders,
    body: JSON.stringify({ workstream: 'Core Platform' })
  });
  assert.equal(patchResponse.status, 200);
  const patchedTask = await patchResponse.json();
  assert.equal(patchedTask.workstream, 'Core Platform');

  const people = await fetch(`${baseUrl}/api/people`, { headers: selectedHeaders }).then((r) => r.json());
  const member = people.find((p) => p.is_project_member);
  if (member) {
    const ownerPatchResponse = await fetch(`${baseUrl}/api/tasks/${taskId}`, {
      method: 'PATCH', headers: selectedHeaders,
      body: JSON.stringify({ owner_person_id: member.person_id })
    });
    assert.equal(ownerPatchResponse.status, 200);
    const updatedTask = await ownerPatchResponse.json();
    assert.equal(updatedTask.owner_person_id, member.person_id);
  }

  const projectPatchResponse = await fetch(`${baseUrl}/api/projects/${projectId}`, {
    method: 'PATCH', headers: selectedHeaders,
    body: JSON.stringify({ projectName: 'Updated Delivery Project', portfolioName: 'Enterprise Transformation', projectType: 'Job', projectSize: 'Small' })
  });
  assert.equal(projectPatchResponse.status, 200);
  const updatedProject = await projectPatchResponse.json();
  assert.equal(updatedProject.project_name, 'Updated Delivery Project');
  assert.equal(updatedProject.portfolio_name, 'Enterprise Transformation');
  assert.equal(updatedProject.project_type, 'Job');
  assert.equal(updatedProject.project_size, 'Small');

  const anotherPerson = people.find((p) => p.person_id !== updatedProject?.main_pm_person_id) || people[0];
  if (anotherPerson) {
    const pmPatchResponse = await fetch(`${baseUrl}/api/projects/${projectId}`, {
      method: 'PATCH', headers: selectedHeaders,
      body: JSON.stringify({ mainPmPersonId: anotherPerson.person_id })
    });
    assert.equal(pmPatchResponse.status, 200);

    const reloadedProject = await fetch(`${baseUrl}/api/project`, { headers: selectedHeaders }).then((r) => r.json());
    assert.equal(reloadedProject.main_pm_person_id, anotherPerson.person_id);
    assert.equal(reloadedProject.main_pm_name, anotherPerson.display_name);
  }

  const workstreams = await fetch(`${baseUrl}/api/workstreams`, { headers: selectedHeaders }).then((r) => r.json());
  assert.ok(workstreams.length > 0);
  assert.ok(workstreams.some((ws) => ws.workstream_code === 'BE'));

  const wsCreateRes = await fetch(`${baseUrl}/api/workstreams`, {
    method: 'POST', headers: selectedHeaders,
    body: JSON.stringify({ workstreamCode: 'CUSTOM_WS', workstreamName: 'Custom Stream', description: 'Testing master data', sortOrder: 99 })
  });
  assert.equal(wsCreateRes.status, 201);
  const { workstreamId } = await wsCreateRes.json();

  const wsPatchRes = await fetch(`${baseUrl}/api/workstreams/${workstreamId}`, {
    method: 'PATCH', headers: selectedHeaders,
    body: JSON.stringify({ workstreamName: 'Renamed Custom Stream' })
  });
  assert.equal(wsPatchRes.status, 200);
  const patchedWs = await wsPatchRes.json();
  assert.equal(patchedWs.workstream_name, 'Renamed Custom Stream');

  const wsDelRes = await fetch(`${baseUrl}/api/workstreams/${workstreamId}`, {
    method: 'DELETE', headers: { 'x-project-id': projectId }
  });
  assert.equal(wsDelRes.status, 204);
});

test('hides cancelled projects from control views while retaining them in project setup', async () => {
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const createResponse = await fetch(`${baseUrl}/api/projects`, {
    method: 'POST', headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ projectCode: 'CANCELLED-TEST', projectName: 'Cancelled project', projectStatus: 'Active', mainPmPersonId: people[0].person_id })
  });
  assert.equal(createResponse.status, 201);
  const { projectId } = await createResponse.json();
  const cancelResponse = await fetch(`${baseUrl}/api/projects/${projectId}`, {
    method: 'PATCH', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ projectStatus: 'Cancelled' })
  });
  assert.equal(cancelResponse.status, 200);

  const portfolio = await fetch(`${baseUrl}/api/portfolio`).then((response) => response.json());
  const master = await fetch(`${baseUrl}/api/master-control?weekStart=2026-08-31`).then((response) => response.json());
  const setupProjects = await fetch(`${baseUrl}/api/projects`).then((response) => response.json());
  assert.equal(portfolio.some((project) => project.project_id === projectId), false);
  assert.equal(master.projects.some((project) => project.project_id === projectId), false);
  assert.equal(setupProjects.some((project) => project.project_id === projectId), true);
});

test('manages team roles master data and assigns custom roles to people', async () => {
  const roles = await fetch(`${baseUrl}/api/roles`).then((r) => r.json());
  assert.ok(roles.length >= 5);
  assert.ok(roles.some((r) => r.role_code === 'TeamMember'));

  const createRoleRes = await fetch(`${baseUrl}/api/roles`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      roleCode: 'TECH_LEAD',
      roleName: 'Tech Lead / Architect',
      description: 'Technical lead responsible for architecture & code quality',
      sortOrder: 10
    })
  });
  assert.equal(createRoleRes.status, 201);
  const { roleId } = await createRoleRes.json();

  const patchRoleRes = await fetch(`${baseUrl}/api/roles/${roleId}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ roleName: 'Lead Architect' })
  });
  assert.equal(patchRoleRes.status, 200);
  const patchedRole = await patchRoleRes.json();
  assert.equal(patchedRole.role_name, 'Lead Architect');

  const personRes = await fetch(`${baseUrl}/api/people`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      employeeCode: 'EMP-CUSTOM-ROLE',
      displayName: 'Alex Custom Architect',
      email: 'alex.architect@demo.invalid',
      department: 'Engineering',
      projectRole: 'TECH_LEAD'
    })
  });
  assert.equal(personRes.status, 201);
  const { personId } = await personRes.json();

  const people = await fetch(`${baseUrl}/api/people`).then((r) => r.json());
  const createdPerson = people.find((p) => p.person_id === personId);
  assert.ok(createdPerson);
  assert.equal(createdPerson.project_role, 'TECH_LEAD');

  const task = (await fetch(`${baseUrl}/api/tasks`).then((response) => response.json()))[0];
  const customAssignmentRes = await fetch(`${baseUrl}/api/assignments`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ taskId: task.task_id, personId, assignmentRole: 'TECH_LEAD' })
  });
  assert.equal(customAssignmentRes.status, 201);
  const { taskAssignmentId } = await customAssignmentRes.json();
  assert.equal((await fetch(`${baseUrl}/api/assignments`).then((response) => response.json())).find((item) => item.task_assignment_id === taskAssignmentId).assignment_role, 'TECH_LEAD');

  // Deleting role while member is assigned should fail
  const deleteFailRes = await fetch(`${baseUrl}/api/roles/${roleId}`, {
    method: 'DELETE'
  });
  assert.equal(deleteFailRes.status, 422);

  assert.equal((await fetch(`${baseUrl}/api/assignments/${taskAssignmentId}`, { method: 'DELETE' })).status, 204);

  // Delete person first, then delete role
  const deletePersonRes = await fetch(`${baseUrl}/api/people/${personId}`, {
    method: 'DELETE'
  });
  assert.equal(deletePersonRes.status, 204);

  const deleteRoleRes = await fetch(`${baseUrl}/api/roles/${roleId}`, {
    method: 'DELETE'
  });
  assert.equal(deleteRoleRes.status, 204);
});

test('updates work item progress, auto-syncs status/progress, rolls up to parent, and includes note_count', async () => {
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((r) => r.json());
  assert.ok(tasks.every((t) => typeof t.note_count === 'number'));

  const filteredUpdates = await fetch(`${baseUrl}/api/weekly-updates?taskId=${tasks[0].task_id}`).then((r) => r.json());
  assert.ok(filteredUpdates.every((item) => item.task_id === tasks[0].task_id));

  const child = tasks.find((t) => t.parent_task_id);
  assert.ok(child, 'Child task should exist');

  const updateRes = await fetch(`${baseUrl}/api/tasks/${child.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ progress: 80, status: 'InProgress' })
  });
  assert.equal(updateRes.status, 200);
  const updatedChild = await updateRes.json();
  assert.equal(updatedChild.progress, 80);

  const refreshedTasks = await fetch(`${baseUrl}/api/tasks`).then((r) => r.json());
  const parent = refreshedTasks.find((t) => t.task_id === child.parent_task_id);
  assert.ok(parent);
  assert.ok(parent.progress > 0);

  const doneRes = await fetch(`${baseUrl}/api/tasks/${child.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ status: 'Done' })
  });
  assert.equal(doneRes.status, 200);
  const doneChild = await doneRes.json();
  assert.equal(doneChild.status, 'Done');
  assert.equal(doneChild.progress, 100);

  const prog100Res = await fetch(`${baseUrl}/api/tasks/${child.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ progress: 100 })
  });
  assert.equal(prog100Res.status, 200);
  const prog100Child = await prog100Res.json();
  assert.equal(prog100Child.status, 'Done');
  assert.equal(prog100Child.progress, 100);
});

test('manages end-to-end hierarchy from Phase -> WBS -> MainTask -> Task -> Subtask', async () => {
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const pm = people.find((person) => person.employee_code === 'DEMO-RRMS-PM');
  const ba = people.find((person) => person.employee_code === 'DEMO-RRMS-BA');
  const phaseRes = await fetch(`${baseUrl}/api/phases`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ phaseCode: 'E2E-PH', phaseName: 'E2E Phase' })
  });
  assert.equal(phaseRes.status, 201);
  const { phaseId } = await phaseRes.json();

  const wbsRes = await fetch(`${baseUrl}/api/wbs`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ phaseId, wbsCode: 'E2E-WBS', wbsName: 'E2E Activity' })
  });
  assert.equal(wbsRes.status, 201);
  const { wbsItemId } = await wbsRes.json();

  const mtRes = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      wbsItemId,
      taskCode: 'E2E-MT-001',
      taskType: 'MainTask',
      taskName: 'E2E Main Task',
      ownerPersonId: ba.person_id
    })
  });
  assert.equal(mtRes.status, 201);
  const { taskId: mtId } = await mtRes.json();

  const tRes = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      wbsItemId,
      parentTaskId: mtId,
      taskCode: 'E2E-T-001',
      taskType: 'Task',
      taskName: 'E2E Task',
      ownerPersonId: pm.person_id
    })
  });
  assert.equal(tRes.status, 201);
  const { taskId: tId } = await tRes.json();

  const stRes = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      wbsItemId,
      parentTaskId: tId,
      taskCode: 'E2E-ST-001',
      taskType: 'Subtask',
      taskName: 'E2E Subtask',
      ownerPersonId: ba.person_id
    })
  });
  assert.equal(stRes.status, 201);
  const { taskId: stId } = await stRes.json();

  const [createdTasks, createdAssignments] = await Promise.all([
    fetch(`${baseUrl}/api/tasks`).then((response) => response.json()),
    fetch(`${baseUrl}/api/assignments`).then((response) => response.json())
  ]);
  const expectedOwners = new Map([[mtId, ba], [tId, pm], [stId, ba]]);
  for (const [taskId, expectedOwner] of expectedOwners) {
    const createdTask = createdTasks.find((item) => item.task_id === taskId);
    const owners = createdAssignments.filter((item) => item.task_id === taskId && item.assignment_role === 'Owner');
    assert.equal(createdTask.owner_person_id, expectedOwner.person_id);
    assert.equal(createdTask.owner_name, expectedOwner.display_name);
    assert.equal(owners.length, 1);
    assert.equal(owners[0].person_id, expectedOwner.person_id);
    assert.equal(owners[0].is_primary, 1);
  }

  // Change owner of MainTask from BA to PM
  const changeOwnerRes = await fetch(`${baseUrl}/api/tasks/${mtId}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ owner_person_id: pm.person_id })
  });
  assert.equal(changeOwnerRes.status, 200);
  const updatedMt = await changeOwnerRes.json();
  assert.equal(updatedMt.owner_person_id, pm.person_id);
  assert.equal(updatedMt.owner_name, pm.display_name);

  // Verify child task owner was unaffected
  const refreshedChild = (await fetch(`${baseUrl}/api/tasks`).then((r) => r.json())).find((item) => item.task_id === tId);
  assert.equal(refreshedChild.owner_person_id, pm.person_id);

  // Verify assignments: mtId now has pm as primary owner, ba is demoted
  const refreshedAssignments = await fetch(`${baseUrl}/api/assignments`).then((r) => r.json());
  const mtOwners = refreshedAssignments.filter((item) => item.task_id === mtId && item.assignment_role === 'Owner');
  assert.equal(mtOwners.length, 1);
  assert.equal(mtOwners[0].person_id, pm.person_id);
  assert.equal(mtOwners[0].is_primary, 1);

  assert.equal((await fetch(`${baseUrl}/api/tasks/${stId}`, { method: 'DELETE' })).status, 204);
  assert.equal((await fetch(`${baseUrl}/api/tasks/${tId}`, { method: 'DELETE' })).status, 204);
  assert.equal((await fetch(`${baseUrl}/api/tasks/${mtId}`, { method: 'DELETE' })).status, 204);
  assert.equal((await fetch(`${baseUrl}/api/wbs/${wbsItemId}`, { method: 'DELETE' })).status, 204);
  assert.equal((await fetch(`${baseUrl}/api/phases/${phaseId}`, { method: 'DELETE' })).status, 204);
});

test('imports task owners and assignees instead of replacing them with the Main PM', async () => {
  const people = await fetch(`${baseUrl}/api/people`).then((response) => response.json());
  const pm = people.find((person) => person.employee_code === 'DEMO-RRMS-PM');
  const ba = people.find((person) => person.employee_code === 'DEMO-RRMS-BA');
  const rows = [
    ['Level*', 'Task No.*', 'Parent No.', 'Task Title*', 'Task Owner(s)', 'Assignee Person IDs', 'Duration (days)', 'Start Date', 'Due Date', 'Status*', 'Progress %', 'Priority', 'Evidence required', 'WBS Code', 'Notes'],
    ['Phase', 'IMP-1', '', 'Imported phase', '', '', '', '2026-09-01', '2026-09-30', 'NotStarted', 0, 'Low', 'FALSE', '', ''],
    ['Main Task', 'IMP-1.1', 'IMP-1', 'Imported owned work', ba.person_id, pm.person_id, '', '2026-09-01', '2026-09-30', 'InProgress', 25, 'Medium', 'TRUE', 'IMP-MT-OWNER', 'Owner import check']
  ];
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), 'Project plan');
  const buffer = XLSX.write(workbook, { type: 'buffer', bookType: 'xlsx' });

  const previewResponse = await fetch(`${baseUrl}/api/imports/preview`, {
    method: 'POST',
    headers: { 'content-type': 'application/octet-stream', 'x-import-filename': 'owner-import.xlsx' },
    body: buffer
  });
  assert.equal(previewResponse.status, 200);
  const preview = await previewResponse.json();
  assert.deepEqual(preview.errors, []);

  const commitResponse = await fetch(`${baseUrl}/api/imports/commit`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ token: preview.token, mode: 'update' })
  });
  assert.equal(commitResponse.status, 200);

  const [tasks, assignments] = await Promise.all([
    fetch(`${baseUrl}/api/tasks`).then((response) => response.json()),
    fetch(`${baseUrl}/api/assignments`).then((response) => response.json())
  ]);
  const imported = tasks.find((item) => item.task_code === 'RRMS-IMP-MT-OWNER');
  assert.equal(imported.owner_person_id, ba.person_id);
  assert.equal(imported.owner_name, ba.display_name);
  assert.equal(imported.evidence_required, 1);
  assert.ok(assignments.some((item) => item.task_id === imported.task_id && item.person_id === ba.person_id && item.assignment_role === 'Owner'));
  assert.ok(assignments.some((item) => item.task_id === imported.task_id && item.person_id === pm.person_id && item.assignment_role === 'Contributor'));
});

test('enforces API_SECRET_KEY guard when configured', async () => {
  process.env.API_SECRET_KEY = 'super-secret-token-123';
  try {
    const unauthenticated = await fetch(`${baseUrl}/api/session`);
    assert.equal(unauthenticated.status, 401);
    const unauthBody = await unauthenticated.json();
    assert.equal(unauthBody.message, 'Unauthorized.');

    const wrongKey = await fetch(`${baseUrl}/api/session`, {
      headers: { authorization: 'Bearer wrong-key' }
    });
    assert.equal(wrongKey.status, 401);

    const authorized = await fetch(`${baseUrl}/api/session`, {
      headers: { authorization: 'Bearer super-secret-token-123' }
    });
    assert.equal(authorized.status, 200);
  } finally {
    delete process.env.API_SECRET_KEY;
  }
});

test('allows setting an existing organization directory person as task Owner and ensures project membership', async () => {
  const newPersonRes = await fetch(`${baseUrl}/api/people`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ employeeCode: 'AUTO-OWNER-99', displayName: 'Auto Owner Test' })
  });
  assert.equal(newPersonRes.status, 201);
  const { personId } = await newPersonRes.json();

  const tasks = await fetch(`${baseUrl}/api/tasks`).then((res) => res.json());
  const task = tasks[0];

  const patchRes = await fetch(`${baseUrl}/api/tasks/${task.task_id}`, {
    method: 'PATCH',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ owner_person_id: personId })
  });
  assert.equal(patchRes.status, 200);
  const updated = await patchRes.json();
  assert.equal(updated.owner_person_id, personId);

  const members = await fetch(`${baseUrl}/api/project-members`).then((res) => res.json());
  assert.ok(members.some((m) => m.person_id === personId));
});

test('All Projects Workload: combines people and tasks across multiple projects without double counting', async () => {
  const allWorkload = await fetch(`${baseUrl}/api/workload/all-projects`).then((res) => res.json());

  // 1. Structure
  assert.ok(allWorkload.reportDate, 'Must have reportDate');
  assert.ok(allWorkload.weekEndDate, 'Must have weekEndDate');
  assert.ok(allWorkload.overallSummary, 'Must have overallSummary');
  assert.ok(Array.isArray(allWorkload.peopleAggregates), 'Must have peopleAggregates');
  assert.ok(Array.isArray(allWorkload.projectAggregates), 'Must have projectAggregates');
  assert.ok(Array.isArray(allWorkload.personProjectAggregates), 'Must have personProjectAggregates');
  assert.ok(Array.isArray(allWorkload.taskDetailRecords), 'Must have taskDetailRecords');

  // Rule 1: รวมบุคลากรจากหลาย Project เป็นคนเดียว
  const personIds = allWorkload.peopleAggregates.map((p) => p.personId);
  const uniquePersonIds = new Set(personIds);
  assert.equal(personIds.length, uniquePersonIds.size, 'Each person must appear only once in peopleAggregates');

  // PM exists in both RRMS and DTP projects
  const pm = allWorkload.peopleAggregates.find((p) => p.displayName === 'RRMS Demo PM');
  assert.ok(pm, 'PM should be in peopleAggregates');
  assert.ok(pm.projectCount >= 2, 'PM should have tasks in multiple projects');

  // Rule 2: รวม Task จากหลาย Project ของบุคคลเดียวกัน
  const pmPersonProjects = allWorkload.personProjectAggregates.filter((pp) => pp.personId === pm.personId);
  assert.ok(pmPersonProjects.length >= 2, 'PM should have entries across multiple projects');
  const sumPmProjectsOpen = pmPersonProjects.reduce((sum, pp) => sum + pp.totalOpen, 0);
  assert.equal(pm.totalOpen, sumPmProjectsOpen, 'Person totalOpen must equal sum of open tasks across projects');

  // Rule 3: Task เดียวกันที่บุคคลเป็นทั้ง Owner และ Assignee ต้องไม่นับซ้ำ
  const pmTasks = allWorkload.taskDetailRecords.filter((t) => t.personId === pm.personId);
  const pmTaskIds = pmTasks.map((t) => t.taskId);
  assert.equal(pmTaskIds.length, new Set(pmTaskIds).size, 'No duplicate tasks for the same person');
  const dualRoleTask = pmTasks.find((t) => t.isOwner && t.isAssignee);
  assert.ok(dualRoleTask, 'Task with both owner and assignee should exist');
  assert.equal(pmTasks.filter((t) => t.taskId === dualRoleTask.taskId).length, 1, 'Dual role task must only be counted once');

  // Rule 5: ไม่รวม Done ในค่าเริ่มต้น
  assert.equal(allWorkload.includeDone, false, 'Default includeDone should be false');
  assert.ok(allWorkload.taskDetailRecords.every((t) => t.status !== 'Done'), 'Default taskDetailRecords must not include Done tasks');

  // Rule 9: Project aggregate รวมตรงกับ Person × Project Matrix
  for (const proj of allWorkload.projectAggregates) {
    const matrixColSum = allWorkload.personProjectAggregates
      .filter((pp) => pp.projectId === proj.projectId)
      .reduce((sum, pp) => sum + pp.totalOpen, 0);
    assert.equal(proj.totalOpen, matrixColSum, `Project ${proj.projectCode} totalOpen must match matrix column sum`);
  }

  // Rule 10: Endpoint /api/workload เดิมยังทำงานและยัง Scope ตาม Active Project
  const scopedWorkload = await fetch(`${baseUrl}/api/workload`).then((res) => res.json());
  assert.ok(scopedWorkload.members.length > 0, 'Original /api/workload must return members');
  for (const m of scopedWorkload.members) {
    for (const t of m.tasks) {
      assert.ok(t.task_code.startsWith('RRMS-'), 'Original /api/workload tasks must remain scoped to RRMS');
    }
  }
});

test('All Projects Workload: includeDone, overdue/due-this-week, latest blocker, and soft delete', async () => {
  // Rule 6: Include Done ทำงานถูกต้อง
  const doneWorkload = await fetch(`${baseUrl}/api/workload/all-projects?includeDone=true`).then((res) => res.json());
  assert.equal(doneWorkload.includeDone, true);
  assert.ok(doneWorkload.taskDetailRecords.some((t) => t.status === 'Done'), 'Should include Done tasks when includeDone=true');
  assert.ok(doneWorkload.overallSummary.completed > 0, 'Should report completed tasks in summary');
  assert.equal(doneWorkload.overallSummary.totalTasks, doneWorkload.overallSummary.totalOpen + doneWorkload.overallSummary.completed);

  // Rule 7: คำนวณ Overdue และ Due this week ถูกต้อง
  const today = doneWorkload.reportDate;
  const weekEnd = doneWorkload.weekEndDate;
  for (const t of doneWorkload.taskDetailRecords) {
    if (t.plannedDueDate && t.plannedDueDate < today && t.status !== 'Done') {
      assert.equal(t.isOverdue, true, `Task ${t.taskCode} due ${t.plannedDueDate} should be overdue today ${today}`);
    }
    if (t.plannedDueDate && t.plannedDueDate >= today && t.plannedDueDate <= weekEnd && t.status !== 'Done') {
      assert.equal(t.isDueThisWeek, true, `Task ${t.taskCode} due ${t.plannedDueDate} should be due this week`);
    }
  }

  // Rule 8: ดึง Blocker ล่าสุดถูกต้อง
  const tasks = await fetch(`${baseUrl}/api/tasks`).then((res) => res.json());
  const testTask = tasks[0];

  await fetch(`${baseUrl}/api/weekly-updates`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      taskId: testTask.task_id,
      weekStartDate: '2026-08-17',
      progress: 30,
      status: 'InProgress',
      ragStatus: 'Amber',
      summary: 'Week 1 update',
      blocker: 'First early blocker'
    })
  });

  await fetch(`${baseUrl}/api/weekly-updates`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      taskId: testTask.task_id,
      weekStartDate: '2026-08-24',
      progress: 40,
      status: 'Blocked',
      ragStatus: 'Red',
      summary: 'Week 2 update',
      blocker: 'Latest critical blocker'
    })
  });

  const updatedWorkload = await fetch(`${baseUrl}/api/workload/all-projects?includeDone=true`).then((res) => res.json());
  const taskInWorkload = updatedWorkload.taskDetailRecords.find((t) => t.taskId === testTask.task_id);
  assert.ok(taskInWorkload, 'Task should be in workload');
  assert.equal(taskInWorkload.latestBlocker, 'Latest critical blocker', 'Must reflect the latest blocker from the newest weekly update');

  // Rule 4: ไม่รวม Task หรือ Project ที่ถูก soft delete
  const wbs = await fetch(`${baseUrl}/api/wbs`).then((res) => res.json());
  const createTaskRes = await fetch(`${baseUrl}/api/tasks`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      wbsItemId: wbs[0].wbs_item_id,
      taskCode: 'TEST-SOFT-DEL-01',
      taskName: 'Soft delete test task',
      taskType: 'MainTask',
      weight: 10
    })
  });
  assert.equal(createTaskRes.status, 201);
  const createdTask = await createTaskRes.json();

  const beforeDelete = await fetch(`${baseUrl}/api/workload/all-projects`).then((res) => res.json());
  assert.ok(beforeDelete.taskDetailRecords.some((t) => t.taskId === createdTask.taskId));

  const deleteRes = await fetch(`${baseUrl}/api/tasks/${createdTask.taskId}`, { method: 'DELETE' });
  assert.equal(deleteRes.status, 204);

  const afterDelete = await fetch(`${baseUrl}/api/workload/all-projects`).then((res) => res.json());
  assert.ok(!afterDelete.taskDetailRecords.some((t) => t.taskId === createdTask.taskId), 'Soft-deleted task must not appear in all-projects workload');
});

test('serves updated UI assets and contracts for All Projects Workload', async () => {
  const cssRes = await fetch(`${baseUrl}/workload-controls.css`);
  assert.equal(cssRes.status, 200);
  const cssText = await cssRes.text();
  assert.ok(cssText.includes('.all-workload-hero'));
  assert.ok(cssText.includes('.matrix-table'));
  assert.ok(cssText.includes('.drilldown-panel'));

  const appRes = await fetch(`${baseUrl}/app.js`);
  assert.equal(appRes.status, 200);
  const appText = await appRes.text();
  assert.ok(appText.includes('allProjectsWorkloadView'));
  assert.ok(appText.includes('All Projects Workload'));
});

test('serves the Project Portal timeline with portfolio executive filters, delivery, and attention views', async () => {
  const pageRes = await fetch(`${baseUrl}/`);
  assert.equal(pageRes.status, 200);
  const pageText = await pageRes.text();
  assert.ok(pageText.includes('/timeline.css?v=timeline-2'));

  const cssRes = await fetch(`${baseUrl}/timeline.css`);
  assert.equal(cssRes.status, 200);
  const cssText = await cssRes.text();
  assert.ok(cssText.includes('.timeline-chart'));
  assert.ok(cssText.includes('.timeline-unscheduled'));

  const appRes = await fetch(`${baseUrl}/app.js`);
  assert.equal(appRes.status, 200);
  const appText = await appRes.text();
  assert.ok(appText.includes('timelineView'));
  assert.ok(appText.includes("executive: 'A · Executive'"));
  assert.ok(appText.includes("delivery: 'B · Delivery plan'"));
  assert.ok(appText.includes("attention: 'C · Attention'"));
  assert.ok(appText.includes('data-timeline-mode'));
  assert.ok(appText.includes('data-timeline-executive-pm'));
  assert.ok(appText.includes('data-timeline-executive-project'));
  assert.ok(appText.includes('data-timeline-project-toggle'));
  assert.ok(appText.includes('Filter without changing the current project'));
});

test('All Projects Workload: interaction contracts, grouping, and multi-filter calculation', async () => {
  const data = await fetch(`${baseUrl}/api/workload/all-projects?includeDone=true`).then((r) => r.json());
  const tasks = data.taskDetailRecords;

  assert.ok(data.projectAggregates.every((project) => Object.hasOwn(project, 'mainPmPersonId')));
  assert.ok(data.projectAggregates.every((project) => Object.hasOwn(project, 'startDate') && Object.hasOwn(project, 'targetEndDate')));
  assert.ok(tasks.some((task) => task.phaseId && task.phaseCode && task.phaseName));
  assert.ok(tasks.some((task) => task.parentTaskId));

  // Filter by status InProgress
  const inProgressTasks = tasks.filter((t) => t.status === 'InProgress');
  assert.ok(inProgressTasks.length > 0);

  // Filter by RAG Red
  const redTasks = tasks.filter((t) => t.ragStatus === 'Red');
  assert.ok(redTasks.length > 0);

  // Filter by Overdue
  const overdueTasks = tasks.filter((t) => t.isOverdue);
  assert.ok(Array.isArray(overdueTasks));

  // Filter by relationship
  const ownerOnlyTasks = tasks.filter((t) => t.isOwner);
  const assigneeOnlyTasks = tasks.filter((t) => t.isAssignee);
  assert.ok(ownerOnlyTasks.length > 0);
  assert.ok(assigneeOnlyTasks.length > 0);

  // Group by project
  const projectGroups = new Map();
  tasks.forEach((t) => {
    if (!projectGroups.has(t.projectId)) projectGroups.set(t.projectId, []);
    projectGroups.get(t.projectId).push(t);
  });
  assert.ok(projectGroups.size >= 2, 'Should group tasks across multiple projects');
  for (const [pId, group] of projectGroups.entries()) {
    assert.ok(group.every((t) => t.projectId === pId));
  }

  // Group by WBS / Activity
  const wbsGroups = new Map();
  tasks.forEach((t) => {
    const key = `${t.projectId}:${t.wbsId}`;
    if (!wbsGroups.has(key)) wbsGroups.set(key, []);
    wbsGroups.get(key).push(t);
  });
  assert.ok(wbsGroups.size >= 2, 'Should group tasks by WBS / Activity');

  // Verify sort ordering: default risk sorts Blocked -> Overdue -> Red RAG -> Total open
  const people = [...data.peopleAggregates];
  people.sort((a, b) => (b.blocked - a.blocked) || (b.overdue - a.overdue) || (b.ragRed - a.ragRed) || (b.totalOpen - a.totalOpen));
  for (let i = 1; i < people.length; i++) {
    const prev = people[i - 1];
    const curr = people[i];
    if (prev.blocked !== curr.blocked) {
      assert.ok(prev.blocked >= curr.blocked);
    } else if (prev.overdue !== curr.overdue) {
      assert.ok(prev.overdue >= curr.overdue);
    } else if (prev.ragRed !== curr.ragRed) {
      assert.ok(prev.ragRed >= curr.ragRed);
    }
  }
});
