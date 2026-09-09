import fs from 'node:fs/promises';
import { randomUUID } from 'node:crypto';
import Database from 'better-sqlite3';
import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const workbookPath = 'D:/project/MVP Project/lean-project-control/outputs/rrms-hierarchical-review/RRMS_Hierarchical_Project_Plan_Review.xlsx';
const databasePath = 'D:/project/MVP Project/lean-project-control/data/lean-project-control.db';
const resultPath = 'D:/project/MVP Project/lean-project-control/outputs/rrms-hierarchical-review/import-result.json';
const source = await FileBlob.load(workbookPath);
const workbook = await SpreadsheetFile.importXlsx(source);
const sheet = workbook.worksheets.getItem('Project plan');
const projectInfo = sheet.getRange('A6:H6').values[0];

function asDate(value) { return value instanceof Date ? value.toISOString().slice(0, 10) : typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value) ? value : null; }
function asBool(value) { return String(value || '').trim().toUpperCase() === 'TRUE'; }
function ragFor(priority) { return priority === 'High' ? 'Red' : priority === 'Medium' ? 'Amber' : 'Green'; }
const planRows = sheet.getRange('A10:O200').values.filter((row) => row[0] && row[1]).map((row) => ({
  level: String(row[0]), taskNo: String(row[1]), parentNo: row[2] ? String(row[2]) : '', title: String(row[3] || ''),
  startDate: asDate(row[7]), dueDate: asDate(row[8]), status: String(row[9] || 'NotStarted'), progress: Number(row[10]) || 0,
  priority: String(row[11] || 'Medium'), evidenceRequired: asBool(row[12]), sourceCode: String(row[13] || ''), notes: String(row[14] || '')
}));
const phases = planRows.filter((row) => row.level === 'Phase');
const items = planRows.filter((row) => row.level !== 'Phase');
if (!phases.length || !items.length) throw new Error('No valid Phase and work-item rows were found.');

const db = new Database(databasePath);
db.pragma('foreign_keys = ON');
const project = db.prepare("SELECT * FROM projects WHERE project_code = 'RRMS' AND deleted_at IS NULL").get();
if (!project) throw new Error('RRMS project was not found.');
const actorId = project.main_pm_person_id;
const audit = (action, entityType, entityId, before, after) => db.prepare(`INSERT INTO audit_logs (audit_log_id, actor_person_id, action, entity_type, entity_id, before_snapshot, after_snapshot)
  VALUES (?, ?, ?, ?, ?, ?, ?)`).run(randomUUID(), actorId, action, entityType, entityId, before ? JSON.stringify(before) : null, after ? JSON.stringify(after) : null);

