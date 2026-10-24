PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS area_definitions (
  area_id TEXT PRIMARY KEY,
  area_code TEXT NOT NULL UNIQUE,
  area_name TEXT NOT NULL,
  family TEXT NOT NULL CHECK (family IN ('SAP', 'Nonsap')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS project_areas (
  project_area_id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL REFERENCES projects(project_id),
  area_id TEXT NOT NULL REFERENCES area_definitions(area_id),
  created_by_person_id TEXT REFERENCES people(person_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (project_id, area_id)
);

CREATE TABLE IF NOT EXISTS person_area_roles (
  person_area_role_id TEXT PRIMARY KEY,
  person_id TEXT NOT NULL REFERENCES people(person_id),
  area_id TEXT NOT NULL REFERENCES area_definitions(area_id),
  area_role TEXT NOT NULL CHECK (area_role IN ('PM', 'PMO', 'Member')),
  created_by_person_id TEXT REFERENCES people(person_id),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (person_id, area_id, area_role)
);

CREATE INDEX IF NOT EXISTS idx_project_areas_area ON project_areas(area_id, project_id);
CREATE INDEX IF NOT EXISTS idx_person_area_roles_person ON person_area_roles(person_id, area_id);
