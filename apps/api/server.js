import { randomUUID } from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import Fastify from 'fastify';
import fastifyStatic from '@fastify/static';
import Database from 'better-sqlite3';
import XLSX from 'xlsx';

const fileName = fileURLToPath(import.meta.url);
const directoryName = path.dirname(fileName);
const root = path.resolve(directoryName, '../..');

// DATABASE_PROVIDER controls which database backend is active.
// 'sqlite' (default) — local better-sqlite3 file, used by all existing routes.
// 'postgres' — connects a pg.Pool for future incremental route migration;
//              existing routes still use the SQLite db object during transition.
const databaseProvider = (process.env.DATABASE_PROVIDER || 'sqlite').toLowerCase();

let db; // better-sqlite3 Database — populated for sqlite mode (required) and
        // also opened in postgres mode so seed/demo helpers continue to work
        // until route migration is complete.
let pgPool = null; // pg.Pool — populated only when DATABASE_PROVIDER=postgres

const databaseUrl = process.env.DATABASE_URL || 'file:./data/lean-project-control.db';

function ensureSqliteInitialized(databaseInstance) {
  const hasWbs = databaseInstance.prepare("SELECT 1 FROM sqlite_master WHERE type='table' AND name='wbs_items'").get();
  if (!hasWbs) {
    const schemaPath = path.join(root, 'database/sqlite/migrations/001_initial_schema.sql');
    const seedPath = path.join(root, 'database/sqlite/seeds/001_reference_data.sql');
    if (fs.existsSync(schemaPath)) databaseInstance.exec(fs.readFileSync(schemaPath, 'utf8'));
    if (fs.existsSync(seedPath)) databaseInstance.exec(fs.readFileSync(seedPath, 'utf8'));
  }
}

if (databaseProvider === 'postgres') {
  // Validate the PostgreSQL connection string.
  if (!databaseUrl.startsWith('postgres://') && !databaseUrl.startsWith('postgresql://')) {
    throw new Error('DATABASE_PROVIDER=postgres requires DATABASE_URL starting with postgres:// or postgresql://');
  }
  // Lazy-import pg so the package is only required when actually needed.
  const { default: pg } = await import('pg');
  pgPool = new pg.Pool({ connectionString: databaseUrl, max: 10, idleTimeoutMillis: 30000 });
  // Verify connectivity at startup.
  const client = await pgPool.connect();
  client.release();
  console.info('[db] Connected to PostgreSQL. Ensuring Supabase persistence storage tables.');

  // Create table in Supabase PostgreSQL to hold persistent snapshots and uploaded files
  await pgPool.query(`
    CREATE TABLE IF NOT EXISTS app_state_storage (
      key VARCHAR(100) PRIMARY KEY,
      data BYTEA NOT NULL,
      updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    CREATE TABLE IF NOT EXISTS task_note_attachments (
      storage_ref VARCHAR(300) PRIMARY KEY,
      file_data BYTEA NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
  `);

  // Open/initialize a local SQLite database for existing route handlers
  const fallbackPath = path.resolve(root, 'data/lean-project-control.db');
  fs.mkdirSync(path.dirname(fallbackPath), { recursive: true });
  const seedDbPath = path.resolve(root, 'database/sqlite/lean_seed.db');

  // Check if Supabase has a persistent snapshot
  const snapshotRes = await pgPool.query('SELECT data, updated_at FROM app_state_storage WHERE key = $1', ['lean_sqlite_db']);
  if (snapshotRes.rows.length && snapshotRes.rows[0].data) {
    fs.writeFileSync(fallbackPath, snapshotRes.rows[0].data);
    console.info(`[db] Restored persistent database from Supabase PostgreSQL (updated: ${snapshotRes.rows[0].updated_at}).`);
    db = new Database(fallbackPath);
    db.pragma('foreign_keys = ON');
    db.pragma('journal_mode = WAL');
  } else {
    let needCopy = !fs.existsSync(fallbackPath);
    if (!needCopy) {
      try {
        const testDb = new Database(fallbackPath);
        const hasEdoc = testDb.prepare("SELECT 1 FROM projects WHERE project_code = 'EDOC-2026'").get();
        testDb.close();
        if (!hasEdoc) needCopy = true;
      } catch {
        needCopy = true;
      }
    }
    if (needCopy && fs.existsSync(seedDbPath)) {
      fs.copyFileSync(seedDbPath, fallbackPath);
      console.info('[db] Loaded full database seed (all 5 projects, 108 tasks) into local database.');
    }
    db = new Database(fallbackPath);
    db.pragma('foreign_keys = ON');
    db.pragma('journal_mode = WAL');
    ensureSqliteInitialized(db);
    try {
      const initialBuf = db.serialize();
      await pgPool.query(`
        INSERT INTO app_state_storage (key, data, updated_at)
        VALUES ($1, $2, CURRENT_TIMESTAMP)
        ON CONFLICT (key) DO UPDATE SET data = EXCLUDED.data, updated_at = CURRENT_TIMESTAMP
      `, ['lean_sqlite_db', initialBuf]);
      console.info('[db] Seeded initial database to Supabase persistent storage.');
    } catch (persistErr) {
      console.warn('[db] Note on initial Supabase seed persist:', persistErr.message);
    }
  }
} else {
  // Default: SQLite mode — the original, unchanged path.
  if (!databaseUrl.startsWith('file:')) {
    throw new Error('DATABASE_PROVIDER=sqlite requires a file: DATABASE_URL. Set DATABASE_PROVIDER=postgres for a PostgreSQL connection string.');
  }
  const configuredDatabasePath = databaseUrl.slice('file:'.length);
  const databasePath = path.isAbsolute(configuredDatabasePath)
    ? configuredDatabasePath
    : path.resolve(root, configuredDatabasePath);
  fs.mkdirSync(path.dirname(databasePath), { recursive: true });
  db = new Database(databasePath);
  db.pragma('foreign_keys = ON');
  db.pragma('journal_mode = WAL');
  ensureSqliteInitialized(db);
}


const maxTaskNoteFileBytes = 5 * 1024 * 1024;
const taskNoteTransportLimitBytes = maxTaskNoteFileBytes + 1024;
// Upload directory is resolved relative to the SQLite file in sqlite mode,
// or to the process working directory in postgres mode.
const taskNoteUploadDirectory = databaseProvider === 'postgres'
  ? path.resolve(root, 'data/uploads/task-notes')
  : (() => {
    const configuredPath = databaseUrl.slice('file:'.length);
    const dbFilePath = path.isAbsolute(configuredPath) ? configuredPath : path.resolve(root, configuredPath);
    return path.resolve(path.dirname(dbFilePath), 'uploads/task-notes');
  })();

// The pilot database predates implementation phases. Keep this idempotent so an
// existing workspace is upgraded without recreating (or losing) its data.
db.exec(`CREATE TABLE IF NOT EXISTS project_phases (
  phase_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  phase_code TEXT NOT NULL,
  phase_name TEXT NOT NULL,
  sort_order REAL NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  planned_start_date TEXT,
  planned_due_date TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT,
  UNIQUE (project_id, phase_code),
  CHECK (planned_due_date IS NULL OR planned_start_date IS NULL OR planned_due_date >= planned_start_date)
);
CREATE INDEX IF NOT EXISTS idx_project_phases_project ON project_phases(project_id, sort_order);

CREATE TABLE IF NOT EXISTS project_workstreams (
  workstream_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  workstream_code TEXT NOT NULL,
  workstream_name TEXT NOT NULL,
  description TEXT,
  sort_order REAL NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT,
  UNIQUE (project_id, workstream_code)
);
CREATE INDEX IF NOT EXISTS idx_project_workstreams_project ON project_workstreams(project_id, sort_order);

CREATE TABLE IF NOT EXISTS project_roles (
  role_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  role_code TEXT NOT NULL,
  role_name TEXT NOT NULL,
  description TEXT,
  sort_order REAL NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT,
  UNIQUE (project_id, role_code)
);
CREATE INDEX IF NOT EXISTS idx_project_roles_project ON project_roles(project_id, sort_order);

CREATE TABLE IF NOT EXISTS task_notes (
  task_note_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL REFERENCES tasks(task_id),
  note_type TEXT NOT NULL CHECK (note_type IN ('Note', 'Update')),
  note_text TEXT NOT NULL DEFAULT '',
  created_by_person_id TEXT NOT NULL REFERENCES people(person_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT
);
CREATE TABLE IF NOT EXISTS task_note_files (
  task_note_file_id TEXT PRIMARY KEY,
  task_note_id TEXT NOT NULL REFERENCES task_notes(task_note_id),
  original_file_name TEXT NOT NULL,
  file_type TEXT,
  file_size_bytes INTEGER NOT NULL CHECK (file_size_bytes > 0 AND file_size_bytes <= 5242880),
  storage_ref TEXT NOT NULL,
  uploaded_by_person_id TEXT NOT NULL REFERENCES people(person_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_task_notes_task ON task_notes(task_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_task_note_files_note ON task_note_files(task_note_id, created_at);

CREATE TABLE IF NOT EXISTS weekly_plans (
  weekly_plan_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  task_id TEXT REFERENCES tasks(task_id),
  week_start_date TEXT NOT NULL,
  plan_title TEXT NOT NULL,
  owner_person_id TEXT NOT NULL REFERENCES people(person_id),
  owner_role TEXT,
  target_outcome TEXT,
  planned_due_date TEXT,
  priority TEXT NOT NULL DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
  status TEXT NOT NULL DEFAULT 'Planned' CHECK (status IN ('Planned', 'InProgress', 'Done', 'Deferred')),
  created_by_person_id TEXT NOT NULL REFERENCES people(person_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_weekly_plans_project_week ON weekly_plans(project_id, week_start_date, status);
CREATE TABLE IF NOT EXISTS role_updates (
  role_update_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  week_start_date TEXT NOT NULL,
  person_id TEXT NOT NULL REFERENCES people(person_id),
  role_name TEXT NOT NULL,
  accomplished TEXT,
  next_actions TEXT,
  blocker TEXT,
  support_needed TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT,
  UNIQUE (project_id, week_start_date, person_id, role_name)
);
CREATE INDEX IF NOT EXISTS idx_role_updates_project_week ON role_updates(project_id, week_start_date);
`);
if (!db.prepare('PRAGMA table_info(wbs_items)').all().some((column) => column.name === 'phase_id')) {
  db.exec('ALTER TABLE wbs_items ADD COLUMN phase_id TEXT');
}
if (!db.prepare('PRAGMA table_info(tasks)').all().some((column) => column.name === 'workstream')) {
  db.exec('ALTER TABLE tasks ADD COLUMN workstream TEXT');
}
if (!db.prepare('PRAGMA table_info(projects)').all().some((column) => column.name === 'project_type')) {
  db.exec("ALTER TABLE projects ADD COLUMN project_type TEXT DEFAULT 'New'");
}
if (!db.prepare('PRAGMA table_info(projects)').all().some((column) => column.name === 'project_size')) {
  db.exec("ALTER TABLE projects ADD COLUMN project_size TEXT DEFAULT 'Medium'");
}
const projectMembersSql = db.prepare("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'project_members'").get()?.sql || '';
if (projectMembersSql.includes("CHECK (project_role IN")) {
  db.exec(`
    CREATE TABLE project_members_new (
      project_member_id TEXT PRIMARY KEY,
      project_id TEXT NOT NULL REFERENCES projects(project_id),
      person_id TEXT NOT NULL REFERENCES people(person_id),
      project_role TEXT NOT NULL,
      is_main_pm INTEGER NOT NULL DEFAULT 0 CHECK (is_main_pm IN (0,1)),
      active_from TEXT,
      active_to TEXT,
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      deleted_at TEXT,
      CHECK (active_to IS NULL OR active_from IS NULL OR active_to >= active_from),
      UNIQUE (project_id, person_id, project_role)
    );
    INSERT INTO project_members_new SELECT * FROM project_members;
    DROP TABLE project_members;
    ALTER TABLE project_members_new RENAME TO project_members;
    CREATE UNIQUE INDEX IF NOT EXISTS uq_project_members_active_main_pm ON project_members(project_id) WHERE is_main_pm = 1 AND deleted_at IS NULL;
  `);
}
const taskAssignmentsSql = db.prepare("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'task_assignments'").get()?.sql || '';
if (taskAssignmentsSql.includes("CHECK (assignment_role IN")) {
  db.exec(`
    CREATE TABLE task_assignments_new (
      task_assignment_id TEXT PRIMARY KEY,
      task_id TEXT NOT NULL REFERENCES tasks(task_id),
      person_id TEXT NOT NULL REFERENCES people(person_id),
      assignment_role TEXT NOT NULL,
      raci_role TEXT CHECK (raci_role IN ('Responsible','Accountable','Consulted','Informed')),
      allocation_percent REAL CHECK (allocation_percent IS NULL OR allocation_percent BETWEEN 0 AND 100),
      is_primary INTEGER NOT NULL DEFAULT 0 CHECK (is_primary IN (0,1)),
      created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      deleted_at TEXT,
      UNIQUE (task_id, person_id, assignment_role)
    );
    INSERT INTO task_assignments_new SELECT * FROM task_assignments;
    DROP TABLE task_assignments;
    ALTER TABLE task_assignments_new RENAME TO task_assignments;
  `);
}

db.exec(`CREATE TABLE IF NOT EXISTS project_type_definitions (
  type_id TEXT PRIMARY KEY,
  type_name TEXT NOT NULL UNIQUE,
  sort_order REAL NOT NULL DEFAULT 0,
  is_default INTEGER NOT NULL DEFAULT 0 CHECK (is_default IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT
);
CREATE INDEX IF NOT EXISTS idx_project_type_definitions_sort ON project_type_definitions(sort_order) WHERE deleted_at IS NULL;
`);
// Seed default project types if table is empty
if (!db.prepare('SELECT 1 FROM project_type_definitions WHERE deleted_at IS NULL LIMIT 1').get()) {
  const insertType = db.prepare(`INSERT INTO project_type_definitions (type_id, type_name, sort_order, is_default)
    VALUES (?, ?, ?, ?) ON CONFLICT(type_name) DO NOTHING`);
  db.transaction(() => {
    insertType.run(randomUUID(), 'New', 1, 1);
    insertType.run(randomUUID(), 'Change Major', 2, 0);
    insertType.run(randomUUID(), 'Change Minor', 3, 0);
    insertType.run(randomUUID(), 'Job', 4, 0);
  })();
}

const app = Fastify({ logger: true, bodyLimit: taskNoteTransportLimitBytes });
app.addContentTypeParser('*', { parseAs: 'buffer', bodyLimit: taskNoteTransportLimitBytes }, (request, body, done) => done(null, body));
const demoPmId = '20000000-0000-0000-0000-000000000001';
const demoBaId = '20000000-0000-0000-0000-000000000002';
const defaultProjectId = '30000000-0000-0000-0000-000000000001';
const secondProjectId = '30000000-0000-0000-0000-000000000002';
const defaultDemoLogin = process.env.DEMO_LOGIN_NAME || 'rrms.demo.pm';
const allowDemoIdentityOverride = process.env.ALLOW_DEMO_IDENTITY_OVERRIDE === 'true';
const assignmentRoles = new Set(['Owner', 'DEV', 'Reviewer', 'Contributor', 'Observer']);
const projectRoles = new Set(['PM', 'ProjectAdmin', 'DEVLead', 'TeamMember', 'Reviewer', 'Owner']);
const taskStatuses = new Set(['NotStarted', 'InProgress', 'OnHold', 'Blocked', 'Done', 'Cancelled']);
const ragStatuses = new Set(['Green', 'Amber', 'Red']);
function isValidProjectType(name) {
  if (!name) return false;
  return Boolean(db.prepare('SELECT 1 FROM project_type_definitions WHERE type_name = ? AND deleted_at IS NULL').get(name));
}
const projectSizes = new Set(['Small', 'Medium', 'Large']);
const templatePreviews = new Map();
const maxTemplateBytes = 5 * 1024 * 1024;

function isValidProjectRole(roleCode, projectId) {
  if (!roleCode) return false;
  if (projectRoles.has(roleCode)) return true;
  const match = db.prepare('SELECT 1 FROM project_roles WHERE project_id = ? AND (role_code = ? OR role_name = ?) AND deleted_at IS NULL').get(projectId, roleCode, roleCode);
  return Boolean(match);
}

function isValidAssignmentRole(role, projectId) {
  if (!role) return false;
  if (assignmentRoles.has(role)) return true;
  return isValidProjectRole(role, projectId);
}

function activeProjectMember(personId, scopedProjectId) {
  return db.prepare(`SELECT pm.* FROM project_members pm JOIN people p ON p.person_id = pm.person_id
    WHERE pm.project_id = ? AND pm.person_id = ? AND pm.deleted_at IS NULL AND p.deleted_at IS NULL
      AND p.person_status = 'Active' LIMIT 1`).get(scopedProjectId, personId);
}

function ensureActiveProjectMember(personId, scopedProjectId, defaultRole = 'TeamMember') {
  if (!personId || !scopedProjectId) return null;
  const member = activeProjectMember(personId, scopedProjectId);
  if (member) return member;
  const person = db.prepare("SELECT * FROM people WHERE person_id = ? AND deleted_at IS NULL AND person_status = 'Active'").get(personId);
  if (!person) return null;
  const existing = db.prepare('SELECT * FROM project_members WHERE project_id = ? AND person_id = ?').get(scopedProjectId, personId);
  if (existing) {
    db.prepare('UPDATE project_members SET deleted_at = NULL, updated_at = CURRENT_TIMESTAMP WHERE project_member_id = ?').run(existing.project_member_id);
  } else {
    const assignedRole = isValidProjectRole(defaultRole, scopedProjectId) ? defaultRole : 'TeamMember';
    db.prepare('INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm) VALUES (?, ?, ?, ?, 0)')
      .run(randomUUID(), scopedProjectId, personId, assignedRole);
  }
  return activeProjectMember(personId, scopedProjectId);
}

