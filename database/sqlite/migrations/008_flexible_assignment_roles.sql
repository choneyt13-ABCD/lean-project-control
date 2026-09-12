PRAGMA foreign_keys = ON;

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
