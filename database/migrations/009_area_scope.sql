CREATE TABLE IF NOT EXISTS area_definitions (
    area_id uuid PRIMARY KEY,
    area_code varchar(80) NOT NULL UNIQUE,
    area_name varchar(160) NOT NULL,
    family varchar(20) NOT NULL CHECK (family IN ('SAP', 'Nonsap')),
    sort_order integer NOT NULL DEFAULT 0,
    active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS project_areas (
    project_area_id uuid PRIMARY KEY,
    project_id uuid NOT NULL REFERENCES projects(project_id),
    area_id uuid NOT NULL REFERENCES area_definitions(area_id),
    created_by_person_id uuid REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, area_id)
);

CREATE TABLE IF NOT EXISTS person_area_roles (
    person_area_role_id uuid PRIMARY KEY,
    person_id uuid NOT NULL REFERENCES people(person_id),
    area_id uuid NOT NULL REFERENCES area_definitions(area_id),
    area_role varchar(20) NOT NULL CHECK (area_role IN ('PM', 'PMO', 'Member')),
    created_by_person_id uuid REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (person_id, area_id, area_role)
);

CREATE INDEX IF NOT EXISTS idx_project_areas_area ON project_areas(area_id, project_id);
CREATE INDEX IF NOT EXISTS idx_person_area_roles_person ON person_area_roles(person_id, area_id);