function projectTask(taskId, scopedProjectId) {
  return db.prepare('SELECT * FROM tasks WHERE task_id = ? AND project_id = ? AND deleted_at IS NULL').get(taskId, scopedProjectId);
}

function setTaskOwner(taskId, ownerPersonId) {
  const existing = db.prepare(`SELECT task_assignment_id FROM task_assignments
    WHERE task_id = ? AND person_id = ? AND assignment_role = 'Owner'`).get(taskId, ownerPersonId);
  const assignmentId = existing?.task_assignment_id || randomUUID();
  db.prepare(`UPDATE task_assignments SET is_primary = 0, deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
    WHERE task_id = ? AND assignment_role = 'Owner' AND task_assignment_id != ?`).run(taskId, assignmentId);
  if (existing) {
    db.prepare(`UPDATE task_assignments SET is_primary = 1, raci_role = 'Accountable', deleted_at = NULL, updated_at = CURRENT_TIMESTAMP
      WHERE task_assignment_id = ?`).run(assignmentId);
  } else {
    db.prepare(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
      VALUES (?, ?, ?, 'Owner', 'Accountable', 1)`).run(assignmentId, taskId, ownerPersonId);
  }
  db.prepare('UPDATE tasks SET owner_person_id = ?, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?').run(ownerPersonId, taskId);
  return assignmentId;
}

function projectTaskNote(noteId, scopedProjectId) {
  return db.prepare(`SELECT n.* FROM task_notes n JOIN tasks t ON t.task_id = n.task_id
    WHERE n.task_note_id = ? AND t.project_id = ? AND n.deleted_at IS NULL AND t.deleted_at IS NULL`).get(noteId, scopedProjectId);
}

function safeFileName(value) {
  let source = String(value || 'attachment');
  try { source = decodeURIComponent(source); } catch { /* use the supplied value */ }
  const name = path.basename(source).replace(/[^a-zA-Z0-9._() -]/g, '_').slice(0, 180);
  return name || 'attachment';
}

function projectPhase(phaseId, scopedProjectId) {
  return db.prepare('SELECT * FROM project_phases WHERE phase_id = ? AND project_id = ? AND deleted_at IS NULL').get(phaseId, scopedProjectId);
}

function projectWorkstream(workstreamId, scopedProjectId) {
  return db.prepare('SELECT * FROM project_workstreams WHERE workstream_id = ? AND project_id = ? AND deleted_at IS NULL').get(workstreamId, scopedProjectId);
}

function projectRole(roleId, scopedProjectId) {
  return db.prepare('SELECT * FROM project_roles WHERE role_id = ? AND project_id = ? AND deleted_at IS NULL').get(roleId, scopedProjectId);
}

const standardWorkstreams = [
  { code: 'GOV', name: 'Governance & PMO', desc: 'Project oversight, compliance & change control', sort: 1 },
  { code: 'BE', name: 'Backend & API', desc: 'Core logic, services, database & integrations', sort: 2 },
  { code: 'FE', name: 'Frontend & UI/UX', desc: 'User experience, UI layouts & client applications', sort: 3 },
  { code: 'INFRA', name: 'Infra & DevOps', desc: 'Cloud environments, CI/CD pipelines & security', sort: 4 },
  { code: 'QA', name: 'QA & Testing', desc: 'Quality assurance, test automation & UAT', sort: 5 },
  { code: 'DATA', name: 'Data & Migration', desc: 'Data migration, pipelines & validation', sort: 6 }
];

function seedStandardWorkstreams(projectId) {
  const insert = db.prepare(`INSERT INTO project_workstreams (workstream_id, project_id, workstream_code, workstream_name, description, sort_order)
    VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(project_id, workstream_code) DO NOTHING`);
  for (const item of standardWorkstreams) {
    insert.run(randomUUID(), projectId, item.code, item.name, item.desc, item.sort);
  }
}

const standardRoles = [
  { code: 'PM', name: 'Project Manager', desc: 'Project oversight, planning & coordination', sort: 1 },
  { code: 'ProjectAdmin', name: 'Project Admin', desc: 'Administrative and operational management', sort: 2 },
  { code: 'DEVLead', name: 'DEV Lead / Developer', desc: 'Software architecture & development', sort: 3 },
  { code: 'TeamMember', name: 'Team Member', desc: 'Core contributor & task delivery', sort: 4 },
  { code: 'Reviewer', name: 'Reviewer', desc: 'Review, validation & sign-off', sort: 5 }
];

// BA and QA are no longer project or assignment roles. Preserve each person's
// project membership by moving the retired role to the generic Team Member role.
db.transaction(() => {
  db.prepare("UPDATE project_members SET project_role = 'TeamMember', updated_at = CURRENT_TIMESTAMP WHERE project_role IN ('BA', 'BALead', 'QA', 'QALead') AND deleted_at IS NULL").run();
  db.prepare("UPDATE task_assignments SET assignment_role = 'Contributor', updated_at = CURRENT_TIMESTAMP WHERE assignment_role IN ('BA', 'QA') AND deleted_at IS NULL").run();
  db.prepare("UPDATE project_roles SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE role_code IN ('BA', 'BALead', 'QA', 'QALead') AND deleted_at IS NULL").run();
})();

function seedStandardRoles(projectId) {
  const insert = db.prepare(`INSERT INTO project_roles (role_id, project_id, role_code, role_name, description, sort_order)
    VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(project_id, role_code) DO NOTHING`);
  for (const item of standardRoles) {
    insert.run(randomUUID(), projectId, item.code, item.name, item.desc, item.sort);
  }
}

function resolveActor(loginName) {
  const account = db.prepare(`SELECT ua.user_account_id, ua.login_name, ua.auth_provider, p.person_id, p.display_name
    FROM user_accounts ua JOIN people p ON p.person_id = ua.person_id
    WHERE lower(ua.login_name) = lower(?) AND ua.account_status = 'Active' AND ua.deleted_at IS NULL
      AND p.person_status = 'Active' AND p.deleted_at IS NULL`).get(loginName);
  if (!account) return null;
  const roles = db.prepare(`SELECT DISTINCT r.role_code FROM user_roles ur JOIN roles r ON r.role_id = ur.role_id
    WHERE ur.user_account_id = ? AND (ur.active_from IS NULL OR ur.active_from <= date('now'))
      AND (ur.active_to IS NULL OR ur.active_to >= date('now')) ORDER BY r.role_code`).all(account.user_account_id).map((row) => row.role_code);
  const memberships = db.prepare(`SELECT project_id, project_role, is_main_pm FROM project_members
    WHERE person_id = ? AND deleted_at IS NULL AND (active_from IS NULL OR active_from <= date('now'))
      AND (active_to IS NULL OR active_to >= date('now')) ORDER BY project_id, project_role`).all(account.person_id);
  return { ...account, roles, memberships };
}

let persistTimer = null;
export async function persistToSupabase() {
  if (!pgPool || !db) return;
  try {
    const data = db.serialize();
    await pgPool.query(`
      INSERT INTO app_state_storage (key, data, updated_at)
      VALUES ($1, $2, CURRENT_TIMESTAMP)
      ON CONFLICT (key) DO UPDATE SET data = EXCLUDED.data, updated_at = CURRENT_TIMESTAMP
    `, ['lean_sqlite_db', data]);
  } catch (err) {
    console.error('[db] Error persisting snapshot to Supabase:', err.message);
  }
}

export function queuePersistToSupabase() {
  if (!pgPool) return;
  if (persistTimer) clearTimeout(persistTimer);
  persistTimer = setTimeout(() => {
    persistToSupabase().catch(() => {});
  }, 1000);
}

function audit(action, entityType, entityId, before, after, actorPersonId = demoPmId) {
  db.prepare(`INSERT INTO audit_logs (audit_log_id, actor_person_id, action, entity_type, entity_id, before_snapshot, after_snapshot)
    VALUES (?, ?, ?, ?, ?, ?, ?)`)
    .run(randomUUID(), actorPersonId, action, entityType, entityId, before ? JSON.stringify(before) : null, after ? JSON.stringify(after) : null);
  if (pgPool) {
    queuePersistToSupabase();
  }
}


function nextAvailableTaskCode(projectId, requestedCode) {
  const used = db.prepare('SELECT 1 FROM tasks WHERE project_id = ? AND task_code = ?').get(projectId, requestedCode);
  if (!used) return requestedCode;
  const match = String(requestedCode).match(/^(.*?)(\d+)$/);
  const prefix = match ? match[1] : `${requestedCode}-`;
  const width = match ? match[2].length : 3;
  let number = match ? Number(match[2]) + 1 : 1;
  let candidate = requestedCode;
  while (db.prepare('SELECT 1 FROM tasks WHERE project_id = ? AND task_code = ?').get(projectId, candidate)) {
    candidate = `${prefix}${String(number).padStart(width, '0')}`;
    number += 1;
  }
  return candidate;
}

function importDate(value) {
  if (value instanceof Date && !Number.isNaN(value.getTime())) return value.toISOString().slice(0, 10);
  const text = String(value || '').trim();
  return /^\d{4}-\d{2}-\d{2}$/.test(text) ? text : null;
}

function importStatus(value) {
  const key = String(value || '').replace(/[ _-]/g, '').toLowerCase();
  if (['done', 'complete', 'completed'].includes(key)) return 'Done';
  if (['inprogress', 'progress'].includes(key)) return 'InProgress';
  if (['onhold', 'hold', 'paused'].includes(key)) return 'OnHold';
  if (key === 'blocked') return 'Blocked';
  if (['cancelled', 'canceled'].includes(key)) return 'Cancelled';
  return 'NotStarted';
}

function importPriority(value) {
  const key = String(value || '').toLowerCase();
  return key === 'high' || key === 'critical' ? 'Red' : key === 'medium' ? 'Amber' : 'Green';
}

function importTemplate(buffer, filename, project) {
  if (!Buffer.isBuffer(buffer) || !buffer.length) throw new Error('Choose a template file first.');
  if (buffer.length > maxTemplateBytes) throw new Error('Template must not be larger than 5 MB.');
  const book = XLSX.read(buffer, { type: 'buffer', cellDates: true });
  const sheet = book.Sheets['Project plan'] || book.Sheets[book.SheetNames[0]];
  if (!sheet) throw new Error('No worksheet was found in the template.');
  const raw = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '', raw: true });
  const normalizedHeader = (value) => String(value || '').trim().toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();
  const headerAt = raw.findIndex((row) => row.some((cell) => normalizedHeader(cell) === 'level') && row.some((cell) => /task\s*(no|number)/i.test(normalizedHeader(cell))));
  if (headerAt < 0) throw new Error('Template needs a header row with Level and Task No. Use the provided template format.');
  const headers = raw[headerAt].map(normalizedHeader);
  const column = (...names) => names.map((name) => headers.indexOf(name)).find((index) => index >= 0) ?? -1;
  const get = (row, ...names) => { const index = column(...names); return index >= 0 ? row[index] : ''; };
  const splitPeople = (value) => String(value || '').split(';').map((item) => item.trim()).filter(Boolean);
  const memberRows = db.prepare(`SELECT p.person_id, p.employee_code, p.email, p.display_name
    FROM project_members pm JOIN people p ON p.person_id = pm.person_id
    WHERE pm.project_id = ? AND pm.deleted_at IS NULL AND p.deleted_at IS NULL
      AND (pm.active_from IS NULL OR pm.active_from <= date('now'))
      AND (pm.active_to IS NULL OR pm.active_to >= date('now'))`).all(project.project_id);
  const memberByReference = new Map();
  for (const member of memberRows) {
    for (const reference of [member.person_id, member.employee_code, member.email, member.display_name]) {
      if (reference) memberByReference.set(String(reference).trim().toLowerCase(), member.person_id);
    }
  }
  const resolveMember = (reference) => memberByReference.get(String(reference || '').trim().toLowerCase());
  const rows = raw.slice(headerAt + 1).filter((row) => String(get(row, 'level')).trim() && String(get(row, 'task no', 'task number')).trim()).map((row, index) => ({
    row: headerAt + index + 2,
    level: String(get(row, 'level')).trim(), taskNo: String(get(row, 'task no', 'task number')).trim(),
    parentNo: String(get(row, 'parent no', 'parent task no', 'parent task number')).trim(),
    title: String(get(row, 'title', 'task title', 'project & activity')).trim(),
    sourceCode: String(get(row, 'source wbs code', 'task code', 'work item code', 'wbs code')).trim(),
    startDate: importDate(get(row, 'start date')), dueDate: importDate(get(row, 'due date', 'target end date')),
    status: importStatus(get(row, 'status')), progress: Math.min(100, Math.max(0, Number(get(row, '% complete', 'progress', 'progress %')) || 0)),
    rag: importPriority(get(row, 'priority')), notes: String(get(row, 'notes', 'note')).trim(),
    ownerReferences: splitPeople(get(row, 'owner person id', 'task owner s', 'task owner', 'owner')),
    assigneeReferences: splitPeople(get(row, 'assignee person ids', 'assignee person id', 'assignees')),
    assignmentRole: String(get(row, 'role', 'assignment role')).trim() || 'Contributor',
    weight: Math.min(100, Math.max(0, Number(get(row, 'weight')) || 0)),
    evidenceRequired: ['true', 'yes', '1', 'required'].includes(String(get(row, 'evidence required')).trim().toLowerCase()),
    workstream: String(get(row, 'workstream')).trim() || null
  }));
  const errors = [];
  const allowed = new Set(['Phase', 'Main Task', 'Task', 'Subtask']);
  const keys = new Set(); const sourceCodes = new Set();
  for (const item of rows) {
    if (!allowed.has(item.level)) errors.push(`Row ${item.row}: Level must be Phase, Main Task, Task, or Subtask.`);
    if (!item.title) errors.push(`Row ${item.row}: Title is required.`);
    if (keys.has(item.taskNo)) errors.push(`Row ${item.row}: Task No '${item.taskNo}' is duplicated in the file.`); else keys.add(item.taskNo);
    if (item.level !== 'Phase' && !item.parentNo) errors.push(`Row ${item.row}: Parent No is required for ${item.level}.`);
    if (item.level !== 'Phase' && item.sourceCode) { if (sourceCodes.has(item.sourceCode)) errors.push(`Row ${item.row}: Task Code '${item.sourceCode}' is duplicated in the file.`); else sourceCodes.add(item.sourceCode); }
    if (item.level !== 'Phase') {
      if (item.ownerReferences.length > 1) errors.push(`Row ${item.row}: Supply one task Owner only.`);
      item.ownerPersonId = item.ownerReferences.length ? resolveMember(item.ownerReferences[0]) : project.main_pm_person_id;
      if (!item.ownerPersonId) errors.push(`Row ${item.row}: Owner '${item.ownerReferences[0]}' is not an active project member.`);
      item.assigneePersonIds = item.assigneeReferences.map((reference) => ({ reference, personId: resolveMember(reference) }));
      for (const assignee of item.assigneePersonIds) {
        if (!assignee.personId) errors.push(`Row ${item.row}: Assignee '${assignee.reference}' is not an active project member.`);
      }
      if (!isValidAssignmentRole(item.assignmentRole, project.project_id)) errors.push(`Row ${item.row}: Assignment role '${item.assignmentRole}' is invalid.`);
      if (item.assignmentRole === 'Owner' && item.assigneePersonIds.some((assignee) => assignee.personId && assignee.personId !== item.ownerPersonId)) {
        errors.push(`Row ${item.row}: Owner assignments must match the task Owner.`);
      }
    }
  }
  const phases = rows.filter((item) => item.level === 'Phase');
  const items = rows.filter((item) => item.level !== 'Phase');
  if (!phases.length) errors.push('At least one Phase is required.');
  if (!items.length) errors.push('At least one work item is required.');
  const existingCodes = new Set(db.prepare('SELECT task_code FROM tasks WHERE project_id = ? AND deleted_at IS NULL').all(project.project_id).map((row) => row.task_code));
  const conflicts = items.filter((item) => existingCodes.has(`${project.project_code}-${item.sourceCode || item.taskNo.replaceAll('.', '-')}`));
  return { filename: safeFileName(filename), rows, phases, items, errors, conflicts };
}

function archiveProjectStructure(projectId, actorId) {
  const tasks = db.prepare('SELECT * FROM tasks WHERE project_id = ? AND deleted_at IS NULL').all(projectId);
  if (tasks.length) {
    const marks = tasks.map(() => '?').join(','); const ids = tasks.map((task) => task.task_id);
    db.prepare(`UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
    db.prepare(`UPDATE weekly_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
    db.prepare(`UPDATE weekly_plans SET task_id = NULL, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
    db.prepare(`UPDATE task_note_files SET deleted_at = CURRENT_TIMESTAMP WHERE task_note_id IN (SELECT task_note_id FROM task_notes WHERE task_id IN (${marks})) AND deleted_at IS NULL`).run(...ids);
    db.prepare(`UPDATE task_notes SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
    db.prepare(`UPDATE tasks SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks})`).run(...ids);
    tasks.forEach((task) => audit('task.archive_for_template_import', 'Task', task.task_id, task, null, actorId));
  }
  db.prepare('UPDATE wbs_items SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND deleted_at IS NULL').run(projectId);
  db.prepare('UPDATE project_phases SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND deleted_at IS NULL').run(projectId);
  return tasks.length;
}

function archiveTasks(taskRows, actorId, action = 'task.archive') {
  if (!taskRows.length) return 0;
  const ids = taskRows.map((task) => task.task_id);
  const marks = ids.map(() => '?').join(',');
  db.prepare(`UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
  db.prepare(`UPDATE weekly_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
  db.prepare(`UPDATE weekly_plans SET task_id = NULL, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
  db.prepare(`UPDATE task_note_files SET deleted_at = CURRENT_TIMESTAMP WHERE task_note_id IN (SELECT task_note_id FROM task_notes WHERE task_id IN (${marks})) AND deleted_at IS NULL`).run(...ids);
  db.prepare(`UPDATE task_notes SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks}) AND deleted_at IS NULL`).run(...ids);
  db.prepare(`UPDATE tasks SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id IN (${marks})`).run(...ids);
  taskRows.forEach((task) => audit(action, 'Task', task.task_id, task, null, actorId));
  return ids.length;
}

function seedDemoWork() {
  if (db.prepare('SELECT COUNT(*) AS count FROM wbs_items WHERE project_id = ?').get(defaultProjectId).count) return;
  const create = db.transaction(() => {
    const wbs = [
      ['40000000-0000-0000-0000-000000000001', 'RRMS-01', 'Initiation & Planning', 1],
      ['40000000-0000-0000-0000-000000000002', 'RRMS-02', 'Requirements & Delivery', 2],
      ['40000000-0000-0000-0000-000000000003', 'RRMS-03', 'Pilot Readiness', 3]
    ];
    const insertWbs = db.prepare('INSERT INTO wbs_items (wbs_item_id, project_id, wbs_code, wbs_name, sort_order) VALUES (?, ?, ?, ?, ?)');
    for (const item of wbs) insertWbs.run(item[0], defaultProjectId, item[1], item[2], item[3]);
    const tasks = [
      ['50000000-0000-0000-0000-000000000001', wbs[0][0], null, 'RRMS-MT-001', 'MainTask', 'Establish project governance', demoPmId, 'InProgress', 'Green', 35, 60, 0, 'Governance & PMO'],
      ['50000000-0000-0000-0000-000000000002', wbs[0][0], '50000000-0000-0000-0000-000000000001', 'RRMS-T-001', 'Task', 'Confirm pilot scope and stakeholders', demoPmId, 'Done', 'Green', 15, 100, 1, 'Governance & PMO'],
      ['50000000-0000-0000-0000-000000000003', wbs[1][0], null, 'RRMS-MT-002', 'MainTask', 'Map high-level delivery work', demoBaId, 'InProgress', 'Amber', 40, 40, 0, 'Requirements & Architecture'],
      ['50000000-0000-0000-0000-000000000004', wbs[1][0], '50000000-0000-0000-0000-000000000003', 'RRMS-T-002', 'Task', 'Create WBS and task hierarchy', demoBaId, 'InProgress', 'Amber', 20, 40, 1, 'Requirements & Architecture'],
      ['50000000-0000-0000-0000-000000000005', wbs[2][0], null, 'RRMS-MT-003', 'MainTask', 'Prepare single-user UI walkthrough', demoPmId, 'NotStarted', 'Green', 25, 0, 0, 'Delivery & QA']
    ];
    const insertTask = db.prepare(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, owner_person_id, planned_start_date, planned_due_date, status, rag_status, weight, progress, evidence_required, workstream)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, '2026-08-27', '2026-09-30', ?, ?, ?, ?, ?, ?)`);
    const insertAssignment = db.prepare('INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary) VALUES (?, ?, ?, ?, ?, ?)');
    for (const task of tasks) {
      insertTask.run(task[0], defaultProjectId, ...task.slice(1));
      insertAssignment.run(randomUUID(), task[0], task[6], 'Owner', 'Accountable', 1);
    }
    audit('demo.seed', 'Project', defaultProjectId, null, { message: 'Created sample WBS and work items for the single-user walkthrough.' });
  });
  create();
}

seedDemoWork();

function seedDemoPortfolioProject() {
  if (db.prepare('SELECT 1 FROM projects WHERE project_id = ?').get(secondProjectId)) return;
  db.transaction(() => {
    db.prepare(`INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
      VALUES (?, 'DTP', 'Digital Transformation Pilot', 'Lean Project Control Pilot', 'Change Major', 'Large', ?, 'Active', 'Green', '2026-08-01', '2026-11-30')`).run(secondProjectId, demoPmId);
    db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
      VALUES ('31000000-0000-0000-0000-000000000003', ?, ?, 'PM', 1)`).run(secondProjectId, demoPmId);

    const wbs = [
      ['40000000-0000-0000-0000-000000000101', 'DTP-01', 'Discovery', 1],
      ['40000000-0000-0000-0000-000000000102', 'DTP-02', 'Pilot Delivery', 2]
    ];
    const insertWbs = db.prepare('INSERT INTO wbs_items (wbs_item_id, project_id, wbs_code, wbs_name, sort_order) VALUES (?, ?, ?, ?, ?)');
    for (const item of wbs) insertWbs.run(item[0], secondProjectId, item[1], item[2], item[3]);

    const tasks = [
      ['50000000-0000-0000-0000-000000000101', wbs[0][0], null, 'DTP-MT-001', 'MainTask', 'Assess current operating model', demoPmId, 'Done', 'Green', 100, 'Strategy & Discovery'],
      ['50000000-0000-0000-0000-000000000102', wbs[1][0], null, 'DTP-MT-002', 'MainTask', 'Deliver transformation pilot', demoPmId, 'InProgress', 'Green', 45, 'Core Delivery'],
      ['50000000-0000-0000-0000-000000000103', wbs[1][0], '50000000-0000-0000-0000-000000000102', 'DTP-T-001', 'Task', 'Configure pilot workflow', demoPmId, 'InProgress', 'Amber', 35, 'Core Delivery']
    ];
    const insertTask = db.prepare(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, owner_person_id, planned_start_date, planned_due_date, status, rag_status, weight, progress, workstream)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, '2026-08-01', '2026-11-30', ?, ?, 33.33, ?, ?)`);
    const insertAssignment = db.prepare(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
      VALUES (?, ?, ?, 'Owner', 'Accountable', 1)`);
    for (const task of tasks) {
      insertTask.run(task[0], secondProjectId, ...task.slice(1));
      insertAssignment.run(randomUUID(), task[0], demoPmId);
    }
    audit('demo.seed', 'Project', secondProjectId, null, { message: 'Created a second sample project for the portfolio walkthrough.' });
  })();
}

