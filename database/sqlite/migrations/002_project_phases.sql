CREATE TABLE project_phases (
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

CREATE INDEX idx_project_phases_project ON project_phases(project_id, sort_order);
ALTER TABLE wbs_items ADD COLUMN phase_id TEXT;
