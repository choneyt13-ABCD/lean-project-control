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