seedDemoPortfolioProject();
seedStandardWorkstreams(defaultProjectId);
seedStandardWorkstreams(secondProjectId);
seedStandardRoles(defaultProjectId);
seedStandardRoles(secondProjectId);

// Older walkthrough data could contain an Owner assignment that disagreed with
// tasks.owner_person_id. Prefer the explicitly primary Owner assignment and
// repair the duplicated representation once when the server starts.
function reconcileStoredTaskOwners() {
  const taskRows = db.prepare(`SELECT t.*, ta.person_id AS assigned_owner_person_id
    FROM tasks t
    JOIN task_assignments ta ON ta.task_id = t.task_id AND ta.assignment_role = 'Owner' AND ta.deleted_at IS NULL
    WHERE t.deleted_at IS NULL
    ORDER BY t.task_id, ta.is_primary DESC, ta.updated_at DESC, ta.created_at DESC`).all();
  const reconciled = new Set();
  db.transaction(() => {
    for (const task of taskRows) {
      if (reconciled.has(task.task_id)) continue;
      reconciled.add(task.task_id);
      setTaskOwner(task.task_id, task.assigned_owner_person_id);
      if (task.owner_person_id !== task.assigned_owner_person_id) {
        audit('task.owner_reconcile', 'Task', task.task_id, task, { ...task, owner_person_id: task.assigned_owner_person_id }, null);
      }
    }
  })();
}

reconcileStoredTaskOwners();



function rollupTaskProgress(parentTaskId) {
  if (!parentTaskId) return;
  const parent = db.prepare('SELECT * FROM tasks WHERE task_id = ? AND deleted_at IS NULL').get(parentTaskId);
  if (!parent) return;

  const children = db.prepare('SELECT * FROM tasks WHERE parent_task_id = ? AND deleted_at IS NULL').all(parentTaskId);
  if (!children.length) return;

  const totalWeight = children.reduce((sum, c) => sum + (Number(c.weight) || 0), 0);
  let computedProgress = 0;
  if (totalWeight > 0) {
    computedProgress = Math.round(children.reduce((sum, c) => sum + (Number(c.progress) || 0) * (Number(c.weight) || 0), 0) / totalWeight);
  } else {
    computedProgress = Math.round(children.reduce((sum, c) => sum + (Number(c.progress) || 0), 0) / children.length);
  }
  computedProgress = Math.max(0, Math.min(100, computedProgress));

  let computedStatus = parent.status;
  if (computedProgress === 100 || children.every((c) => c.status === 'Done')) {
    computedStatus = 'Done';
    computedProgress = 100;
  } else if (computedProgress === 0 && children.every((c) => c.status === 'NotStarted')) {
    computedStatus = 'NotStarted';
  } else if (children.some((c) => c.status === 'Blocked')) {
    computedStatus = 'Blocked';
  } else if (children.every((c) => c.status === 'OnHold' || c.status === 'NotStarted')) {
    computedStatus = 'OnHold';
  } else {
    computedStatus = 'InProgress';
  }

  let computedRag = 'Green';
  if (children.some((c) => c.rag_status === 'Red')) {
    computedRag = 'Red';
  } else if (children.some((c) => c.rag_status === 'Amber')) {
    computedRag = 'Amber';
  }

  db.prepare(`UPDATE tasks SET progress = ?, status = ?, rag_status = ?, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?`)
    .run(computedProgress, computedStatus, computedRag, parentTaskId);

  if (parent.parent_task_id) {
    rollupTaskProgress(parent.parent_task_id);
  }
}

function syncAllParentTaskProgress() {
  const parents = db.prepare(`SELECT DISTINCT parent_task_id FROM tasks WHERE parent_task_id IS NOT NULL AND deleted_at IS NULL`).all();
  for (const { parent_task_id } of parents) {
    rollupTaskProgress(parent_task_id);
  }
}

app.decorateRequest('actor', null);
app.decorateRequest('projectId', null);
app.addHook('preHandler', async (request, reply) => {
  if (!request.url.startsWith('/api/')) return;
  // API secret key guard: when API_SECRET_KEY is set, every /api/* request must
  // supply a matching Authorization: Bearer <key> header. Skip check when not set
  // so local dev and smoke tests work without any extra configuration.
  const apiSecretKey = process.env.API_SECRET_KEY;
  if (apiSecretKey) {
    const authHeader = request.headers['authorization'] || '';
    if (authHeader !== `Bearer ${apiSecretKey}`) {
      return reply.code(401).send({ message: 'Unauthorized.' });
    }
  }
  const requestedLogin = request.headers['x-demo-login'];
  const loginName = allowDemoIdentityOverride && typeof requestedLogin === 'string' ? requestedLogin : defaultDemoLogin;
  const actor = resolveActor(loginName);
  if (!actor) return reply.code(401).send({ message: 'No active local demo account matches the configured login.' });
  request.actor = actor;
  const requestedProjectId = typeof request.headers['x-project-id'] === 'string' ? request.headers['x-project-id'] : defaultProjectId;
  const hasProjectAccess = db.prepare(`SELECT 1 FROM project_members WHERE project_id = ? AND person_id = ? AND deleted_at IS NULL
    AND (active_from IS NULL OR active_from <= date('now')) AND (active_to IS NULL OR active_to >= date('now'))`).get(requestedProjectId, actor.person_id);
  if (!hasProjectAccess) return reply.code(403).send({ message: 'You do not have access to the selected project.' });
  request.projectId = requestedProjectId;
});

function taskRows(scopedProjectId) {
  return db.prepare(`SELECT t.*, w.wbs_code, w.wbs_name, w.phase_id,
    ph.phase_code, ph.phase_name,
    p.display_name AS owner_name,
    GROUP_CONCAT(a.display_name, ', ') AS assignees,
    (SELECT COUNT(*) FROM task_notes tn WHERE tn.task_id = t.task_id AND tn.deleted_at IS NULL) AS note_count
    FROM tasks t JOIN wbs_items w ON w.wbs_item_id = t.wbs_item_id
    LEFT JOIN project_phases ph ON ph.phase_id = w.phase_id AND ph.deleted_at IS NULL
    JOIN people p ON p.person_id = t.owner_person_id
    LEFT JOIN task_assignments ta ON ta.task_id = t.task_id AND ta.deleted_at IS NULL
    LEFT JOIN people a ON a.person_id = ta.person_id
    WHERE t.project_id = ? AND t.deleted_at IS NULL
    GROUP BY t.task_id ORDER BY COALESCE(ph.sort_order, 9999), w.sort_order, t.task_code`).all(scopedProjectId);
}

app.post('/api/imports/preview', async (request, reply) => {
  try {
    const project = db.prepare('SELECT * FROM projects WHERE project_id = ? AND deleted_at IS NULL').get(request.projectId);
    const preview = importTemplate(request.body, request.headers['x-import-filename'], project);
    const token = randomUUID();
    templatePreviews.set(token, { ...preview, projectId: request.projectId, createdAt: Date.now() });
    return {
      token, fileName: preview.filename,
      summary: { phases: preview.phases.length, workItems: preview.items.length, newItems: preview.items.length - preview.conflicts.length, matchingItems: preview.conflicts.length },
      errors: preview.errors, conflicts: preview.conflicts.slice(0, 12).map((item) => ({ row: item.row, taskNo: item.taskNo, title: item.title, taskCode: item.sourceCode || item.taskNo })),
      canImport: preview.errors.length === 0
    };
  } catch (error) { return reply.code(422).send({ message: error.message }); }
});

app.post('/api/imports/commit', async (request, reply) => {
  const { token, mode } = request.body || {};
  const preview = templatePreviews.get(token);
  if (!preview || preview.projectId !== request.projectId || Date.now() - preview.createdAt > 30 * 60 * 1000) return reply.code(422).send({ message: 'The preview has expired. Upload the template again.' });
  if (preview.errors.length) return reply.code(422).send({ message: 'Fix the template validation errors before importing.' });
  if (!['replace', 'update'].includes(mode)) return reply.code(422).send({ message: 'Choose Replace structure or Update matching fields.' });
  const project = db.prepare('SELECT * FROM projects WHERE project_id = ?').get(request.projectId);
  const result = db.transaction(() => {
    const archived = mode === 'replace' ? archiveProjectStructure(project.project_id, request.actor.person_id) : 0;
    const phaseByNo = new Map();
    const upsertPhase = db.prepare(`INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
      VALUES (?, ?, ?, ?, ?, ?, ?) ON CONFLICT(project_id, phase_code) DO UPDATE SET phase_name = excluded.phase_name, sort_order = excluded.sort_order, planned_start_date = excluded.planned_start_date, planned_due_date = excluded.planned_due_date, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP`);
    const upsertWbs = db.prepare(`INSERT INTO wbs_items (wbs_item_id, project_id, wbs_code, wbs_name, sort_order, phase_id)
      VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT(project_id, wbs_code) DO UPDATE SET wbs_name = excluded.wbs_name, sort_order = excluded.sort_order, phase_id = excluded.phase_id, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP`);
    preview.phases.forEach((phase, index) => {
      const code = `${project.project_code}-PH-${String(index + 1).padStart(2, '0')}`;
      upsertPhase.run(randomUUID(), project.project_id, code, phase.title, index + 1, phase.startDate, phase.dueDate);
      const phaseRow = db.prepare('SELECT * FROM project_phases WHERE project_id = ? AND phase_code = ?').get(project.project_id, code);
      upsertWbs.run(randomUUID(), project.project_id, code, phase.title, index + 1, phaseRow.phase_id);
      const wbsRow = db.prepare('SELECT * FROM wbs_items WHERE project_id = ? AND wbs_code = ?').get(project.project_id, code);
      phaseByNo.set(phase.taskNo, wbsRow);
    });
    const taskByNo = new Map(); let currentPhaseNo = null; let created = 0; let updated = 0;
    const upsertTask = db.prepare(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, status, rag_status, weight, progress, evidence_required, workstream)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(project_id, task_code) DO UPDATE SET wbs_item_id = excluded.wbs_item_id, parent_task_id = excluded.parent_task_id, task_type = excluded.task_type, task_name = excluded.task_name, description = excluded.description, owner_person_id = excluded.owner_person_id, planned_start_date = excluded.planned_start_date, planned_due_date = excluded.planned_due_date, status = excluded.status, rag_status = excluded.rag_status, weight = excluded.weight, progress = excluded.progress, evidence_required = excluded.evidence_required, workstream = excluded.workstream, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP`);
    const upsertAssignment = db.prepare(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
      VALUES (?, ?, ?, ?, ?, 0) ON CONFLICT(task_id, person_id, assignment_role) DO UPDATE SET deleted_at = NULL, updated_at = CURRENT_TIMESTAMP`);
    for (const item of preview.items) {
      const phaseNo = item.level === 'Main Task' ? item.parentNo : currentPhaseNo;
      if (item.level === 'Main Task') currentPhaseNo = item.parentNo;
      const wbs = phaseByNo.get(phaseNo); if (!wbs) throw new Error(`Row ${item.row}: Phase could not be resolved.`);
      const parentTaskId = item.level === 'Main Task' ? null : taskByNo.get(item.parentNo);
      if (item.level !== 'Main Task' && !parentTaskId) throw new Error(`Row ${item.row}: Parent task '${item.parentNo}' must appear before its child.`);
      const code = `${project.project_code}-${item.sourceCode || item.taskNo.replaceAll('.', '-')}`;
      const wasExisting = db.prepare('SELECT task_id FROM tasks WHERE project_id = ? AND task_code = ?').get(project.project_id, code);
      const type = item.level === 'Main Task' ? 'MainTask' : item.level === 'Task' ? 'Task' : 'Subtask';
      upsertTask.run(randomUUID(), project.project_id, wbs.wbs_item_id, parentTaskId || null, code, type, item.title, item.notes || null, item.ownerPersonId, item.startDate, item.dueDate, item.status, item.rag, item.weight, item.progress, item.evidenceRequired ? 1 : 0, item.workstream);
      const saved = db.prepare('SELECT * FROM tasks WHERE project_id = ? AND task_code = ?').get(project.project_id, code);
      taskByNo.set(item.taskNo, saved.task_id);
      if (wasExisting) updated += 1; else created += 1;
      setTaskOwner(saved.task_id, item.ownerPersonId);
      for (const assignee of item.assigneePersonIds) {
        if (!assignee.personId || (assignee.personId === item.ownerPersonId && item.assignmentRole === 'Owner')) continue;
        upsertAssignment.run(randomUUID(), saved.task_id, assignee.personId, item.assignmentRole, item.assignmentRole === 'Owner' ? 'Accountable' : null);
      }
    }
    audit(`template_import.${mode}`, 'Project', project.project_id, null, { fileName: preview.filename, created, updated, archived }, request.actor.person_id);
    return { created, updated, archived };
  })();
  templatePreviews.delete(token);
  return { message: mode === 'replace' ? 'Template imported and prior structure was archived.' : 'Matching work items were updated and new items were added.', ...result };
});

