import Database from 'better-sqlite3';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dbPath = path.join(root, 'data/lean-project-control.db');

if (!fs.existsSync(dbPath)) {
  console.error('Database not found at', dbPath);
  process.exit(1);
}

const db = new Database(dbPath);

function sqlVal(val, isBoolean = false) {
  if (val === null || val === undefined) return 'NULL';
  if (isBoolean) return val ? 'true' : 'false';
  if (typeof val === 'number') return String(val);
  const str = String(val).replace(/'/g, "''");
  return `'${str}'`;
}

const out = [];
out.push('-- =============================================================================');
out.push('-- Lean Project Control: Full Data Sync (e-Doc, CSI, Loca, RRMS-2026, DTP)');
out.push('-- Safe to execute in both PostgreSQL (Supabase) and SQLite');
out.push('-- =============================================================================\n');

// 1. People
const people = db.prepare('SELECT * FROM people WHERE deleted_at IS NULL').all();
out.push('-- 1. People');
for (const p of people) {
  out.push(`INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES (${sqlVal(p.person_id)}, ${sqlVal(p.employee_code)}, ${sqlVal(p.display_name)}, ${sqlVal(p.email)}, ${sqlVal(p.department)}, ${sqlVal(p.position_title)}, ${sqlVal(p.person_status || 'Active')})
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;`);
}

// 2. Projects
const projects = db.prepare('SELECT * FROM projects WHERE deleted_at IS NULL').all();
out.push('\n-- 2. Projects');
for (const prj of projects) {
  out.push(`INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
VALUES (${sqlVal(prj.project_id)}, ${sqlVal(prj.project_code)}, ${sqlVal(prj.project_name)}, ${sqlVal(prj.portfolio_name)}, ${sqlVal(prj.project_type || 'New')}, ${sqlVal(prj.project_size || 'Medium')}, ${sqlVal(prj.main_pm_person_id)}, ${sqlVal(prj.project_status || 'Active')}, ${sqlVal(prj.rag_status || 'Green')}, ${sqlVal(prj.start_date)}, ${sqlVal(prj.target_end_date)})
ON CONFLICT (project_id) DO UPDATE SET
  project_code = EXCLUDED.project_code,
  project_name = EXCLUDED.project_name,
  portfolio_name = EXCLUDED.portfolio_name,
  project_type = EXCLUDED.project_type,
  project_size = EXCLUDED.project_size,
  main_pm_person_id = EXCLUDED.main_pm_person_id,
  project_status = EXCLUDED.project_status,
  rag_status = EXCLUDED.rag_status,
  start_date = EXCLUDED.start_date,
  target_end_date = EXCLUDED.target_end_date;`);
}

// Ensure logged-in actor (PM: 20000000-0000-0000-0000-000000000001 & 685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af) are members of all projects
for (const prj of projects) {
  out.push(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-${prj.project_id.slice(9)}', ${sqlVal(prj.project_id)}, '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;`);
  out.push(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-${prj.project_id.slice(9)}', ${sqlVal(prj.project_id)}, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;`);
}

// 3. Project Members
const members = db.prepare('SELECT * FROM project_members WHERE deleted_at IS NULL').all();
out.push('\n-- 3. Project Members');
for (const m of members) {
  out.push(`INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES (${sqlVal(m.project_member_id)}, ${sqlVal(m.project_id)}, ${sqlVal(m.person_id)}, ${sqlVal(m.project_role)}, ${sqlVal(m.is_main_pm, true)}, ${sqlVal(m.active_from)}, ${sqlVal(m.active_to)})
ON CONFLICT (project_member_id) DO NOTHING;`);
}

// 4. Project Phases
const phases = db.prepare('SELECT * FROM project_phases WHERE deleted_at IS NULL').all();
out.push('\n-- 4. Project Phases');
for (const ph of phases) {
  out.push(`INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES (${sqlVal(ph.phase_id)}, ${sqlVal(ph.project_id)}, ${sqlVal(ph.phase_code)}, ${sqlVal(ph.phase_name)}, ${ph.sort_order || 0}, ${sqlVal(ph.planned_start_date)}, ${sqlVal(ph.planned_due_date)})
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;`);
}

// 5. WBS Items
const wbs = db.prepare('SELECT * FROM wbs_items WHERE deleted_at IS NULL').all();
out.push('\n-- 5. WBS Items');
for (const w of wbs) {
  out.push(`INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES (${sqlVal(w.wbs_item_id)}, ${sqlVal(w.project_id)}, ${sqlVal(w.phase_id)}, ${sqlVal(w.wbs_code)}, ${sqlVal(w.wbs_name)}, ${w.sort_order || 0})
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;`);
}

// 6. Tasks (All Work Items)
const tasks = db.prepare('SELECT * FROM tasks WHERE deleted_at IS NULL').all();
out.push('\n-- 6. Tasks (All Work Items)');
for (const t of tasks) {
  out.push(`INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES (${sqlVal(t.task_id)}, ${sqlVal(t.project_id)}, ${sqlVal(t.wbs_item_id)}, ${sqlVal(t.parent_task_id)}, ${sqlVal(t.task_code)}, ${sqlVal(t.task_type)}, ${sqlVal(t.task_name)}, ${sqlVal(t.description)}, ${sqlVal(t.owner_person_id)}, ${sqlVal(t.planned_start_date)}, ${sqlVal(t.planned_due_date)}, ${sqlVal(t.actual_start_date)}, ${sqlVal(t.actual_end_date)}, ${sqlVal(t.status || 'NotStarted')}, ${sqlVal(t.rag_status || 'Green')}, ${t.weight || 1}, ${t.progress || 0}, ${sqlVal(t.evidence_required, true)}, ${sqlVal(t.workstream)})
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;`);
}

// 7. Task Assignments
const assignments = db.prepare(`
  SELECT ta.* FROM task_assignments ta
  JOIN tasks t ON t.task_id = ta.task_id
  WHERE ta.deleted_at IS NULL
`).all();
out.push('\n-- 7. Task Assignments');
for (const a of assignments) {
  out.push(`INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES (${sqlVal(a.task_assignment_id)}, ${sqlVal(a.task_id)}, ${sqlVal(a.person_id)}, ${sqlVal(a.assignment_role)}, ${sqlVal(a.raci_role || 'Responsible')}, ${sqlVal(a.is_primary, true)})
ON CONFLICT (task_assignment_id) DO NOTHING;`);
}

// 8. Weekly Updates
const weeklyUpdates = db.prepare('SELECT * FROM weekly_updates WHERE deleted_at IS NULL').all();
out.push('\n-- 8. Weekly Updates');
for (const wu of weeklyUpdates) {
  out.push(`INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES (${sqlVal(wu.weekly_update_id)}, ${sqlVal(wu.task_id)}, ${sqlVal(wu.week_start_date)}, ${wu.progress || 0}, ${sqlVal(wu.status || 'NotStarted')}, ${sqlVal(wu.rag_status || 'Green')}, ${sqlVal(wu.submitted_by_person_id)})
ON CONFLICT (weekly_update_id) DO NOTHING;`);
}

// 9. Task Notes
const notes = db.prepare('SELECT * FROM task_notes WHERE deleted_at IS NULL').all();
out.push('\n-- 9. Task Notes');
for (const n of notes) {
  out.push(`INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id)
VALUES (${sqlVal(n.task_note_id)}, ${sqlVal(n.task_id)}, ${sqlVal(n.note_type || 'Note')}, ${sqlVal(n.note_text)}, ${sqlVal(n.created_by_person_id)})
ON CONFLICT (task_note_id) DO NOTHING;`);
}

// 10. RAID Items
const raid = db.prepare('SELECT * FROM raid_items WHERE deleted_at IS NULL').all();
out.push('\n-- 10. RAID Items');
for (const r of raid) {
  out.push(`INSERT INTO raid_items (raid_item_id, project_id, item_code, raid_type, title, description, impact, probability, mitigation_plan, owner_person_id, due_date, status)
VALUES (${sqlVal(r.raid_item_id)}, ${sqlVal(r.project_id)}, ${sqlVal(r.item_code)}, ${sqlVal(r.raid_type)}, ${sqlVal(r.title)}, ${sqlVal(r.description)}, ${r.impact || 'NULL'}, ${r.probability || 'NULL'}, ${sqlVal(r.mitigation_plan)}, ${sqlVal(r.owner_person_id)}, ${sqlVal(r.due_date)}, ${sqlVal(r.status || 'Open')})
ON CONFLICT (raid_item_id) DO NOTHING;`);
}

const outputPath = path.join(root, 'database/sync_all_projects_to_supabase.sql');
fs.writeFileSync(outputPath, out.join('\n'), 'utf8');
console.log('Successfully generated full data sync with ALL work items:', outputPath);
