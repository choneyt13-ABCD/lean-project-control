CREATE TABLE project_phases (
    phase_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    phase_code varchar(100) NOT NULL,
    phase_name varchar(200) NOT NULL,
    sort_order numeric(10,2) NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    planned_start_date date,
    planned_due_date date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, phase_code),
    CHECK (planned_due_date IS NULL OR planned_start_date IS NULL OR planned_due_date >= planned_start_date)
);

CREATE INDEX idx_project_phases_project ON project_phases(project_id, sort_order);
ALTER TABLE wbs_items ADD COLUMN phase_id uuid REFERENCES project_phases(phase_id);
CREATE TRIGGER trg_project_phases_updated_at BEFORE UPDATE ON project_phases FOR EACH ROW EXECUTE FUNCTION set_updated_at();