app.get('/api/session', async (request) => ({
  loginName: request.actor.login_name,
  authProvider: request.actor.auth_provider,
  personId: request.actor.person_id,
  displayName: request.actor.display_name,
  roles: request.actor.roles,
  memberships: request.actor.memberships,
  demoMode: true
}));

app.get('/api/portfolio', async (request) => {
  const projects = db.prepare(`SELECT p.*, owner.display_name AS main_pm_name
    FROM projects p JOIN people owner ON owner.person_id = p.main_pm_person_id
    JOIN project_members pm ON pm.project_id = p.project_id
    WHERE p.deleted_at IS NULL AND pm.person_id = ? AND pm.deleted_at IS NULL
      AND lower(COALESCE(p.project_status, '')) NOT IN ('cancel', 'cancelled')
      AND (pm.active_from IS NULL OR pm.active_from <= date('now')) AND (pm.active_to IS NULL OR pm.active_to >= date('now'))
    ORDER BY p.project_code`).all(request.actor.person_id);
  const taskQuery = db.prepare(`SELECT t.task_id, t.task_code, t.task_name, t.task_type, t.status, t.rag_status, t.progress,
    t.planned_due_date, w.wbs_code, owner.display_name AS owner_name
    FROM tasks t JOIN wbs_items w ON w.wbs_item_id = t.wbs_item_id JOIN people owner ON owner.person_id = t.owner_person_id
    WHERE t.project_id = ? AND t.deleted_at IS NULL ORDER BY w.sort_order, t.task_code`);
  const raidQuery = db.prepare(`SELECT COUNT(*) AS open, SUM(CASE WHEN severity_score >= 12 THEN 1 ELSE 0 END) AS high
    FROM raid_items WHERE project_id = ? AND deleted_at IS NULL AND status <> 'Closed'`);
  return projects.map((project) => {
    const tasks = taskQuery.all(project.project_id);
    const raid = raidQuery.get(project.project_id);
    return {
      ...project,
      taskCount: tasks.length,
      completed: tasks.filter((task) => task.status === 'Done').length,
      progress: tasks.length ? Math.round(tasks.reduce((sum, task) => sum + task.progress, 0) / tasks.length) : 0,
      calculatedRag: tasks.some((task) => task.rag_status === 'Red') ? 'Red' : tasks.some((task) => task.rag_status === 'Amber') ? 'Amber' : 'Green',
      openRaid: raid.open || 0,
      highRaid: raid.high || 0,
      tasks
    };
  });
});

app.get('/api/project', async (request) => db.prepare(`SELECT p.*, people.display_name AS main_pm_name FROM projects p
  JOIN people ON people.person_id = p.main_pm_person_id WHERE p.project_id = ?`).get(request.projectId));

// ── Project Type Definitions ─────────────────────────────────────────────────
app.get('/api/project-types', async () =>
  db.prepare('SELECT * FROM project_type_definitions WHERE deleted_at IS NULL ORDER BY sort_order, type_name').all()
);

app.post('/api/project-types', async (request, reply) => {
  const body = request.body || {};
  const typeName = String(body.typeName || '').trim();
  if (!typeName) return reply.code(422).send({ message: 'Type name is required.' });
  if (typeName.length > 100) return reply.code(422).send({ message: 'Type name must be 100 characters or less.' });
  const id = randomUUID();
  try {
    const nextSort = db.prepare('SELECT COALESCE(MAX(sort_order), 0) + 1 AS value FROM project_type_definitions WHERE deleted_at IS NULL').get().value;
    db.prepare(`INSERT INTO project_type_definitions (type_id, type_name, sort_order, is_default) VALUES (?, ?, ?, 0)`)
      .run(id, typeName, Number(body.sortOrder) || nextSort);
    audit('project_type.create', 'ProjectTypeDefinition', id, null, { typeName }, request.actor.person_id);
  } catch (error) {
    return reply.code(409).send({ message: 'A project type with this name already exists.' });
  }
  return reply.code(201).send({ typeId: id });
});

app.patch('/api/project-types/:typeId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM project_type_definitions WHERE type_id = ? AND deleted_at IS NULL').get(request.params.typeId);
  if (!before) return reply.code(404).send({ message: 'Project type not found.' });
  const body = request.body || {};
  const typeName = body.typeName !== undefined ? String(body.typeName).trim() : before.type_name;
  if (!typeName) return reply.code(422).send({ message: 'Type name is required.' });
  if (typeName.length > 100) return reply.code(422).send({ message: 'Type name must be 100 characters or less.' });
  const sortOrder = body.sortOrder !== undefined ? Number(body.sortOrder) : before.sort_order;
  try {
    db.prepare('UPDATE project_type_definitions SET type_name = ?, sort_order = ?, updated_at = CURRENT_TIMESTAMP WHERE type_id = ?')
      .run(typeName, sortOrder, before.type_id);
    audit('project_type.update', 'ProjectTypeDefinition', before.type_id, before, { typeName, sortOrder }, request.actor.person_id);
  } catch (error) {
    return reply.code(409).send({ message: 'A project type with this name already exists.' });
  }
  return db.prepare('SELECT * FROM project_type_definitions WHERE type_id = ?').get(before.type_id);
});

app.delete('/api/project-types/:typeId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM project_type_definitions WHERE type_id = ? AND deleted_at IS NULL').get(request.params.typeId);
  if (!before) return reply.code(404).send({ message: 'Project type not found.' });
  if (before.is_default) return reply.code(422).send({ message: 'Default project types cannot be deleted.' });
  const inUse = db.prepare("SELECT COUNT(*) AS count FROM projects WHERE project_type = ? AND deleted_at IS NULL").get(before.type_name);
  if (inUse.count > 0) return reply.code(409).send({ message: `Cannot delete: ${inUse.count} project(s) are currently using this type.` });
  db.prepare('UPDATE project_type_definitions SET deleted_at = CURRENT_TIMESTAMP WHERE type_id = ?').run(before.type_id);
  audit('project_type.delete', 'ProjectTypeDefinition', before.type_id, before, null, request.actor.person_id);
  return reply.code(204).send();
});
// ─────────────────────────────────────────────────────────────────────────────

app.get('/api/projects', async (request) => db.prepare(`SELECT p.*, owner.display_name AS main_pm_name
  FROM projects p JOIN people owner ON owner.person_id = p.main_pm_person_id
  JOIN project_members pm ON pm.project_id = p.project_id
  WHERE p.deleted_at IS NULL AND pm.person_id = ? AND pm.deleted_at IS NULL
    AND (pm.active_from IS NULL OR pm.active_from <= date('now')) AND (pm.active_to IS NULL OR pm.active_to >= date('now'))
  ORDER BY CASE WHEN lower(COALESCE(p.project_status, '')) IN ('cancel', 'cancelled') THEN 1 ELSE 0 END, p.project_code`).all(request.actor.person_id));