const importPlan = db.transaction(() => {
  const existingTasks = db.prepare('SELECT * FROM tasks WHERE project_id = ? AND deleted_at IS NULL').all(project.project_id);
  const existingWbs = db.prepare('SELECT * FROM wbs_items WHERE project_id = ? AND deleted_at IS NULL').all(project.project_id);
  const existingPhases = db.prepare('SELECT * FROM project_phases WHERE project_id = ? AND deleted_at IS NULL').all(project.project_id);
  const taskIds = existingTasks.map((task) => task.task_id);
  if (taskIds.length) {
    const marks = taskIds.map(() => '?').join(',');
    db.prepare(`UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...taskIds);
    db.prepare(`UPDATE weekly_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...taskIds);
    db.prepare(`UPDATE weekly_plans SET task_id = NULL, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...taskIds);
    db.prepare(`UPDATE task_note_files SET deleted_at = CURRENT_TIMESTAMP WHERE task_note_id IN (SELECT task_note_id FROM task_notes WHERE task_id IN (${marks})) AND deleted_at IS NULL`).run(...taskIds);
    db.prepare(`UPDATE task_notes SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...taskIds);
    db.prepare(`UPDATE tasks SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks})`).run(...taskIds);
    for (const task of existingTasks) audit('task.archive_for_import', 'Task', task.task_id, task, null);
  }
  if (existingWbs.length) {
    db.prepare('UPDATE wbs_items SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND deleted_at IS NULL').run(project.project_id);
    for (const wbs of existingWbs) audit('activity.archive_for_import', 'ProjectActivity', wbs.wbs_item_id, wbs, null);
  }
  if (existingPhases.length) {
    db.prepare('UPDATE project_phases SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND deleted_at IS NULL').run(project.project_id);
    for (const phase of existingPhases) audit('phase.archive_for_import', 'ProjectPhase', phase.phase_id, phase, null);
  }

  const updatedProject = { projectName: String(projectInfo[1] || project.project_name), portfolioName: String(projectInfo[4] || project.portfolio_name || ''), projectType: String(projectInfo[2] || project.project_type || 'New'), projectSize: String(projectInfo[3] || project.project_size || 'Large'), startDate: asDate(projectInfo[6]), targetEndDate: asDate(projectInfo[7]), projectStatus: 'Active' };
  db.prepare(`UPDATE projects SET project_name = ?, portfolio_name = ?, project_type = ?, project_size = ?, start_date = ?, target_end_date = ?, project_status = ?, updated_at = CURRENT_TIMESTAMP WHERE project_id = ?`)
    .run(updatedProject.projectName, updatedProject.portfolioName || null, updatedProject.projectType, updatedProject.projectSize, updatedProject.startDate, updatedProject.targetEndDate, updatedProject.projectStatus, project.project_id);
  audit('project.import_update', 'Project', project.project_id, project, updatedProject);

  const phaseMap = new Map();
  const insertPhase = db.prepare(`INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
    VALUES (?, ?, ?, ?, ?, ?, ?)`);
  const insertWbs = db.prepare(`INSERT INTO wbs_items (wbs_item_id, project_id, wbs_code, wbs_name, sort_order, phase_id)
    VALUES (?, ?, ?, ?, ?, ?)`);
  for (let index = 0; index < phases.length; index += 1) {
    const row = phases[index]; const phaseId = randomUUID(); const wbsItemId = randomUUID(); const phaseCode = `RRMS-PH-${String(index + 1).padStart(2, '0')}`;
    insertPhase.run(phaseId, project.project_id, phaseCode, row.title, index + 1, row.startDate, row.dueDate);
    insertWbs.run(wbsItemId, project.project_id, phaseCode, row.title, index + 1, phaseId);
    phaseMap.set(row.taskNo, { phaseId, wbsItemId, phaseCode });
    audit('phase.import_create', 'ProjectPhase', phaseId, null, { phaseCode, phaseName: row.title });
    audit('activity.import_create', 'ProjectActivity', wbsItemId, null, { wbsCode: phaseCode, wbsName: row.title, phaseId });
  }

  const taskMap = new Map(); let currentPhaseNo = null; const taskWeight = Math.round((100 / items.length) * 100) / 100;
  const insertTask = db.prepare(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, status, rag_status, weight, progress, evidence_required)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`);
  const insertAssignment = db.prepare(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
    VALUES (?, ?, ?, 'Owner', 'Accountable', 1)`);
  const insertNote = db.prepare(`INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id)
    VALUES (?, ?, 'Note', ?, ?)`);
  for (const row of items) {
    const phaseNo = row.level === 'Main Task' ? row.parentNo : currentPhaseNo;
    if (row.level === 'Main Task') currentPhaseNo = row.parentNo;
    const phase = phaseMap.get(phaseNo);
    if (!phase) throw new Error(`No Phase resolved for ${row.taskNo}.`);
    const parentTaskId = row.level === 'Main Task' ? null : taskMap.get(row.parentNo);
    if (row.level !== 'Main Task' && !parentTaskId) throw new Error(`No parent resolved for ${row.taskNo}.`);
    const taskId = randomUUID(); const taskType = row.level === 'Main Task' ? 'MainTask' : row.level === 'Task' ? 'Task' : 'Subtask';
    const taskCode = `RRMS-${row.sourceCode || row.taskNo.replaceAll('.', '-')}`;
    insertTask.run(taskId, project.project_id, phase.wbsItemId, parentTaskId || null, taskCode, taskType, row.title, row.notes || null, actorId, row.startDate, row.dueDate, row.status, ragFor(row.priority), taskWeight, row.progress, row.evidenceRequired ? 1 : 0);
    insertAssignment.run(randomUUID(), taskId, actorId);
    taskMap.set(row.taskNo, taskId);
    audit('task.import_create', 'Task', taskId, null, { taskCode, taskName: row.title, taskType, phaseCode: phase.phaseCode });
    if (row.notes) { const noteId = randomUUID(); insertNote.run(noteId, taskId, row.notes, actorId); audit('task_note.import_create', 'TaskNote', noteId, null, { taskId, noteType: 'Note' }); }
  }
  return { archivedWorkItems: existingTasks.length, archivedActivities: existingWbs.length, archivedPhases: existingPhases.length, phases: phases.length, activities: phases.length, workItems: items.length, notes: items.filter((row) => row.notes).length };
});

let result;
try { result = importPlan(); } finally { db.close(); }
await fs.writeFile(resultPath, JSON.stringify({ projectCode: 'RRMS', ...result }, null, 2));
console.log(JSON.stringify({ projectCode: 'RRMS', ...result }));
