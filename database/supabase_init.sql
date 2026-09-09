-- =============================================================================
-- Lean Project Control: Complete Supabase / PostgreSQL Initialization Script
-- Paste this entire file into Supabase Dashboard -> SQL Editor and click "Run"
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 1. Core People and Authentication Tables
CREATE TABLE IF NOT EXISTS people (
    person_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_code varchar(100) NOT NULL UNIQUE,
    display_name varchar(200) NOT NULL,
    email varchar(320) NOT NULL,
    department varchar(100),
    position_title varchar(100),
    person_status varchar(20) NOT NULL DEFAULT 'Active'
        CHECK (person_status IN ('Active', 'Inactive', 'External', 'Suspended')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_people_active_email ON people (lower(email)) WHERE deleted_at IS NULL;

CREATE TABLE IF NOT EXISTS user_accounts (
    user_account_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id uuid NOT NULL REFERENCES people(person_id),
    login_name varchar(200) NOT NULL,
    auth_provider varchar(30) NOT NULL DEFAULT 'LocalPlaceholder'
        CHECK (auth_provider IN ('LocalPlaceholder', 'AD', 'SSO')),
    provider_subject varchar(300),
    password_hash varchar(500),
    account_status varchar(20) NOT NULL DEFAULT 'Active'
        CHECK (account_status IN ('Active', 'Disabled', 'Locked')),
    last_login_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_user_accounts_active_login ON user_accounts (lower(login_name)) WHERE deleted_at IS NULL;

-- 2. RBAC Tables
CREATE TABLE IF NOT EXISTS roles (
    role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code varchar(80) NOT NULL UNIQUE,
    role_name varchar(150) NOT NULL,
    scope_type varchar(20) NOT NULL CHECK (scope_type IN ('Platform', 'Portfolio', 'Project', 'Workstream', 'Task')),
    is_system_role boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS permissions (
    permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_code varchar(120) NOT NULL UNIQUE,
    resource varchar(40) NOT NULL,
    action varchar(20) NOT NULL CHECK (action IN ('View', 'Create', 'Edit', 'Delete', 'Approve', 'Import')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id uuid NOT NULL REFERENCES roles(role_id),
    permission_id uuid NOT NULL REFERENCES permissions(permission_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_account_id uuid NOT NULL REFERENCES user_accounts(user_account_id),
    role_id uuid NOT NULL REFERENCES roles(role_id),
    scope_id uuid,
    active_from date,
    active_to date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (user_account_id, role_id, scope_id)
);

-- 3. Projects & Hierarchy
CREATE TABLE IF NOT EXISTS projects (
    project_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_code varchar(50) NOT NULL UNIQUE,
    project_name varchar(200) NOT NULL,
    portfolio_name varchar(100),
    project_type varchar(50) DEFAULT 'New',
    project_size varchar(50) DEFAULT 'Medium',
    main_pm_person_id uuid NOT NULL REFERENCES people(person_id),
    project_status varchar(20) NOT NULL DEFAULT 'Active'
        CHECK (project_status IN ('Active', 'OnHold', 'Completed', 'Archived', 'Cancelled', 'Draft')),
    rag_status varchar(10) NOT NULL DEFAULT 'Green'
        CHECK (rag_status IN ('Green', 'Amber', 'Red')),
    start_date date,
    target_end_date date,
    actual_end_date date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS project_members (
    project_member_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    person_id uuid NOT NULL REFERENCES people(person_id),
    project_role varchar(100) NOT NULL,
    is_main_pm boolean NOT NULL DEFAULT false,
    active_from date,
    active_to date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, person_id, project_role)
);

CREATE TABLE IF NOT EXISTS project_phases (
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
    UNIQUE (project_id, phase_code)
);

CREATE TABLE IF NOT EXISTS wbs_items (
    wbs_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    phase_id uuid REFERENCES project_phases(phase_id),
    wbs_code varchar(50) NOT NULL,
    wbs_name varchar(200) NOT NULL,
    sort_order numeric(10,2) NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, wbs_code)
);

CREATE TABLE IF NOT EXISTS task_statuses (
    task_status_code varchar(20) PRIMARY KEY,
    display_name varchar(50) NOT NULL,
    sort_order int NOT NULL,
    is_terminal boolean NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS tasks (
    task_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    wbs_item_id uuid NOT NULL REFERENCES wbs_items(wbs_item_id),
    parent_task_id uuid REFERENCES tasks(task_id),
    task_code varchar(80) NOT NULL,
    task_type varchar(20) NOT NULL CHECK (task_type IN ('MainTask', 'Task', 'Subtask')),
    task_name varchar(300) NOT NULL,
    description text,
    owner_person_id uuid NOT NULL REFERENCES people(person_id),
    planned_start_date date,
    planned_due_date date,
    actual_start_date date,
    actual_end_date date,
    status varchar(20) NOT NULL DEFAULT 'NotStarted' REFERENCES task_statuses(task_status_code),
    rag_status varchar(10) NOT NULL DEFAULT 'Green' CHECK (rag_status IN ('Green', 'Amber', 'Red')),
    weight numeric(5,2) NOT NULL DEFAULT 1 CHECK (weight > 0),
    progress numeric(5,2) NOT NULL DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
    evidence_required boolean NOT NULL DEFAULT false,
    workstream varchar(100),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, task_code)
);

CREATE TABLE IF NOT EXISTS task_assignments (
    task_assignment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    person_id uuid NOT NULL REFERENCES people(person_id),
    assignment_role varchar(100) NOT NULL,
    raci_role varchar(20) NOT NULL DEFAULT 'Responsible' CHECK (raci_role IN ('Responsible', 'Accountable', 'Consulted', 'Informed')),
    is_primary boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (task_id, person_id, assignment_role)
);

-- 4. Weekly Updates, Notes, Files & Plans
CREATE TABLE IF NOT EXISTS weekly_updates (
    weekly_update_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    week_start_date date NOT NULL,
    progress numeric(5,2) NOT NULL CHECK (progress >= 0 AND progress <= 100),
    status varchar(20) NOT NULL REFERENCES task_statuses(task_status_code),
    rag_status varchar(10) NOT NULL CHECK (rag_status IN ('Green', 'Amber', 'Red')),
    accomplished text,
    planned_next text,
    issues text,
    submitted_by_person_id uuid NOT NULL REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (task_id, week_start_date)
);

CREATE TABLE IF NOT EXISTS weekly_plans (
    weekly_plan_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    task_id uuid REFERENCES tasks(task_id),
    week_start_date date NOT NULL,
    plan_title varchar(300) NOT NULL,
    owner_person_id uuid NOT NULL REFERENCES people(person_id),
    owner_role varchar(100),
    target_outcome text,
    planned_due_date date,
    priority varchar(20) NOT NULL DEFAULT 'Medium' CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
    status varchar(20) NOT NULL DEFAULT 'Planned' CHECK (status IN ('Planned', 'InProgress', 'Done', 'Deferred')),
    created_by_person_id uuid NOT NULL REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS role_updates (
    role_update_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    week_start_date date NOT NULL,
    person_id uuid NOT NULL REFERENCES people(person_id),
    role_name varchar(100) NOT NULL,
    accomplished text,
    next_actions text,
    blocker text,
    support_needed text,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, week_start_date, person_id, role_name)
);

CREATE TABLE IF NOT EXISTS task_notes (
    task_note_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    note_type varchar(20) NOT NULL CHECK (note_type IN ('Note', 'Update')),
    note_text text NOT NULL DEFAULT '',
    created_by_person_id uuid NOT NULL REFERENCES people(person_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS task_note_files (
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

-- 5. RAID & Audit Logs
CREATE TABLE IF NOT EXISTS raid_items (
    raid_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    item_code varchar(50) NOT NULL,
    raid_type varchar(20) NOT NULL CHECK (raid_type IN ('Risk', 'Assumption', 'Issue', 'Dependency')),
    title varchar(200) NOT NULL,
    description text,
    impact integer CHECK (impact BETWEEN 1 AND 5),
    probability integer CHECK (probability BETWEEN 1 AND 5),
    mitigation_plan text,
    owner_person_id uuid REFERENCES people(person_id),
    due_date date,
    status varchar(20) NOT NULL DEFAULT 'Open' CHECK (status IN ('Open', 'Monitoring', 'Mitigated', 'Closed')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, item_code)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    audit_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_person_id uuid REFERENCES people(person_id),
    action varchar(100) NOT NULL,
    entity_type varchar(50) NOT NULL,
    entity_id varchar(100) NOT NULL,
    before_snapshot jsonb,
    after_snapshot jsonb,
    occurred_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS project_workstreams (
    workstream_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    workstream_code varchar(50) NOT NULL,
    workstream_name varchar(100) NOT NULL,
    description text,
    sort_order numeric(10,2) NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, workstream_code)
);

CREATE TABLE IF NOT EXISTS project_roles (
    role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    role_code varchar(80) NOT NULL,
    role_name varchar(150) NOT NULL,
    description text,
    sort_order numeric(10,2) NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, role_code)
);

CREATE TABLE IF NOT EXISTS project_type_definitions (
    type_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type_name varchar(100) NOT NULL UNIQUE,
    sort_order numeric(10,2) NOT NULL DEFAULT 0,
    is_default boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

-- Migration Tracking Table
CREATE TABLE IF NOT EXISTS schema_migrations (
    migration_id serial PRIMARY KEY,
    filename varchar(300) NOT NULL UNIQUE,
    applied_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Initial Master Reference Data Seeds
INSERT INTO task_statuses (task_status_code, display_name, sort_order, is_terminal) VALUES
('NotStarted', 'Not Started', 1, false),
('InProgress', 'In Progress', 2, false),
('OnHold', 'On Hold', 3, false),
('Blocked', 'Blocked', 4, false),
('Done', 'Done', 5, true),
('Cancelled', 'Cancelled', 6, true)
ON CONFLICT (task_status_code) DO NOTHING;

INSERT INTO roles (role_id, role_code, role_name, scope_type, is_system_role) VALUES
('10000000-0000-0000-0000-000000000001', 'PLATFORM_ADMIN', 'Platform Admin', 'Platform', true),
('10000000-0000-0000-0000-000000000002', 'PM_PMO', 'PM/PMO', 'Portfolio', true),
('10000000-0000-0000-0000-000000000003', 'PROJECT_ADMIN', 'Project Admin', 'Project', true),
('10000000-0000-0000-0000-000000000004', 'BA_LEAD', 'BA Lead', 'Workstream', true),
('10000000-0000-0000-0000-000000000005', 'DEV_LEAD', 'DEV Lead', 'Workstream', true),
('10000000-0000-0000-0000-000000000006', 'QA_LEAD', 'QA Lead', 'Workstream', true),
('10000000-0000-0000-0000-000000000007', 'TEAM_MEMBER', 'Team Member', 'Task', true),
('10000000-0000-0000-0000-000000000008', 'REVIEWER', 'Reviewer', 'Project', true)
ON CONFLICT (role_code) DO NOTHING;

INSERT INTO project_type_definitions (type_id, type_name, sort_order, is_default) VALUES
(gen_random_uuid(), 'New', 1, true),
(gen_random_uuid(), 'Change Major', 2, false),
(gen_random_uuid(), 'Change Minor', 3, false),
(gen_random_uuid(), 'Job', 4, false)
ON CONFLICT (type_name) DO NOTHING;

-- Demo People & Account Seeds
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status) VALUES
('20000000-0000-0000-0000-000000000001', 'EMP-DEMO-001', 'RRMS Demo PM', 'rrms.demo.pm@example.invalid', 'IT Delivery', 'Senior Project Manager', 'Active'),
('20000000-0000-0000-0000-000000000002', 'EMP-DEMO-002', 'RRMS Demo BA', 'rrms.demo.ba@example.invalid', 'IT Analysis', 'Lead Business Analyst', 'Active')
ON CONFLICT (employee_code) DO NOTHING;

INSERT INTO user_accounts (user_account_id, person_id, login_name, auth_provider, account_status) VALUES
('21000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'rrms.demo.pm', 'LocalPlaceholder', 'Active'),
('21000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'rrms.demo.ba', 'LocalPlaceholder', 'Active')
ON CONFLICT DO NOTHING;

INSERT INTO user_roles (user_role_id, user_account_id, role_id) VALUES
('22000000-0000-0000-0000-000000000001', '21000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000002'),
('22000000-0000-0000-0000-000000000002', '21000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000004')
ON CONFLICT DO NOTHING;

-- Demo Projects Seeds
INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date) VALUES
('30000000-0000-0000-0000-000000000001', 'RRMS', 'Regulatory Reporting Management System', 'Regulatory Compliance', 'New', 'Medium', '20000000-0000-0000-0000-000000000001', 'Active', 'Amber', '2026-08-27', '2026-09-30'),
('30000000-0000-0000-0000-000000000002', 'DTP', 'Digital Transformation Pilot', 'Lean Project Control Pilot', 'Change Major', 'Large', '20000000-0000-0000-0000-000000000001', 'Active', 'Green', '2026-08-01', '2026-11-30')
ON CONFLICT (project_code) DO NOTHING;

INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm) VALUES
('31000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'PM', true),
('31000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'BALead', false),
('31000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', 'PM', true)
ON CONFLICT (project_id, person_id, project_role) DO NOTHING;

INSERT INTO schema_migrations (filename) VALUES
('001_initial_schema.sql'),
('002_project_phases.sql'),
('003_task_notes.sql'),
('004_master_control.sql'),
('005_project_roles.sql'),
('006_project_type_size.sql'),
('007_task_on_hold_status.sql')
ON CONFLICT (filename) DO NOTHING;
