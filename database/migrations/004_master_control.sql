CREATE TABLE IF NOT EXISTS weekly_plans (
  weekly_plan_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(project_id),
  task_id UUID REFERENCES tasks(task_id),
  week_start_date DATE NOT NULL,
  plan_title VARCHAR(300) NOT NULL,
  owner_person_id UUID NOT NULL REFERENCES people(person_id),
  owner_role VARCHAR(100),
  target_outcome TEXT,
  planned_due_date DATE,
  priority VARCHAR(20) NOT NULL DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
  status VARCHAR(20) NOT NULL DEFAULT 'Planned' CHECK (status IN ('Planned', 'InProgress', 'Done', 'Deferred')),
  created_by_person_id UUID NOT NULL REFERENCES people(person_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_weekly_plans_project_week ON weekly_plans(project_id, week_start_date, status);

CREATE TABLE IF NOT EXISTS role_updates (
  role_update_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(project_id),
  week_start_date DATE NOT NULL,
  person_id UUID NOT NULL REFERENCES people(person_id),
  role_name VARCHAR(100) NOT NULL,
  accomplished TEXT,
  next_actions TEXT,
  blocker TEXT,
  support_needed TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMPTZ,
  UNIQUE (project_id, week_start_date, person_id, role_name)
);
CREATE INDEX IF NOT EXISTS idx_role_updates_project_week ON role_updates(project_id, week_start_date);