app.post('/api/projects', async (request, reply) => {
  const body = request.body || {};
  if (!body.projectCode || !body.projectName) return reply.code(422).send({ message: 'Project code and project name are required.' });
  const projectType = body.projectType || 'New';
  const projectSize = body.projectSize || 'Medium';
  if (body.projectType && !isValidProjectType(body.projectType)) return reply.code(422).send({ message: 'Project type is invalid.' });
  if (body.projectSize && !projectSizes.has(body.projectSize)) return reply.code(422).send({ message: 'Project size is invalid.' });
  const id = randomUUID();
  const mainPm = body.mainPmPersonId || request.actor.person_id;
  const selectedTeamMemberIds = [...new Set((Array.isArray(body.teamMemberIds) ? body.teamMemberIds : [body.teamMemberIds])
    .filter((personId) => typeof personId === 'string' && personId.trim())
    .map((personId) => personId.trim()))];
  const mainPmPerson = db.prepare("SELECT 1 FROM people WHERE person_id = ? AND person_status = 'Active' AND deleted_at IS NULL").get(mainPm);
  if (!mainPmPerson) return reply.code(422).send({ message: 'Main PM must be an active person.' });
  if (selectedTeamMemberIds.length) {
    const marks = selectedTeamMemberIds.map(() => '?').join(', ');
    const validCount = db.prepare(`SELECT COUNT(*) AS count FROM people
      WHERE person_id IN (${marks}) AND person_status = 'Active' AND deleted_at IS NULL`).get(...selectedTeamMemberIds).count;
    if (validCount !== selectedTeamMemberIds.length) return reply.code(422).send({ message: 'Every selected team member must be active.' });
  }
  try {
    db.transaction(() => {
      db.prepare(`INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Green', ?, ?)`)
        .run(id, body.projectCode, body.projectName, body.portfolioName || null, projectType, projectSize, mainPm, body.projectStatus || 'Active', body.startDate || null, body.targetEndDate || null);
      db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
        VALUES (?, ?, ?, 'PM', 1)`).run(randomUUID(), id, mainPm);
      if (request.actor.person_id !== mainPm) {
        db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
          VALUES (?, ?, ?, 'PM', 0)`).run(randomUUID(), id, request.actor.person_id);
      }
      const addTeamMember = db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
        VALUES (?, ?, ?, 'TeamMember', 0)`);
      for (const personId of selectedTeamMemberIds) {
        // Main PM and the project creator already have their own membership.
        if (personId !== mainPm && personId !== request.actor.person_id) {
          addTeamMember.run(randomUUID(), id, personId);
        }
      }
      seedStandardWorkstreams(id);
      seedStandardRoles(id);
      audit('project.create', 'Project', id, null, { ...body, projectId: id, mainPmPersonId: mainPm }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Project code already exists or the dates are invalid.' }); }
  return reply.code(201).send({ projectId: id });
});

app.patch('/api/projects/:projectId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM projects WHERE project_id = ? AND deleted_at IS NULL').get(request.params.projectId);
  if (!before) return reply.code(404).send({ message: 'Project not found.' });
  const body = request.body || {};
  if (body.projectType && !isValidProjectType(body.projectType)) return reply.code(422).send({ message: 'Project type is invalid.' });
  if (body.projectSize && !projectSizes.has(body.projectSize)) return reply.code(422).send({ message: 'Project size is invalid.' });
  const fields = {
    projectCode: 'project_code',
    projectName: 'project_name',
    portfolioName: 'portfolio_name',
    projectType: 'project_type',
    projectSize: 'project_size',
    startDate: 'start_date',
    targetEndDate: 'target_end_date',
    projectStatus: 'project_status',
    mainPmPersonId: 'main_pm_person_id'
  };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input] || null])) };
  if (after.start_date && after.target_end_date && after.target_end_date < after.start_date) {
    return reply.code(422).send({ message: 'Target end date cannot be before start date.' });
  }
  if (body.mainPmPersonId) {
    const person = db.prepare("SELECT * FROM people WHERE person_id = ? AND person_status = 'Active' AND deleted_at IS NULL").get(body.mainPmPersonId);
    if (!person) return reply.code(422).send({ message: 'Main PM must be an active person.' });
  }
  try {
    db.transaction(() => {
      db.prepare(`UPDATE projects SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE project_id = ?`)
        .run(...changes.map(([input]) => body[input] || null), before.project_id);
      if (body.mainPmPersonId && body.mainPmPersonId !== before.main_pm_person_id) {
        db.prepare('UPDATE project_members SET is_main_pm = 0, updated_at = CURRENT_TIMESTAMP WHERE project_id = ?').run(before.project_id);
        const existingMember = db.prepare('SELECT * FROM project_members WHERE project_id = ? AND person_id = ?').get(before.project_id, body.mainPmPersonId);
        if (existingMember) {
          db.prepare('UPDATE project_members SET is_main_pm = 1, project_role = \'PM\', deleted_at = NULL, updated_at = CURRENT_TIMESTAMP WHERE project_member_id = ?')
            .run(existingMember.project_member_id);
        } else {
          db.prepare('INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm) VALUES (?, ?, ?, \'PM\', 1)').run(randomUUID(), before.project_id, body.mainPmPersonId);
        }
      }
      audit('project.update', 'Project', before.project_id, before, after, request.actor.person_id);
    })();
  } catch (error) {
    return reply.code(409).send({ message: error.message.includes('UNIQUE') ? 'Project code already exists.' : error.message });
  }
  return db.prepare('SELECT * FROM projects WHERE project_id = ?').get(before.project_id);
});

app.get('/api/dashboard', async (request) => {
  const tasks = taskRows(request.projectId);
  const raid = db.prepare(`SELECT COUNT(*) AS open, SUM(CASE WHEN severity_score >= 12 THEN 1 ELSE 0 END) AS high FROM raid_items
    WHERE project_id = ? AND deleted_at IS NULL AND status <> 'Closed'`).get(request.projectId);
  const updates = db.prepare(`SELECT COUNT(*) AS count FROM weekly_updates wu JOIN tasks t ON t.task_id = wu.task_id
    WHERE t.project_id = ? AND wu.deleted_at IS NULL`).get(request.projectId);
  return {
    taskCount: tasks.length,
    completed: tasks.filter((task) => task.status === 'Done').length,
    progress: tasks.length ? Math.round(tasks.reduce((sum, task) => sum + task.progress, 0) / tasks.length) : 0,
    rag: tasks.some((task) => task.rag_status === 'Red') ? 'Red' : tasks.some((task) => task.rag_status === 'Amber') ? 'Amber' : 'Green',
    openRaid: raid.open || 0, highRaid: raid.high || 0, weeklyUpdates: updates.count, recentTasks: tasks.slice(0, 5)
  };
});

app.get('/api/tasks', async (request) => taskRows(request.projectId));

app.get('/api/phases', async (request) => db.prepare(`SELECT p.*, COUNT(w.wbs_item_id) AS activity_count
  FROM project_phases p LEFT JOIN wbs_items w ON w.phase_id = p.phase_id AND w.deleted_at IS NULL
  WHERE p.project_id = ? AND p.deleted_at IS NULL GROUP BY p.phase_id ORDER BY p.sort_order, p.phase_code`).all(request.projectId));

app.post('/api/phases', async (request, reply) => {
  const body = request.body || {};
  if (!body.phaseCode || !body.phaseName) return reply.code(422).send({ message: 'Phase code and phase name are required.' });
  const id = randomUUID();
  try {
    db.transaction(() => {
      const nextSortOrder = db.prepare('SELECT COALESCE(MAX(sort_order), 0) + 1 AS value FROM project_phases WHERE project_id = ?').get(request.projectId).value;
      db.prepare(`INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
        VALUES (?, ?, ?, ?, ?, ?, ?)`)
        .run(id, request.projectId, body.phaseCode, body.phaseName, Number(body.sortOrder) || nextSortOrder, body.plannedStartDate || null, body.plannedDueDate || null);
      audit('phase.create', 'ProjectPhase', id, null, { ...body, phaseId: id }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Phase code already exists or the planned dates are invalid.' }); }
  return reply.code(201).send({ phaseId: id });
});

app.patch('/api/phases/:phaseId', async (request, reply) => {
  const before = projectPhase(request.params.phaseId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Phase not found.' });
  const body = request.body || {};
  const fields = { phaseCode: 'phase_code', phaseName: 'phase_name', sortOrder: 'sort_order', plannedStartDate: 'planned_start_date', plannedDueDate: 'planned_due_date' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input] || null])) };
  if (after.planned_start_date && after.planned_due_date && after.planned_due_date < after.planned_start_date) return reply.code(422).send({ message: 'Phase end date cannot be before its start date.' });
  try {
    db.transaction(() => {
      db.prepare(`UPDATE project_phases SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE phase_id = ?`)
        .run(...changes.map(([input]) => body[input] || null), before.phase_id);
      audit('phase.update', 'ProjectPhase', before.phase_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Phase code already exists.' }); }
  return projectPhase(before.phase_id, request.projectId);
});

app.delete('/api/phases/:phaseId', async (request, reply) => {
  const before = projectPhase(request.params.phaseId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Phase not found.' });
  const activities = db.prepare('SELECT * FROM wbs_items WHERE phase_id = ? AND project_id = ? AND deleted_at IS NULL').all(before.phase_id, request.projectId);
  const taskRows = activities.length
    ? db.prepare(`SELECT * FROM tasks WHERE wbs_item_id IN (${activities.map(() => '?').join(',')}) AND deleted_at IS NULL`).all(...activities.map((item) => item.wbs_item_id))
    : [];
  db.transaction(() => {
    archiveTasks(taskRows, request.actor.person_id, 'task.archive_for_phase_delete');
    if (activities.length) {
      db.prepare(`UPDATE wbs_items SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE wbs_item_id IN (${activities.map(() => '?').join(',')})`).run(...activities.map((item) => item.wbs_item_id));
      activities.forEach((activity) => audit('activity.archive_for_phase_delete', 'ProjectActivity', activity.wbs_item_id, activity, null, request.actor.person_id));
    }
    db.prepare('UPDATE project_phases SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE phase_id = ?').run(before.phase_id);
    audit('phase.delete', 'ProjectPhase', before.phase_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/workstreams', async (request) => db.prepare(`SELECT pw.*, COUNT(t.task_id) AS task_count
  FROM project_workstreams pw
  LEFT JOIN tasks t ON t.workstream = pw.workstream_name AND t.project_id = pw.project_id AND t.deleted_at IS NULL
  WHERE pw.project_id = ? AND pw.deleted_at IS NULL
  GROUP BY pw.workstream_id ORDER BY pw.sort_order, pw.workstream_code`).all(request.projectId));

app.post('/api/workstreams/standard', async (request, reply) => {
  db.transaction(() => {
    seedStandardWorkstreams(request.projectId);
    audit('workstream.standard_seed', 'ProjectWorkstream', request.projectId, null, { standard: true }, request.actor.person_id);
  })();
  return reply.code(201).send({ message: 'Standard workstreams ready.' });
});

app.post('/api/workstreams', async (request, reply) => {
  const body = request.body || {};
  if (!body.workstreamCode || !body.workstreamName) return reply.code(422).send({ message: 'Workstream code and name are required.' });
  const id = randomUUID();
  try {
    db.transaction(() => {
      const nextSortOrder = db.prepare('SELECT COALESCE(MAX(sort_order), 0) + 1 AS value FROM project_workstreams WHERE project_id = ?').get(request.projectId).value;
      db.prepare(`INSERT INTO project_workstreams (workstream_id, project_id, workstream_code, workstream_name, description, sort_order)
        VALUES (?, ?, ?, ?, ?, ?)`)
        .run(id, request.projectId, body.workstreamCode.trim().toUpperCase(), body.workstreamName.trim(), body.description?.trim() || null, Number(body.sortOrder) || nextSortOrder);
      audit('workstream.create', 'ProjectWorkstream', id, null, { ...body, workstreamId: id }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Workstream code already exists in this project.' }); }
  return reply.code(201).send({ workstreamId: id });
});

app.patch('/api/workstreams/:workstreamId', async (request, reply) => {
  const before = projectWorkstream(request.params.workstreamId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Workstream not found.' });
  const body = request.body || {};
  const fields = { workstreamCode: 'workstream_code', workstreamName: 'workstream_name', description: 'description', sortOrder: 'sort_order' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, input === 'workstreamCode' ? body[input]?.trim().toUpperCase() : body[input]?.trim() || null])) };
  try {
    db.transaction(() => {
      db.prepare(`UPDATE project_workstreams SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE workstream_id = ?`)
        .run(...changes.map(([input]) => input === 'workstreamCode' ? body[input]?.trim().toUpperCase() : body[input]?.trim() || null), before.workstream_id);
      if (body.workstreamName && body.workstreamName.trim() !== before.workstream_name) {
        db.prepare('UPDATE tasks SET workstream = ?, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND workstream = ?')
          .run(body.workstreamName.trim(), request.projectId, before.workstream_name);
      }
      audit('workstream.update', 'ProjectWorkstream', before.workstream_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Workstream code already exists.' }); }
  return projectWorkstream(before.workstream_id, request.projectId);
});

app.delete('/api/workstreams/:workstreamId', async (request, reply) => {
  const before = projectWorkstream(request.params.workstreamId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Workstream not found.' });
  db.transaction(() => {
    db.prepare('UPDATE project_workstreams SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE workstream_id = ?').run(before.workstream_id);
    audit('workstream.delete', 'ProjectWorkstream', before.workstream_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/roles', async (request) => db.prepare(`SELECT pr.*, COUNT(pm.project_member_id) AS member_count
  FROM project_roles pr
  LEFT JOIN project_members pm ON (pm.project_role = pr.role_code OR pm.project_role = pr.role_name) AND pm.project_id = pr.project_id AND pm.deleted_at IS NULL
  WHERE pr.project_id = ? AND pr.deleted_at IS NULL
  GROUP BY pr.role_id ORDER BY pr.sort_order, pr.role_code`).all(request.projectId));

app.post('/api/roles/standard', async (request, reply) => {
  db.transaction(() => {
    seedStandardRoles(request.projectId);
    audit('role.standard_seed', 'ProjectRole', request.projectId, null, { standard: true }, request.actor.person_id);
  })();
  return reply.code(201).send({ message: 'Standard roles ready.' });
});

app.post('/api/roles', async (request, reply) => {
  const body = request.body || {};
  if (!body.roleCode || !body.roleName) return reply.code(422).send({ message: 'Role code and role name are required.' });
  const id = randomUUID();
  try {
    db.transaction(() => {
      const nextSortOrder = db.prepare('SELECT COALESCE(MAX(sort_order), 0) + 1 AS value FROM project_roles WHERE project_id = ?').get(request.projectId).value;
      db.prepare(`INSERT INTO project_roles (role_id, project_id, role_code, role_name, description, sort_order)
        VALUES (?, ?, ?, ?, ?, ?)`)
        .run(id, request.projectId, body.roleCode.trim(), body.roleName.trim(), body.description?.trim() || null, Number(body.sortOrder) || nextSortOrder);
      audit('role.create', 'ProjectRole', id, null, { ...body, roleId: id }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Role code already exists in this project.' }); }
  return reply.code(201).send({ roleId: id });
});

app.patch('/api/roles/:roleId', async (request, reply) => {
  const before = projectRole(request.params.roleId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Role not found.' });
  const body = request.body || {};
  const fields = { roleCode: 'role_code', roleName: 'role_name', description: 'description', sortOrder: 'sort_order' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, input === 'roleCode' ? body[input]?.trim() : body[input]?.trim() || null])) };
  try {
    db.transaction(() => {
      db.prepare(`UPDATE project_roles SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE role_id = ?`)
        .run(...changes.map(([input]) => input === 'roleCode' ? body[input]?.trim() : body[input]?.trim() || null), before.role_id);
      if (body.roleCode && body.roleCode.trim() !== before.role_code) {
        db.prepare('UPDATE project_members SET project_role = ?, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND project_role = ?')
          .run(body.roleCode.trim(), request.projectId, before.role_code);
      }
      audit('role.update', 'ProjectRole', before.role_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Role code already exists.' }); }
  return projectRole(before.role_id, request.projectId);
});

app.delete('/api/roles/:roleId', async (request, reply) => {
  const before = projectRole(request.params.roleId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Role not found.' });
  const inUse = db.prepare(`SELECT 1 FROM project_members
    WHERE project_id = ? AND (project_role = ? OR project_role = ?) AND deleted_at IS NULL
    UNION ALL
    SELECT 1 FROM task_assignments ta JOIN tasks t ON t.task_id = ta.task_id
    WHERE t.project_id = ? AND (ta.assignment_role = ? OR ta.assignment_role = ?) AND ta.deleted_at IS NULL AND t.deleted_at IS NULL
    LIMIT 1`).get(request.projectId, before.role_code, before.role_name, request.projectId, before.role_code, before.role_name);
  if (inUse) return reply.code(422).send({ message: 'Reassign team members before deleting this role.' });
  db.transaction(() => {
    db.prepare('UPDATE project_roles SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE role_id = ?').run(before.role_id);
    audit('role.delete', 'ProjectRole', before.role_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/wbs', async (request) => db.prepare(`SELECT w.*, p.phase_code, p.phase_name, COUNT(t.task_id) AS task_count FROM wbs_items w
  LEFT JOIN project_phases p ON p.phase_id = w.phase_id AND p.deleted_at IS NULL
  LEFT JOIN tasks t ON t.wbs_item_id = w.wbs_item_id AND t.deleted_at IS NULL
  WHERE w.project_id = ? AND w.deleted_at IS NULL GROUP BY w.wbs_item_id ORDER BY COALESCE(p.sort_order, 9999), w.sort_order, w.wbs_code`).all(request.projectId));

app.post('/api/wbs', async (request, reply) => {
  const body = request.body || {};
  if (!body.wbsCode || !body.wbsName) return reply.code(422).send({ message: 'Activity code and activity name are required.' });
  if (!body.phaseId) return reply.code(422).send({ message: 'Choose an implementation phase before creating an activity.' });
  if (!projectPhase(body.phaseId, request.projectId)) return reply.code(422).send({ message: 'Phase not found in the selected project.' });
  const id = randomUUID();
  try {
    db.transaction(() => {
      const nextSortOrder = db.prepare('SELECT COALESCE(MAX(sort_order), 0) + 1 AS value FROM wbs_items WHERE project_id = ?').get(request.projectId).value;
      db.prepare('INSERT INTO wbs_items (wbs_item_id, project_id, wbs_code, wbs_name, sort_order, phase_id) VALUES (?, ?, ?, ?, ?, ?)')
        .run(id, request.projectId, body.wbsCode, body.wbsName, Number(body.sortOrder) || nextSortOrder, body.phaseId || null);
      audit('activity.create', 'ProjectActivity', id, null, { ...body, wbsItemId: id }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Activity code already exists in this project.' }); }
  return reply.code(201).send({ wbsItemId: id });
});

app.patch('/api/wbs/:wbsItemId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM wbs_items WHERE wbs_item_id = ? AND project_id = ? AND deleted_at IS NULL').get(request.params.wbsItemId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Activity not found.' });
  const body = request.body || {};
  if (body.phaseId !== undefined && !body.phaseId) return reply.code(422).send({ message: 'An activity must remain in an implementation phase.' });
  if (body.phaseId !== undefined && !projectPhase(body.phaseId, request.projectId)) return reply.code(422).send({ message: 'Phase not found in the selected project.' });
  const fields = { wbsCode: 'wbs_code', wbsName: 'wbs_name', sortOrder: 'sort_order', phaseId: 'phase_id' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input]])) };
  try {
    db.transaction(() => {
      db.prepare(`UPDATE wbs_items SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE wbs_item_id = ?`)
        .run(...changes.map(([input]) => input === 'phaseId' ? body[input] || null : body[input]), before.wbs_item_id);
      audit('activity.update', 'ProjectActivity', before.wbs_item_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Activity code already exists in this project.' }); }
  return db.prepare('SELECT * FROM wbs_items WHERE wbs_item_id = ?').get(before.wbs_item_id);
});

app.delete('/api/wbs/:wbsItemId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM wbs_items WHERE wbs_item_id = ? AND project_id = ? AND deleted_at IS NULL').get(request.params.wbsItemId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Activity not found.' });
  const taskRows = db.prepare('SELECT * FROM tasks WHERE wbs_item_id = ? AND deleted_at IS NULL').all(before.wbs_item_id);
  db.transaction(() => {
    archiveTasks(taskRows, request.actor.person_id, 'task.archive_for_activity_delete');
    db.prepare('UPDATE wbs_items SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE wbs_item_id = ?').run(before.wbs_item_id);
    audit('activity.delete', 'ProjectActivity', before.wbs_item_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/people', async (request) => db.prepare(`SELECT p.person_id, p.employee_code, p.display_name, p.email, p.department, p.position_title, p.person_status,
    CASE WHEN pm.project_member_id IS NULL THEN 0 ELSE 1 END AS is_project_member, pm.project_role,
    CASE WHEN EXISTS (SELECT 1 FROM user_accounts ua WHERE ua.person_id = p.person_id AND ua.deleted_at IS NULL) THEN 1 ELSE 0 END AS has_account
  FROM people p LEFT JOIN project_members pm ON pm.person_id = p.person_id AND pm.project_id = ? AND pm.deleted_at IS NULL
  WHERE p.deleted_at IS NULL ORDER BY p.display_name`).all(request.projectId));

app.get('/api/project-members', async (request) => db.prepare(`SELECT p.person_id, p.employee_code, p.display_name, p.email, p.department, p.position_title, p.person_status,
    pm.project_member_id, pm.project_role, pm.is_main_pm, 1 AS is_project_member
  FROM project_members pm JOIN people p ON p.person_id = pm.person_id
  WHERE pm.project_id = ? AND pm.deleted_at IS NULL AND p.deleted_at IS NULL AND p.person_status = 'Active'
    AND (p.employee_code <> 'DEMO-RRMS-PM' OR pm.is_main_pm = 1 OR EXISTS (SELECT 1 FROM tasks t WHERE t.project_id = pm.project_id AND t.owner_person_id = p.person_id AND t.deleted_at IS NULL))
  ORDER BY p.display_name`).all(request.projectId));

app.post('/api/people', async (request, reply) => {
  const body = request.body || {};
  if (!body.employeeCode || !body.displayName) return reply.code(422).send({ message: 'Employee code and display name are required.' });
  const assignedProjectRole = body.projectRole || 'TeamMember';
  if (!isValidProjectRole(assignedProjectRole, request.projectId)) return reply.code(422).send({ message: 'Project role is invalid.' });
  const existingPerson = db.prepare('SELECT * FROM people WHERE employee_code = ? AND deleted_at IS NULL').get(body.employeeCode);
  if (existingPerson) {
    ensureActiveProjectMember(existingPerson.person_id, request.projectId, assignedProjectRole);
    db.prepare('UPDATE project_members SET project_role = ?, updated_at = CURRENT_TIMESTAMP WHERE project_id = ? AND person_id = ?')
      .run(assignedProjectRole, request.projectId, existingPerson.person_id);
    return reply.code(201).send({ personId: existingPerson.person_id });
  }
  const id = randomUUID();
  try {
    db.transaction(() => {
      db.prepare(`INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
        VALUES (?, ?, ?, ?, ?, ?, 'Active')`).run(id, body.employeeCode, body.displayName, body.email || `${id}@local.invalid`, body.department || null, body.positionTitle || null);
      audit('people.create', 'People', id, null, { ...body, personId: id }, request.actor.person_id);
      const membershipId = randomUUID();
      db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
        VALUES (?, ?, ?, ?, 0)`).run(membershipId, request.projectId, id, assignedProjectRole);
      audit('project_member.create', 'ProjectMember', membershipId, null, { personId: id, projectId: request.projectId, projectRole: assignedProjectRole }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Employee code or email already exists.' }); }
  return reply.code(201).send({ personId: id });
});

function editablePerson(personId, scopedProjectId) {
  return db.prepare(`SELECT p.*, pm.project_member_id, pm.project_role, pm.is_main_pm
    FROM people p LEFT JOIN project_members pm ON pm.person_id = p.person_id AND pm.project_id = ? AND pm.deleted_at IS NULL
    WHERE p.person_id = ? AND p.deleted_at IS NULL`).get(scopedProjectId, personId);
}

app.patch('/api/people/:personId', async (request, reply) => {
  const before = editablePerson(request.params.personId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Person not found.' });
  const body = request.body || {};
  if (body.projectRole && !isValidProjectRole(body.projectRole, request.projectId)) return reply.code(422).send({ message: 'Project role is invalid.' });
  if (body.email !== undefined && !body.email) return reply.code(422).send({ message: 'Email cannot be empty.' });
  const fields = { employeeCode: 'employee_code', displayName: 'display_name', email: 'email', department: 'department', positionTitle: 'position_title' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length && body.projectRole === undefined) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input]])), project_role: body.projectRole ?? before.project_role };
  try {
    db.transaction(() => {
      if (changes.length) {
        db.prepare(`UPDATE people SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE person_id = ?`)
          .run(...changes.map(([input]) => body[input]), before.person_id);
      }
      if (body.projectRole !== undefined && before.project_member_id) {
        db.prepare('UPDATE project_members SET project_role = ?, updated_at = CURRENT_TIMESTAMP WHERE project_member_id = ?').run(body.projectRole, before.project_member_id);
      } else if (body.projectRole !== undefined) {
        // The People screen also lists people who exist outside the selected
        // project. Selecting a project role for one of them must create the
        // missing membership; otherwise the person can look like a team member
        // in the UI but cannot be selected as an owner or assignee.
        const existingMembership = db.prepare('SELECT * FROM project_members WHERE project_id = ? AND person_id = ?').get(request.projectId, before.person_id);
        if (existingMembership) {
          db.prepare('UPDATE project_members SET project_role = ?, deleted_at = NULL, updated_at = CURRENT_TIMESTAMP WHERE project_member_id = ?')
            .run(body.projectRole, existingMembership.project_member_id);
        } else {
          const membershipId = randomUUID();
          db.prepare(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
            VALUES (?, ?, ?, ?, 0)`).run(membershipId, request.projectId, before.person_id, body.projectRole);
          audit('project_member.create', 'ProjectMember', membershipId, null,
            { personId: before.person_id, projectId: request.projectId, projectRole: body.projectRole }, request.actor.person_id);
        }
      }
      audit('people.update', 'People', before.person_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'Employee code or email already exists.' }); }
  return editablePerson(before.person_id, request.projectId);
});

app.delete('/api/people/:personId', async (request, reply) => {
  const before = editablePerson(request.params.personId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Person not found.' });
  if (before.person_id === request.actor.person_id) return reply.code(422).send({ message: 'You cannot delete the account currently signed in.' });
  if (before.is_main_pm) return reply.code(422).send({ message: 'Assign another Main PM before deleting this person.' });
  if (db.prepare('SELECT 1 FROM tasks WHERE owner_person_id = ? AND project_id = ? AND deleted_at IS NULL').get(before.person_id, request.projectId)) {
    return reply.code(422).send({ message: 'Reassign this person’s work items before deleting them.' });
  }
  db.transaction(() => {
    db.prepare('UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE person_id = ? AND deleted_at IS NULL').run(before.person_id);
    db.prepare('UPDATE project_members SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE person_id = ? AND project_id = ? AND deleted_at IS NULL').run(before.person_id, request.projectId);
    db.prepare('UPDATE people SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE person_id = ?').run(before.person_id);
    audit('people.delete', 'People', before.person_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

// ── Workload View ─────────────────────────────────────────────────────────────
app.get('/api/workload', async (request) => {
  const today = new Date().toISOString().slice(0, 10);
  const weekEnd = new Date(new Date(today));
  weekEnd.setDate(weekEnd.getDate() + (6 - ((weekEnd.getDay() + 6) % 7)));
  const weekEndStr = weekEnd.toISOString().slice(0, 10);

  const members = db.prepare(`
    SELECT p.person_id, p.display_name, p.employee_code, p.department, p.position_title,
      pm.project_role
    FROM project_members pm
    JOIN people p ON p.person_id = pm.person_id
    WHERE pm.project_id = ? AND pm.deleted_at IS NULL AND p.deleted_at IS NULL
      AND (pm.active_from IS NULL OR pm.active_from <= date('now'))
      AND (pm.active_to IS NULL OR pm.active_to >= date('now'))
    ORDER BY p.display_name
  `).all(request.projectId);

  const projectTasks = db.prepare(`
    SELECT t.task_id, t.task_code, t.task_name, t.task_type, t.status, t.rag_status,
      t.progress, t.planned_start_date, t.planned_due_date, t.workstream,
      t.owner_person_id,
      w.wbs_code, w.wbs_name,
      ph.phase_name, ph.phase_code,
      p.display_name AS owner_name
    FROM tasks t
    JOIN wbs_items w ON w.wbs_item_id = t.wbs_item_id
    LEFT JOIN project_phases ph ON ph.phase_id = w.phase_id AND ph.deleted_at IS NULL
    JOIN people p ON p.person_id = t.owner_person_id
    WHERE t.project_id = ? AND t.deleted_at IS NULL
    ORDER BY t.planned_due_date ASC, t.task_code
  `).all(request.projectId);

  const allAssignments = db.prepare(`
    SELECT ta.task_id, ta.person_id, ta.assignment_role, ta.raci_role, ta.is_primary
    FROM task_assignments ta
    JOIN tasks t ON t.task_id = ta.task_id
    WHERE t.project_id = ? AND ta.deleted_at IS NULL AND t.deleted_at IS NULL
  `).all(request.projectId);

  const latestBlockers = db.prepare(`
    SELECT wu.task_id, wu.blocker, wu.next_step, wu.week_start_date
    FROM weekly_updates wu
    JOIN tasks t ON t.task_id = wu.task_id
    WHERE t.project_id = ? AND wu.deleted_at IS NULL AND wu.blocker IS NOT NULL AND wu.blocker != ''
  `).all(request.projectId);
  const blockerMap = new Map();
  for (const b of latestBlockers) {
    if (!blockerMap.has(b.task_id) || b.week_start_date > blockerMap.get(b.task_id).week_start_date) {
      blockerMap.set(b.task_id, b);
    }
  }

  const assignmentsByPerson = new Map();
  for (const a of allAssignments) {
    if (!assignmentsByPerson.has(a.person_id)) assignmentsByPerson.set(a.person_id, []);
    assignmentsByPerson.get(a.person_id).push(a);
  }
  const taskMap = new Map(projectTasks.map((t) => [t.task_id, t]));

  const result = members.map((member) => {
    const assignedTaskIds = new Set((assignmentsByPerson.get(member.person_id) || []).map((a) => a.task_id));
    const ownedTaskIds = new Set(projectTasks.filter((t) => t.owner_person_id === member.person_id).map((t) => t.task_id));
    const allPersonTaskIds = new Set([...assignedTaskIds, ...ownedTaskIds]);
    const personTasks = [...allPersonTaskIds].map((id) => taskMap.get(id)).filter(Boolean);
    const openTasks = personTasks.filter((t) => t.status !== 'Done');
    const statusPriority = { InProgress: 0, Blocked: 1, OnHold: 2, NotStarted: 3 };
    openTasks.sort((a, b) => {
      const priorityDifference = (statusPriority[a.status] ?? 99) - (statusPriority[b.status] ?? 99);
      if (priorityDifference !== 0) return priorityDifference;
      const dueDateDifference = (a.planned_due_date || '9999-12-31').localeCompare(b.planned_due_date || '9999-12-31');
      return dueDateDifference || a.task_code.localeCompare(b.task_code);
    });

    const total = openTasks.length;
    const total_tasks = personTasks.length;
    const completed = total_tasks - total;
    const in_progress = openTasks.filter((t) => t.status === 'InProgress').length;
    const not_started = openTasks.filter((t) => t.status === 'NotStarted').length;
    const blocked = openTasks.filter((t) => t.status === 'Blocked').length;
    const on_hold = openTasks.filter((t) => t.status === 'OnHold').length;
    const overdue = openTasks.filter((t) => t.planned_due_date && t.planned_due_date < today).length;
    const due_this_week = openTasks.filter((t) => t.planned_due_date && t.planned_due_date >= today && t.planned_due_date <= weekEndStr).length;
    const rag_red = openTasks.filter((t) => t.rag_status === 'Red').length;
    const rag_amber = openTasks.filter((t) => t.rag_status === 'Amber').length;
    const rag_green = openTasks.filter((t) => t.rag_status === 'Green').length;
    const avg_progress = total ? Math.round(openTasks.reduce((s, t) => s + (t.progress || 0), 0) / total) : 0;

    const tasks = openTasks.map((t) => ({
      ...t,
      is_owner: t.owner_person_id === member.person_id,
      assignment_role: (assignmentsByPerson.get(member.person_id) || []).find((a) => a.task_id === t.task_id)?.assignment_role || 'Owner',
      is_overdue: Boolean(t.planned_due_date && t.planned_due_date < today),
      is_due_this_week: Boolean(t.planned_due_date && t.planned_due_date >= today && t.planned_due_date <= weekEndStr),
      latest_blocker: blockerMap.get(t.task_id)?.blocker || null,
      latest_next_step: blockerMap.get(t.task_id)?.next_step || null,
    }));

    return { ...member, total, total_tasks, completed, in_progress, not_started, blocked, on_hold, overdue, due_this_week, avg_progress, rag_red, rag_amber, rag_green, tasks };
  });

  return { today, weekEnd: weekEndStr, members: result };
});

app.get('/api/assignments', async (request) => db.prepare(`SELECT ta.*, t.task_code, t.task_name, p.display_name FROM task_assignments ta
  JOIN tasks t ON t.task_id = ta.task_id JOIN people p ON p.person_id = ta.person_id
  WHERE t.project_id = ? AND ta.deleted_at IS NULL ORDER BY t.task_code, p.display_name`).all(request.projectId));

app.post('/api/assignments', async (request, reply) => {
  const body = request.body || {};
  if (!body.taskId || !body.personId || !body.assignmentRole) return reply.code(422).send({ message: 'Task, person and assignment role are required.' });
  if (!isValidAssignmentRole(body.assignmentRole, request.projectId)) return reply.code(422).send({ message: 'Assignment role is invalid.' });
  const task = projectTask(body.taskId, request.projectId);
  if (!task) return reply.code(422).send({ message: 'Task not found in the selected project.' });
  const person = db.prepare('SELECT person_id FROM people WHERE person_id = ? AND deleted_at IS NULL').get(body.personId);
  if (!person) return reply.code(422).send({ message: 'Unknown person.' });
  let member = activeProjectMember(body.personId, request.projectId);
  if (!member && body.assignmentRole === 'Owner') {
    member = ensureActiveProjectMember(body.personId, request.projectId, 'TeamMember');
  }
  if (!member) return reply.code(422).send({ message: 'Person is not an active project member.' });
  const id = randomUUID();
  let resultId = id;
  try {
    db.transaction(() => {
      const existing = db.prepare('SELECT * FROM task_assignments WHERE task_id = ? AND person_id = ? AND assignment_role = ?')
        .get(body.taskId, body.personId, body.assignmentRole);
      if (existing) {
        if (existing.deleted_at === null) {
          throw new Error('This assignment already exists.');
        }
        db.prepare(`UPDATE task_assignments SET deleted_at = NULL, raci_role = ?, allocation_percent = ?, is_primary = ?, updated_at = CURRENT_TIMESTAMP
          WHERE task_assignment_id = ?`).run(body.raciRole || null, body.allocationPercent ?? null, body.isPrimary ? 1 : 0, existing.task_assignment_id);
        resultId = existing.task_assignment_id;
        audit('assignment.reactivate', 'TaskAssignment', existing.task_assignment_id, existing, body, request.actor.person_id);
      } else {
        db.prepare(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
          VALUES (?, ?, ?, ?, ?, ?)`).run(id, body.taskId, body.personId, body.assignmentRole, body.raciRole || null, body.isPrimary ? 1 : 0);
        audit('assignment.create', 'TaskAssignment', id, null, body, request.actor.person_id);
      }
      if (body.assignmentRole === 'Owner') {
        resultId = setTaskOwner(body.taskId, body.personId);
        if (task.owner_person_id !== body.personId) {
          audit('task.update', 'Task', task.task_id, task, { ...task, owner_person_id: body.personId }, request.actor.person_id);
        }
      }
    })();
  } catch (error) { return reply.code(409).send({ message: error.message || 'This assignment already exists.' }); }
  return reply.code(201).send({ taskAssignmentId: resultId });
});

