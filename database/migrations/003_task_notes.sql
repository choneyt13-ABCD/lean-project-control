CREATE TABLE task_notes (
    task_note_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    note_type varchar(20) NOT NULL CHECK (note_type IN ('Note', 'Update')),
    note_text text NOT NULL DEFAULT '',
    created_by_person_id uuid NOT NULL REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE task_note_files (
    task_note_file_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_note_id uuid NOT NULL REFERENCES task_notes(task_note_id),
    original_file_name varchar(500) NOT NULL,
    file_type varchar(200),
    file_size_bytes integer NOT NULL CHECK (file_size_bytes > 0 AND file_size_bytes <= 5242880),
    storage_ref text NOT NULL,
    uploaded_by_person_id uuid NOT NULL REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE INDEX idx_task_notes_task ON task_notes(task_id, created_at DESC);
CREATE INDEX idx_task_note_files_note ON task_note_files(task_note_id, created_at);
