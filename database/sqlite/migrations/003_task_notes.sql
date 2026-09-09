CREATE TABLE task_notes (
    task_note_id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL REFERENCES tasks(task_id),
    note_type TEXT NOT NULL CHECK (note_type IN ('Note', 'Update')),
    note_text TEXT NOT NULL DEFAULT '',
    created_by_person_id TEXT NOT NULL REFERENCES people(person_id),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TEXT
);

CREATE TABLE task_note_files (
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

CREATE INDEX idx_task_notes_task ON task_notes(task_id, created_at DESC);
CREATE INDEX idx_task_note_files_note ON task_note_files(task_note_id, created_at);
