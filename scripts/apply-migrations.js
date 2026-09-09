import Database from 'better-sqlite3';
import path from 'node:path';
import fs from 'node:fs';

const dbPath = path.resolve('data/lean-project-control.db');
if (fs.existsSync(dbPath)) {
  const db = new Database(dbPath);
  db.pragma('foreign_keys = ON');
  const cols = db.prepare('PRAGMA table_info(projects)').all().map((c) => c.name);
  if (!cols.includes('project_type')) {
    db.exec("ALTER TABLE projects ADD COLUMN project_type TEXT DEFAULT 'New'");
    console.log('Added project_type column');
  }
  if (!cols.includes('project_size')) {
    db.exec("ALTER TABLE projects ADD COLUMN project_size TEXT DEFAULT 'Medium'");
    console.log('Added project_size column');
  }
  db.exec(`
    INSERT OR IGNORE INTO task_statuses (task_status_code, display_name, sort_order, is_terminal)
    VALUES ('OnHold', 'On Hold', 3, 0);
    UPDATE task_statuses SET sort_order = CASE task_status_code
      WHEN 'NotStarted' THEN 1 WHEN 'InProgress' THEN 2 WHEN 'OnHold' THEN 3
      WHEN 'Blocked' THEN 4 WHEN 'Done' THEN 5 WHEN 'Cancelled' THEN 6
      ELSE sort_order END;
  `);
  console.log('Database updated successfully. Current projects:');
  console.log(db.prepare('SELECT project_id, project_code, project_name, project_type, project_size FROM projects').all());
} else {
  console.log('Database not found at', dbPath);
}
