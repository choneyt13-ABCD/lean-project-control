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