function projectAssignment(assignmentId, scopedProjectId) {
  return db.prepare(`SELECT ta.* FROM task_assignments ta JOIN tasks t ON t.task_id = ta.task_id
    WHERE ta.task_assignment_id = ? AND t.project_id = ? AND ta.deleted_at IS NULL`).get(assignmentId, scopedProjectId);
}

app.patch('/api/assignments/:assignmentId', async (request, reply) => {
  const before = projectAssignment(request.params.assignmentId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Assignment not found.' });
  const body = request.body || {};
  const fields = { taskId: 'task_id', personId: 'person_id', assignmentRole: 'assignment_role', raciRole: 'raci_role', allocationPercent: 'allocation_percent', isPrimary: 'is_primary' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input]])) };
  if (!isValidAssignmentRole(after.assignment_role, request.projectId)) return reply.code(422).send({ message: 'Assignment role is invalid.' });
  const targetTask = projectTask(after.task_id, request.projectId);
  if (!targetTask) return reply.code(422).send({ message: 'Work item was not found in the selected project.' });
  let member = activeProjectMember(after.person_id, request.projectId);
  if (!member && after.assignment_role === 'Owner') {
    member = ensureActiveProjectMember(after.person_id, request.projectId, 'TeamMember');
  }
  if (!member) return reply.code(422).send({ message: 'Person must be an active project member.' });
  if (after.raci_role && !['Responsible', 'Accountable', 'Consulted', 'Informed'].includes(after.raci_role)) return reply.code(422).send({ message: 'RACI role is invalid.' });
  if (after.allocation_percent !== null && after.allocation_percent !== '' && (!Number.isFinite(Number(after.allocation_percent)) || Number(after.allocation_percent) < 0 || Number(after.allocation_percent) > 100)) return reply.code(422).send({ message: 'Allocation must be between 0 and 100.' });
  if (![0, 1, '0', '1', false, true, undefined].includes(after.is_primary)) return reply.code(422).send({ message: 'Primary flag is invalid.' });
  const priorTask = projectTask(before.task_id, request.projectId);
  const movesCurrentOwner = priorTask?.owner_person_id === before.person_id && before.assignment_role === 'Owner'
    && (after.task_id !== before.task_id || after.assignment_role !== 'Owner');
  if (movesCurrentOwner) return reply.code(422).send({ message: 'Assign a new Owner before moving or changing the current Owner assignment.' });
  try {
    db.transaction(() => {
      db.prepare(`UPDATE task_assignments SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE task_assignment_id = ?`)
        .run(...changes.map(([input]) => input === 'isPrimary' ? (body[input] ? 1 : 0) : (body[input] === '' ? null : body[input])), before.task_assignment_id);
      if (after.assignment_role === 'Owner') {
        setTaskOwner(after.task_id, after.person_id);
        if (targetTask.owner_person_id !== after.person_id) {
          audit('task.update', 'Task', targetTask.task_id, targetTask, { ...targetTask, owner_person_id: after.person_id }, request.actor.person_id);
        }
      }
      audit('assignment.update', 'TaskAssignment', before.task_assignment_id, before, after, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: 'This assignment already exists.' }); }
  return projectAssignment(before.task_assignment_id, request.projectId);
});

app.delete('/api/assignments/:assignmentId', async (request, reply) => {
  const before = projectAssignment(request.params.assignmentId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Assignment not found.' });
  const task = projectTask(before.task_id, request.projectId);
  if (before.assignment_role === 'Owner' && task?.owner_person_id === before.person_id) {
    return reply.code(422).send({ message: 'Assign a new Owner before deleting the current Owner assignment.' });
  }
  db.transaction(() => {
    db.prepare('UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_assignment_id = ?').run(before.task_assignment_id);
    audit('assignment.delete', 'TaskAssignment', before.task_assignment_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.post('/api/tasks', async (request, reply) => {
  const body = request.body || {};
  if (!body.wbsItemId || !body.taskCode || !body.taskName || !body.taskType) return reply.code(422).send({ message: 'WBS, code, name and type are required.' });
  if (!['MainTask', 'Task', 'Subtask'].includes(body.taskType)) return reply.code(422).send({ message: 'Task type is invalid.' });
  const id = randomUUID();
  const taskCode = nextAvailableTaskCode(request.projectId, String(body.taskCode).trim());
  const owner = body.ownerPersonId || body.owner_person_id || request.actor.person_id;
  const wbs = db.prepare('SELECT * FROM wbs_items WHERE wbs_item_id = ? AND project_id = ? AND deleted_at IS NULL').get(body.wbsItemId, request.projectId);
  if (!wbs) return reply.code(422).send({ message: 'Activity not found in the selected project.' });
  let member = activeProjectMember(owner, request.projectId);
  if (!member) {
    member = ensureActiveProjectMember(owner, request.projectId);
  }
  if (!member) return reply.code(422).send({ message: 'Owner is not an active project member.' });
  const parent = body.parentTaskId ? projectTask(body.parentTaskId, request.projectId) : null;
  if (body.taskType === 'MainTask' && body.parentTaskId) return reply.code(422).send({ message: 'A Main Task cannot have a parent task.' });
  if (body.taskType !== 'MainTask' && !parent) return reply.code(422).send({ message: `${body.taskType} requires a valid parent task.` });
  if (parent && parent.wbs_item_id !== body.wbsItemId) return reply.code(422).send({ message: 'Parent task must belong to the same WBS.' });
  const expectedParentType = { Task: 'MainTask', Subtask: 'Task' }[body.taskType];
  if (parent && parent.task_type !== expectedParentType) return reply.code(422).send({ message: `${body.taskType} must have a ${expectedParentType} parent.` });
  const progress = Number(body.progress || 0);
  const weight = Number(body.weight || 0);
  if (!taskStatuses.has(body.status || 'NotStarted')) return reply.code(422).send({ message: 'Task status is invalid.' });
  if (!ragStatuses.has(body.ragStatus || 'Green')) return reply.code(422).send({ message: 'RAG status is invalid.' });
  if (!Number.isFinite(progress) || progress < 0 || progress > 100) return reply.code(422).send({ message: 'Progress must be between 0 and 100.' });
  if (!Number.isFinite(weight) || weight < 0 || weight > 100) return reply.code(422).send({ message: 'Weight must be between 0 and 100.' });
  if (body.plannedStartDate && body.plannedDueDate && body.plannedDueDate < body.plannedStartDate) return reply.code(422).send({ message: 'Plan end date cannot be before plan start date.' });
  const workstream = typeof body.workstream === 'string' ? body.workstream.trim() || null : null;
  try {
    db.transaction(() => {
      db.prepare(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, owner_person_id, planned_start_date, planned_due_date, status, rag_status, weight, progress, evidence_required, workstream)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`)
        .run(id, request.projectId, body.wbsItemId, body.parentTaskId || null, taskCode, body.taskType, body.taskName, owner, body.plannedStartDate || null, body.plannedDueDate || null, body.status || 'NotStarted', body.ragStatus || 'Green', weight, progress, body.evidenceRequired ? 1 : 0, workstream);
      setTaskOwner(id, owner);
      if (body.parentTaskId) {
        rollupTaskProgress(body.parentTaskId);
      }
      audit('task.create', 'Task', id, null, { ...body, taskCode, ownerPersonId: owner, workstream }, request.actor.person_id);
    })();
  } catch (error) { return reply.code(409).send({ message: error.message.includes('UNIQUE') ? 'Task code already exists.' : 'Could not create task.' }); }
  return reply.code(201).send({ taskId: id, taskCode, codeAdjusted: taskCode !== body.taskCode });
});

app.patch('/api/tasks/:taskId', async (request, reply) => {
  const before = db.prepare('SELECT * FROM tasks WHERE task_id = ? AND project_id = ?').get(request.params.taskId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Task not found.' });
  const body = request.body || {};
  // Accept the snake_case field used by the structure editor and the camelCase
  // field used by creation flows.  Detect the field by presence, rather than
  // truthiness, so an empty selection gets a useful validation response instead
  // of attempting to write an invalid foreign key.
  const ownerSupplied = Object.hasOwn(body, 'owner_person_id') || Object.hasOwn(body, 'ownerPersonId');
  const owner = Object.hasOwn(body, 'owner_person_id') ? body.owner_person_id : body.ownerPersonId;
  if (ownerSupplied && (typeof owner !== 'string' || !owner.trim())) {
    return reply.code(422).send({ message: 'Owner cannot be empty.' });
  }
  if (ownerSupplied) {
    let member = activeProjectMember(owner.trim(), request.projectId);
    if (!member) {
      member = ensureActiveProjectMember(owner.trim(), request.projectId);
    }
    if (!member) return reply.code(422).send({ message: 'Owner is not an active project member.' });
  }

  const fields = ['task_name', 'status', 'rag_status', 'progress', 'planned_due_date', 'workstream', 'owner_person_id'];
  const mappedBody = {
    ...body,
    ...(ownerSupplied ? { owner_person_id: owner.trim() } : {})
  };

  // Auto-sync status and progress when only one is provided
  if (mappedBody.status === 'Done' && mappedBody.progress === undefined) {
    mappedBody.progress = 100;
  } else if (mappedBody.status === 'NotStarted' && mappedBody.progress === undefined) {
    mappedBody.progress = 0;
  } else if (mappedBody.progress !== undefined && Number(mappedBody.progress) === 100 && mappedBody.status === undefined) {
    mappedBody.status = 'Done';
  }

  const changes = fields.filter((field) => mappedBody[field] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map((field) => [field, field === 'workstream' && typeof mappedBody[field] === 'string' ? mappedBody[field].trim() || null : mappedBody[field]])) };
  if (!taskStatuses.has(after.status)) return reply.code(422).send({ message: 'Task status is invalid.' });
  if (after.rag_status && !ragStatuses.has(after.rag_status)) return reply.code(422).send({ message: 'RAG status is invalid.' });
  if (!Number.isFinite(Number(after.progress)) || Number(after.progress) < 0 || Number(after.progress) > 100) {
    return reply.code(422).send({ message: 'Progress must be between 0 and 100.' });
  }
  if (after.status === 'Done' && Number(after.progress) !== 100) {
    return reply.code(422).send({ message: 'A completed task must have 100% progress.' });
  }

  db.transaction(() => {
    db.prepare(`UPDATE tasks SET ${changes.map((field) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?`)
      .run(...changes.map((field) => {
        if (field === 'progress') return after.progress;
        if (field === 'status') return after.status;
        if (field === 'workstream') return typeof mappedBody[field] === 'string' ? mappedBody[field].trim() || null : mappedBody[field];
        return mappedBody[field];
      }), before.task_id);
    if (ownerSupplied) {
      setTaskOwner(before.task_id, owner);
    }
    if (before.parent_task_id) {
      rollupTaskProgress(before.parent_task_id);
    }
    audit('task.update', 'Task', before.task_id, before, after, request.actor.person_id);
  })();
  return db.prepare(`SELECT t.*, p.display_name AS owner_name
    FROM tasks t
    JOIN people p ON p.person_id = t.owner_person_id
    WHERE t.task_id = ?`).get(before.task_id);
});

app.get('/api/task-notes', async (request, reply) => {
  const taskId = request.query?.taskId;
  if (!taskId || !projectTask(taskId, request.projectId)) return reply.code(422).send({ message: 'A task in the selected project is required.' });
  const notes = db.prepare(`SELECT n.*, p.display_name AS created_by_name FROM task_notes n
    JOIN people p ON p.person_id = n.created_by_person_id
    WHERE n.task_id = ? AND n.deleted_at IS NULL ORDER BY n.created_at DESC`).all(taskId);
  const files = db.prepare(`SELECT f.* FROM task_note_files f JOIN task_notes n ON n.task_note_id = f.task_note_id
    WHERE n.task_id = ? AND n.deleted_at IS NULL AND f.deleted_at IS NULL ORDER BY f.created_at`).all(taskId);
  return notes.map((note) => ({ ...note, files: files.filter((file) => file.task_note_id === note.task_note_id) }));
});

app.post('/api/task-notes', async (request, reply) => {
  const body = request.body || {};
  const noteText = String(body.noteText || '').trim();
  const noteType = body.noteType || 'Note';
  if (!body.taskId || !noteText) return reply.code(422).send({ message: 'Task and note text are required.' });
  if (!['Note', 'Update'].includes(noteType)) return reply.code(422).send({ message: 'Note type is invalid.' });
  if (!projectTask(body.taskId, request.projectId)) return reply.code(422).send({ message: 'Task not found in the selected project.' });
  const id = randomUUID();
  db.transaction(() => {
    db.prepare('INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id) VALUES (?, ?, ?, ?, ?)')
      .run(id, body.taskId, noteType, noteText, request.actor.person_id);
    audit('task_note.create', 'TaskNote', id, null, { taskId: body.taskId, noteType, noteText }, request.actor.person_id);
  })();
  return reply.code(201).send({ taskNoteId: id });
});

app.put('/api/task-notes/:noteId/files', async (request, reply) => {
  const note = projectTaskNote(request.params.noteId, request.projectId);
  if (!note) return reply.code(404).send({ message: 'Task note not found.' });
  if (!Buffer.isBuffer(request.body) || !request.body.length) return reply.code(422).send({ message: 'Choose a file to upload.' });
  if (request.body.length > maxTaskNoteFileBytes) return reply.code(413).send({ message: 'Each attachment must be 5 MB or smaller.' });
  const originalFileName = safeFileName(request.headers['x-file-name']);
  const fileType = typeof request.headers['x-file-type'] === 'string' ? request.headers['x-file-type'].slice(0, 200) : null;
  const id = randomUUID();
  const storageRef = `${id}-${originalFileName}`;
  fs.mkdirSync(taskNoteUploadDirectory, { recursive: true });
  fs.writeFileSync(path.join(taskNoteUploadDirectory, storageRef), request.body, { flag: 'wx' });
  try {
    db.prepare(`INSERT INTO task_note_files (task_note_file_id, task_note_id, original_file_name, file_type, file_size_bytes, storage_ref, uploaded_by_person_id)
      VALUES (?, ?, ?, ?, ?, ?, ?)`).run(id, note.task_note_id, originalFileName, fileType, request.body.length, storageRef, request.actor.person_id);
    audit('task_note_file.create', 'TaskNoteFile', id, null, { taskNoteId: note.task_note_id, originalFileName, fileSizeBytes: request.body.length }, request.actor.person_id);
    if (pgPool) {
      pgPool.query(`
        INSERT INTO task_note_attachments (storage_ref, file_data, created_at)
        VALUES ($1, $2, CURRENT_TIMESTAMP)
        ON CONFLICT (storage_ref) DO UPDATE SET file_data = EXCLUDED.file_data
      `, [storageRef, request.body]).catch((err) => console.warn('[db] Note on attachment persist:', err.message));
    }
  } catch (error) {
    fs.unlinkSync(path.join(taskNoteUploadDirectory, storageRef));
    throw error;
  }
  return reply.code(201).send({ taskNoteFileId: id, originalFileName, fileSizeBytes: request.body.length });
});

app.get('/api/task-note-files/:fileId/download', async (request, reply) => {
  const file = db.prepare(`SELECT f.* FROM task_note_files f JOIN task_notes n ON n.task_note_id = f.task_note_id
    JOIN tasks t ON t.task_id = n.task_id WHERE f.task_note_file_id = ? AND t.project_id = ?
      AND f.deleted_at IS NULL AND n.deleted_at IS NULL AND t.deleted_at IS NULL`).get(request.params.fileId, request.projectId);
  if (!file) return reply.code(404).send({ message: 'Attachment not found.' });
  const target = path.join(taskNoteUploadDirectory, file.storage_ref);
  if (!fs.existsSync(target) && pgPool) {
    try {
      const fileRes = await pgPool.query('SELECT file_data FROM task_note_attachments WHERE storage_ref = $1', [file.storage_ref]);
      if (fileRes.rows.length && fileRes.rows[0].file_data) {
        fs.mkdirSync(taskNoteUploadDirectory, { recursive: true });
        fs.writeFileSync(target, fileRes.rows[0].file_data);
      }
    } catch (fetchErr) {
      console.warn('[db] Note on attachment restore:', fetchErr.message);
    }
  }
  if (!fs.existsSync(target)) return reply.code(404).send({ message: 'Attachment file is no longer available.' });
  reply.header('Content-Disposition', `attachment; filename="${safeFileName(file.original_file_name)}"`);
  reply.type(file.file_type || 'application/octet-stream');
  return reply.send(fs.createReadStream(target));
});

app.delete('/api/tasks/:taskId', async (request, reply) => {
  const before = projectTask(request.params.taskId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Task not found.' });
  if (db.prepare('SELECT 1 FROM tasks WHERE parent_task_id = ? AND deleted_at IS NULL').get(before.task_id)) {
    return reply.code(422).send({ message: 'Delete or move child work items before deleting this item.' });
  }
  db.transaction(() => {
    db.prepare('UPDATE task_assignments SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id = ? AND deleted_at IS NULL').run(before.task_id);
    db.prepare('UPDATE weekly_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id = ? AND deleted_at IS NULL').run(before.task_id);
    db.prepare('UPDATE weekly_plans SET task_id = NULL, updated_at = CURRENT_TIMESTAMP WHERE task_id = ? AND deleted_at IS NULL').run(before.task_id);
    db.prepare('UPDATE task_note_files SET deleted_at = CURRENT_TIMESTAMP WHERE task_note_id IN (SELECT task_note_id FROM task_notes WHERE task_id = ?) AND deleted_at IS NULL').run(before.task_id);
    db.prepare('UPDATE task_notes SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id = ? AND deleted_at IS NULL').run(before.task_id);
    db.prepare('UPDATE tasks SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?').run(before.task_id);
    if (before.parent_task_id) {
      rollupTaskProgress(before.parent_task_id);
    }
    audit('task.delete', 'Task', before.task_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

function requestedWeekStart(request) {
  const value = request.query?.weekStart;
  return /^\d{4}-\d{2}-\d{2}$/.test(value || '') ? value : new Date().toISOString().slice(0, 10);
}

function projectWeeklyPlan(planId, scopedProjectId) {
  return db.prepare('SELECT * FROM weekly_plans WHERE weekly_plan_id = ? AND project_id = ? AND deleted_at IS NULL').get(planId, scopedProjectId);
}

app.get('/api/weekly-plans', async (request) => db.prepare(`SELECT wp.*, t.task_code, t.task_name, p.display_name AS owner_name
  FROM weekly_plans wp LEFT JOIN tasks t ON t.task_id = wp.task_id JOIN people p ON p.person_id = wp.owner_person_id
  WHERE wp.project_id = ? AND wp.week_start_date = ? AND wp.deleted_at IS NULL
  ORDER BY CASE wp.priority WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 ELSE 4 END, wp.created_at`)
  .all(request.projectId, requestedWeekStart(request)));

app.post('/api/weekly-plans', async (request, reply) => {
  const body = request.body || {};
  if (!body.weekStartDate || !body.planTitle || !body.ownerPersonId) return reply.code(422).send({ message: 'Week, plan title and owner are required.' });
  let member = activeProjectMember(body.ownerPersonId, request.projectId);
  if (!member) {
    member = ensureActiveProjectMember(body.ownerPersonId, request.projectId);
  }
  if (!member) return reply.code(422).send({ message: 'Owner must be an active project member.' });
  if (body.taskId && !projectTask(body.taskId, request.projectId)) return reply.code(422).send({ message: 'Linked work item was not found in this project.' });
  const priority = body.priority || 'Medium';
  const status = body.status || 'Planned';
  if (!['Low', 'Medium', 'High', 'Critical'].includes(priority) || !['Planned', 'InProgress', 'Done', 'Deferred'].includes(status)) return reply.code(422).send({ message: 'Priority or status is invalid.' });
  const id = randomUUID();
  db.prepare(`INSERT INTO weekly_plans (weekly_plan_id, project_id, task_id, week_start_date, plan_title, owner_person_id, owner_role, target_outcome, planned_due_date, priority, status, created_by_person_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`)
    .run(id, request.projectId, body.taskId || null, body.weekStartDate, body.planTitle.trim(), body.ownerPersonId, body.ownerRole || null, body.targetOutcome || null, body.plannedDueDate || null, priority, status, request.actor.person_id);
  audit('weekly_plan.create', 'WeeklyPlan', id, null, body, request.actor.person_id);
  return reply.code(201).send({ weeklyPlanId: id });
});

app.patch('/api/weekly-plans/:planId', async (request, reply) => {
  const before = projectWeeklyPlan(request.params.planId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Weekly plan not found.' });
  const body = request.body || {};
  if (body.ownerPersonId) {
    let member = activeProjectMember(body.ownerPersonId, request.projectId);
    if (!member) {
      member = ensureActiveProjectMember(body.ownerPersonId, request.projectId);
    }
    if (!member) return reply.code(422).send({ message: 'Owner must be an active project member.' });
  }
  if (body.taskId && !projectTask(body.taskId, request.projectId)) return reply.code(422).send({ message: 'Linked work item was not found in this project.' });
  if (body.priority && !['Low', 'Medium', 'High', 'Critical'].includes(body.priority)) return reply.code(422).send({ message: 'Priority is invalid.' });
  if (body.status && !['Planned', 'InProgress', 'Done', 'Deferred'].includes(body.status)) return reply.code(422).send({ message: 'Status is invalid.' });
  const fields = { weekStartDate: 'week_start_date', planTitle: 'plan_title', taskId: 'task_id', ownerPersonId: 'owner_person_id', ownerRole: 'owner_role', targetOutcome: 'target_outcome', plannedDueDate: 'planned_due_date', priority: 'priority', status: 'status' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  db.prepare(`UPDATE weekly_plans SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE weekly_plan_id = ?`)
    .run(...changes.map(([input]) => body[input] || null), before.weekly_plan_id);
  audit('weekly_plan.update', 'WeeklyPlan', before.weekly_plan_id, before, body, request.actor.person_id);
  return projectWeeklyPlan(before.weekly_plan_id, request.projectId);
});

app.delete('/api/weekly-plans/:planId', async (request, reply) => {
  const before = projectWeeklyPlan(request.params.planId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Weekly plan not found.' });
  db.prepare('UPDATE weekly_plans SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE weekly_plan_id = ?').run(before.weekly_plan_id);
  audit('weekly_plan.delete', 'WeeklyPlan', before.weekly_plan_id, before, null, request.actor.person_id);
  return reply.code(204).send();
});

function projectRoleUpdate(updateId, scopedProjectId) {
  return db.prepare('SELECT * FROM role_updates WHERE role_update_id = ? AND project_id = ? AND deleted_at IS NULL').get(updateId, scopedProjectId);
}

app.get('/api/role-updates', async (request) => db.prepare(`SELECT ru.*, p.display_name, p.employee_code
  FROM role_updates ru JOIN people p ON p.person_id = ru.person_id
  WHERE ru.project_id = ? AND ru.week_start_date = ? AND ru.deleted_at IS NULL ORDER BY p.display_name, ru.role_name`)
  .all(request.projectId, requestedWeekStart(request)));

app.post('/api/role-updates', async (request, reply) => {
  const body = request.body || {};
  if (!body.weekStartDate || !body.personId || !body.roleName) return reply.code(422).send({ message: 'Week, person and role are required.' });
  let member = activeProjectMember(body.personId, request.projectId);
  if (!member) {
    member = ensureActiveProjectMember(body.personId, request.projectId, isValidProjectRole(body.roleName, request.projectId) ? body.roleName : 'TeamMember');
  }
  if (!member) return reply.code(422).send({ message: 'Person must be an active project member.' });
  if (![body.accomplished, body.nextActions, body.blocker, body.supportNeeded].some((value) => String(value || '').trim())) return reply.code(422).send({ message: 'Add at least one update detail.' });
  const id = randomUUID();
  try {
    db.prepare(`INSERT INTO role_updates (role_update_id, project_id, week_start_date, person_id, role_name, accomplished, next_actions, blocker, support_needed)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`)
      .run(id, request.projectId, body.weekStartDate, body.personId, body.roleName.trim(), body.accomplished || null, body.nextActions || null, body.blocker || null, body.supportNeeded || null);
  } catch (error) { return reply.code(409).send({ message: 'This person and role already have an update for the selected week.' }); }
  audit('role_update.create', 'RoleUpdate', id, null, body, request.actor.person_id);
  return reply.code(201).send({ roleUpdateId: id });
});

app.patch('/api/role-updates/:updateId', async (request, reply) => {
  const before = projectRoleUpdate(request.params.updateId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Role update not found.' });
  const body = request.body || {};
  if (body.personId) {
    let member = activeProjectMember(body.personId, request.projectId);
    if (!member) {
      member = ensureActiveProjectMember(body.personId, request.projectId);
    }
    if (!member) return reply.code(422).send({ message: 'Person must be an active project member.' });
  }
  const fields = { weekStartDate: 'week_start_date', personId: 'person_id', roleName: 'role_name', accomplished: 'accomplished', nextActions: 'next_actions', blocker: 'blocker', supportNeeded: 'support_needed' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  try { db.prepare(`UPDATE role_updates SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE role_update_id = ?`)
    .run(...changes.map(([input]) => body[input] || null), before.role_update_id); }
  catch (error) { return reply.code(409).send({ message: 'This person and role already have an update for the selected week.' }); }
  audit('role_update.update', 'RoleUpdate', before.role_update_id, before, body, request.actor.person_id);
  return projectRoleUpdate(before.role_update_id, request.projectId);
});

app.delete('/api/role-updates/:updateId', async (request, reply) => {
  const before = projectRoleUpdate(request.params.updateId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Role update not found.' });
  db.prepare('UPDATE role_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE role_update_id = ?').run(before.role_update_id);
  audit('role_update.delete', 'RoleUpdate', before.role_update_id, before, null, request.actor.person_id);
  return reply.code(204).send();
});

app.get('/api/master-control', async (request) => {
  const weekStart = requestedWeekStart(request);
  const projects = db.prepare(`SELECT p.*, owner.display_name AS main_pm_name FROM projects p
    JOIN people owner ON owner.person_id = p.main_pm_person_id JOIN project_members pm ON pm.project_id = p.project_id
    WHERE pm.person_id = ? AND pm.deleted_at IS NULL AND p.deleted_at IS NULL
      AND lower(COALESCE(p.project_status, '')) NOT IN ('cancel', 'cancelled')
      AND (pm.active_from IS NULL OR pm.active_from <= date('now')) AND (pm.active_to IS NULL OR pm.active_to >= date('now'))
    ORDER BY p.project_code`).all(request.actor.person_id);
  const metrics = projects.map((project) => {
    const projectTasks = taskRows(project.project_id);
    const plans = db.prepare(`SELECT status FROM weekly_plans WHERE project_id = ? AND week_start_date = ? AND deleted_at IS NULL`).all(project.project_id, weekStart);
    const roleCount = db.prepare(`SELECT COUNT(*) AS count FROM role_updates WHERE project_id = ? AND week_start_date = ? AND deleted_at IS NULL`).get(project.project_id, weekStart).count;
    const openRaid = db.prepare(`SELECT COUNT(*) AS count FROM raid_items WHERE project_id = ? AND status <> 'Closed' AND deleted_at IS NULL`).get(project.project_id).count;
    const blocked = projectTasks.filter((task) => task.status === 'Blocked' || task.rag_status === 'Red').length;
    const overdue = projectTasks.filter((task) => task.status !== 'Done' && task.planned_due_date && task.planned_due_date < new Date().toISOString().slice(0, 10)).length;
    return { ...project, taskCount: projectTasks.length, completed: projectTasks.filter((task) => task.status === 'Done').length,
      progress: projectTasks.length ? Math.round(projectTasks.reduce((sum, task) => sum + task.progress, 0) / projectTasks.length) : 0,
      calculatedRag: projectTasks.some((task) => task.rag_status === 'Red') ? 'Red' : projectTasks.some((task) => task.rag_status === 'Amber') ? 'Amber' : 'Green',
      planCount: plans.length, planDone: plans.filter((plan) => plan.status === 'Done').length, roleUpdateCount: roleCount, openRaid, blocked, overdue };
  });
  const accessibleIds = new Set(projects.map((project) => project.project_id));
  const plans = db.prepare(`SELECT wp.*, pr.project_code, pr.project_name, pe.display_name AS owner_name, t.task_code, t.task_name
    FROM weekly_plans wp JOIN projects pr ON pr.project_id = wp.project_id JOIN people pe ON pe.person_id = wp.owner_person_id
    LEFT JOIN tasks t ON t.task_id = wp.task_id WHERE wp.week_start_date = ? AND wp.deleted_at IS NULL ORDER BY pr.project_code, wp.created_at`).all(weekStart).filter((item) => accessibleIds.has(item.project_id));
  const roleUpdates = db.prepare(`SELECT ru.*, pr.project_code, pe.display_name FROM role_updates ru JOIN projects pr ON pr.project_id = ru.project_id
    JOIN people pe ON pe.person_id = ru.person_id WHERE ru.week_start_date = ? AND ru.deleted_at IS NULL ORDER BY pr.project_code, pe.display_name`).all(weekStart).filter((item) => accessibleIds.has(item.project_id));
  const totals = metrics.reduce((sum, item) => ({ taskCount: sum.taskCount + item.taskCount, completed: sum.completed + item.completed, blocked: sum.blocked + item.blocked,
    overdue: sum.overdue + item.overdue, openRaid: sum.openRaid + item.openRaid }), { taskCount: 0, completed: 0, blocked: 0, overdue: 0, openRaid: 0 });
  return { weekStart, projects: metrics, plans, roleUpdates, summary: { projectCount: metrics.length, ...totals,
    progress: totals.taskCount ? Math.round(metrics.reduce((sum, item) => sum + item.progress * item.taskCount, 0) / totals.taskCount) : 0,
    planCount: plans.length, planDone: plans.filter((item) => item.status === 'Done').length, roleUpdateCount: roleUpdates.length } };
});

app.get('/api/weekly-updates', async (request) => db.prepare(`SELECT wu.*, t.task_name, p.display_name AS submitted_by_name
  FROM weekly_updates wu JOIN tasks t ON t.task_id = wu.task_id JOIN people p ON p.person_id = wu.submitted_by_person_id
  WHERE t.project_id = ? AND wu.deleted_at IS NULL ORDER BY wu.created_at DESC`).all(request.projectId));

app.post('/api/weekly-updates', async (request, reply) => {
  const body = request.body || {};
  const summary = String(body.summary || '').trim();
  if (!body.taskId || !summary || !body.status || body.progress === undefined || !body.ragStatus || !body.weekStartDate) return reply.code(422).send({ message: 'Task, week, status, RAG, progress and summary are required.' });
  if (summary.length > 2000) return reply.code(422).send({ message: 'Summary must be 2,000 characters or fewer.' });
  if (!/^\d{4}-\d{2}-\d{2}$/.test(body.weekStartDate)) return reply.code(422).send({ message: 'Week start date is invalid.' });
  if (!taskStatuses.has(body.status)) return reply.code(422).send({ message: 'Task status is invalid.' });
  if (!ragStatuses.has(body.ragStatus)) return reply.code(422).send({ message: 'RAG status is invalid.' });
  const task = projectTask(body.taskId, request.projectId);
  if (!task) return reply.code(422).send({ message: 'Task not found in the selected project.' });
  let updateProgress = Number(body.progress);
  if (!Number.isFinite(updateProgress) || updateProgress < 0 || updateProgress > 100) return reply.code(422).send({ message: 'Progress must be between 0 and 100.' });
  let updateStatus = body.status;
  if (updateStatus === 'Done') {
    updateProgress = 100;
  } else if (updateProgress === 100) {
    updateStatus = 'Done';
  }
  const weekStartDate = body.weekStartDate;
  const id = randomUUID();
  // Check if an update already exists for this task+week+person — if so, update it instead of inserting a duplicate
  const existing = db.prepare('SELECT weekly_update_id FROM weekly_updates WHERE task_id = ? AND week_start_date = ? AND submitted_by_person_id = ? AND deleted_at IS NULL').get(body.taskId, weekStartDate, request.actor.person_id);
  db.transaction(() => {
    if (existing) {
      db.prepare(`UPDATE weekly_updates SET progress = ?, status = ?, rag_status = ?, summary = ?, blocker = ?, next_step = ?, updated_at = CURRENT_TIMESTAMP WHERE weekly_update_id = ?`)
        .run(updateProgress, updateStatus, body.ragStatus, summary, body.blocker || null, body.nextStep || null, existing.weekly_update_id);
      audit('weekly_update.update', 'WeeklyUpdate', existing.weekly_update_id, null, { ...body, submittedBy: request.actor.person_id }, request.actor.person_id);
    } else {
      db.prepare(`INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, submitted_by_person_id, progress, status, rag_status, summary, blocker, next_step, review_status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Submitted')`)
        .run(id, body.taskId, weekStartDate, request.actor.person_id, updateProgress, updateStatus, body.ragStatus, summary, body.blocker || null, body.nextStep || null);
      audit('weekly_update.create', 'WeeklyUpdate', id, null, { ...body, submittedBy: request.actor.person_id }, request.actor.person_id);
    }
    db.prepare('UPDATE tasks SET progress = ?, status = ?, rag_status = ?, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?').run(updateProgress, updateStatus, body.ragStatus, body.taskId);
    if (task.parent_task_id) {
      rollupTaskProgress(task.parent_task_id);
    }
  })();
  return reply.code(201).send({ weeklyUpdateId: existing?.weekly_update_id || id });
});

function projectWeeklyUpdate(updateId, scopedProjectId) {
  return db.prepare(`SELECT wu.* FROM weekly_updates wu JOIN tasks t ON t.task_id = wu.task_id
    WHERE wu.weekly_update_id = ? AND t.project_id = ? AND wu.deleted_at IS NULL`).get(updateId, scopedProjectId);
}

app.patch('/api/weekly-updates/:updateId', async (request, reply) => {
  const before = projectWeeklyUpdate(request.params.updateId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Weekly update not found.' });
  const body = request.body || {};
  const fields = { weekStartDate: 'week_start_date', status: 'status', ragStatus: 'rag_status', progress: 'progress', summary: 'summary', blocker: 'blocker', nextStep: 'next_step' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input]])) };
  after.summary = String(after.summary || '').trim();
  if (!after.summary || !after.status || !after.rag_status || !Number.isFinite(Number(after.progress)) || Number(after.progress) < 0 || Number(after.progress) > 100) {
    return reply.code(422).send({ message: 'Status, RAG, progress and summary are required.' });
  }
  if (after.summary.length > 2000) return reply.code(422).send({ message: 'Summary must be 2,000 characters or fewer.' });
  if (!/^\d{4}-\d{2}-\d{2}$/.test(after.week_start_date)) return reply.code(422).send({ message: 'Week start date is invalid.' });
  if (!taskStatuses.has(after.status)) return reply.code(422).send({ message: 'Task status is invalid.' });
  if (!ragStatuses.has(after.rag_status)) return reply.code(422).send({ message: 'RAG status is invalid.' });
  if (after.status === 'Done') {
    after.progress = 100;
  } else if (Number(after.progress) === 100) {
    after.status = 'Done';
  }
  const persistedChanges = [...changes];
  if (after.status !== before.status && !persistedChanges.some(([, field]) => field === 'status')) persistedChanges.push(['status', 'status']);
  if (Number(after.progress) !== Number(before.progress) && !persistedChanges.some(([, field]) => field === 'progress')) persistedChanges.push(['progress', 'progress']);
  const task = projectTask(before.task_id, request.projectId);
  db.transaction(() => {
    db.prepare(`UPDATE weekly_updates SET ${persistedChanges.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE weekly_update_id = ?`)
      .run(...persistedChanges.map(([, field]) => field === 'progress' ? Number(after[field]) : after[field]), before.weekly_update_id);
    db.prepare('UPDATE tasks SET progress = ?, status = ?, rag_status = ?, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?').run(Number(after.progress), after.status, after.rag_status, before.task_id);
    if (task?.parent_task_id) {
      rollupTaskProgress(task.parent_task_id);
    }
    audit('weekly_update.update', 'WeeklyUpdate', before.weekly_update_id, before, after, request.actor.person_id);
  })();
  return projectWeeklyUpdate(before.weekly_update_id, request.projectId);
});

app.delete('/api/weekly-updates/:updateId', async (request, reply) => {
  const before = projectWeeklyUpdate(request.params.updateId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'Weekly update not found.' });
  db.transaction(() => {
    db.prepare('UPDATE weekly_updates SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE weekly_update_id = ?').run(before.weekly_update_id);
    audit('weekly_update.delete', 'WeeklyUpdate', before.weekly_update_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/raid', async (request) => db.prepare(`SELECT r.*, p.display_name AS owner_name FROM raid_items r JOIN people p ON p.person_id = r.owner_person_id
  WHERE r.project_id = ? AND r.deleted_at IS NULL ORDER BY r.status, r.due_date`).all(request.projectId));

app.post('/api/raid', async (request, reply) => {
  const body = request.body || {};
  if (!body.title || !body.raidType) return reply.code(422).send({ message: 'RAID type and title are required.' });
  const owner = body.ownerPersonId || request.actor.person_id;
  let member = activeProjectMember(owner, request.projectId);
  if (!member) {
    member = ensureActiveProjectMember(owner, request.projectId);
  }
  if (!member) return reply.code(422).send({ message: 'Owner must be an active project member.' });
  const id = randomUUID();
  const code = `RAID-${body.raidType.slice(0, 1).toUpperCase()}-${String(db.prepare('SELECT COUNT(*) AS count FROM raid_items WHERE project_id = ?').get(request.projectId).count + 1).padStart(3, '0')}`;
  const probability = body.raidType === 'Risk' ? Number(body.probability || 3) : null;
  const impact = body.raidType === 'Risk' ? Number(body.impact || 3) : null;
  db.transaction(() => {
    db.prepare(`INSERT INTO raid_items (raid_item_id, project_id, raid_code, raid_type, title, description, owner_person_id, probability, impact, mitigation_plan, escalation_trigger_score, due_date)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`)
      .run(id, request.projectId, code, body.raidType, body.title, body.description || null, owner, probability, impact, body.mitigationPlan || null, 12, body.dueDate || null);
    audit('raid.create', 'RAID', id, null, { ...body, raidCode: code, ownerPersonId: owner }, request.actor.person_id);
  })();
  return reply.code(201).send({ raidItemId: id, raidCode: code });
});

function projectRaid(raidItemId, scopedProjectId) {
  return db.prepare('SELECT * FROM raid_items WHERE raid_item_id = ? AND project_id = ? AND deleted_at IS NULL').get(raidItemId, scopedProjectId);
}

app.patch('/api/raid/:raidItemId', async (request, reply) => {
  const before = projectRaid(request.params.raidItemId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'RAID item not found.' });
  const body = request.body || {};
  const fields = { raidType: 'raid_type', title: 'title', ownerPersonId: 'owner_person_id', probability: 'probability', impact: 'impact', mitigationPlan: 'mitigation_plan', dueDate: 'due_date', status: 'status' };
  const changes = Object.entries(fields).filter(([input]) => body[input] !== undefined);
  if (!changes.length) return reply.code(422).send({ message: 'No supported values supplied.' });
  const after = { ...before, ...Object.fromEntries(changes.map(([input, field]) => [field, body[input]])) };
  if (!['Risk', 'Assumption', 'Issue', 'Dependency'].includes(after.raid_type) || !after.title) return reply.code(422).send({ message: 'RAID type and title are required.' });
  if (after.owner_person_id) {
    let member = activeProjectMember(after.owner_person_id, request.projectId);
    if (!member) {
      member = ensureActiveProjectMember(after.owner_person_id, request.projectId);
    }
    if (!member) return reply.code(422).send({ message: 'Owner must be an active project member.' });
  }
  if (!['Open', 'Monitoring', 'Mitigated', 'Closed'].includes(after.status)) return reply.code(422).send({ message: 'RAID status is invalid.' });
  if (after.raid_type === 'Risk' && (![after.probability, after.impact].every((value) => Number.isInteger(Number(value)) && Number(value) >= 1 && Number(value) <= 5))) {
    return reply.code(422).send({ message: 'Risk probability and impact must be between 1 and 5.' });
  }
  db.transaction(() => {
    db.prepare(`UPDATE raid_items SET ${changes.map(([, field]) => `${field} = ?`).join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE raid_item_id = ?`)
      .run(...changes.map(([input]) => body[input]), before.raid_item_id);
    audit('raid.update', 'RAID', before.raid_item_id, before, after, request.actor.person_id);
  })();
  return projectRaid(before.raid_item_id, request.projectId);
});

app.delete('/api/raid/:raidItemId', async (request, reply) => {
  const before = projectRaid(request.params.raidItemId, request.projectId);
  if (!before) return reply.code(404).send({ message: 'RAID item not found.' });
  db.transaction(() => {
    db.prepare('UPDATE raid_items SET deleted_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE raid_item_id = ?').run(before.raid_item_id);
    audit('raid.delete', 'RAID', before.raid_item_id, before, null, request.actor.person_id);
  })();
  return reply.code(204).send();
});

app.get('/api/audit', async () => db.prepare(`SELECT a.*, p.display_name AS actor_name FROM audit_logs a LEFT JOIN people p ON p.person_id = a.actor_person_id
  ORDER BY a.occurred_at DESC LIMIT 30`).all());

app.register(fastifyStatic, {
  root: path.join(root, 'apps', 'web'),
  prefix: '/',
  setHeaders: (res) => {
    if (typeof res?.setHeader === 'function') {
      res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    } else if (typeof res?.header === 'function') {
      res.header('Cache-Control', 'no-cache, no-store, must-revalidate');
    } else if (typeof res?.raw?.setHeader === 'function') {
      res.raw.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    }
  }
});
app.setErrorHandler((error, request, reply) => { request.log.error(error); reply.code(500).send({ message: 'Something went wrong while saving the demo data.' }); });

app.addHook('onResponse', async (request, reply) => {
  if (pgPool && request.method !== 'GET' && reply.statusCode < 400) {
    queuePersistToSupabase();
  }
});

app.addHook('onClose', async () => {
  if (pgPool) await persistToSupabase().catch(() => {});
  db.close();
  if (pgPool) await pgPool.end();
});

const gracefulShutdown = async () => {
  if (pgPool) {
    await persistToSupabase().catch(() => {});
    await pgPool.end().catch(() => {});
  }
};
process.on('SIGTERM', async () => {
  await gracefulShutdown();
  process.exit(0);
});
process.on('SIGINT', async () => {
  await gracefulShutdown();
  process.exit(0);
});

// HOST defaults to 127.0.0.1 (local-only) so the server is safe out of the box.
// Set HOST=0.0.0.0 in the cloud environment (e.g. Render, Koyeb) to accept
// external connections. Always place the server behind a TLS-terminating proxy.
const listenPromise = app.listen({ port: Number(process.env.PORT || 3000), host: process.env.HOST || '127.0.0.1' })
  .then((address) => app.log.info(`Lean Project Control running at ${address}`))
  .catch((error) => {
    app.log.error(error);
    db.close();
    if (pgPool) pgPool.end().catch(() => {});
    process.exitCode = 1;
    throw error;
  });

export { app, listenPromise, pgPool };
