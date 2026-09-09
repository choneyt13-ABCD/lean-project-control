-- Lean Project Control: Phase 2 initial PostgreSQL schema.
-- No application, authentication provider, or database connection is created by this file.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE people (
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
CREATE UNIQUE INDEX uq_people_active_email ON people (lower(email)) WHERE deleted_at IS NULL;

CREATE TABLE user_accounts (
    user_account_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id uuid NOT NULL REFERENCES people(person_id),
    login_name varchar(200) NOT NULL,
    auth_provider varchar(30) NOT NULL DEFAULT 'LocalPlaceholder'
        CHECK (auth_provider IN ('LocalPlaceholder', 'AD', 'SSO')),
    provider_subject varchar(300),
    password_hash varchar(500), -- Never store a plaintext password.
    account_status varchar(20) NOT NULL DEFAULT 'Active'
        CHECK (account_status IN ('Active', 'Disabled', 'Locked')),
    last_login_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    CONSTRAINT ck_user_account_password_hash CHECK (
        auth_provider = 'LocalPlaceholder' OR password_hash IS NULL
    )
);
CREATE UNIQUE INDEX uq_user_accounts_active_login ON user_accounts (lower(login_name)) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_user_accounts_provider_subject ON user_accounts (auth_provider, provider_subject)
    WHERE provider_subject IS NOT NULL AND deleted_at IS NULL;

CREATE TABLE roles (
    role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_code varchar(80) NOT NULL UNIQUE,
    role_name varchar(150) NOT NULL,
    scope_type varchar(20) NOT NULL CHECK (scope_type IN ('Platform', 'Portfolio', 'Project', 'Workstream', 'Task')),
    is_system_role boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE permissions (
    permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_code varchar(120) NOT NULL UNIQUE,
    resource varchar(40) NOT NULL,
    action varchar(20) NOT NULL CHECK (action IN ('View', 'Create', 'Edit', 'Delete', 'Approve', 'Import')),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role_permissions (
    role_permission_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id uuid NOT NULL REFERENCES roles(role_id),
    permission_id uuid NOT NULL REFERENCES permissions(permission_id),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (role_id, permission_id)
);

CREATE TABLE projects (
    project_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_code varchar(80) NOT NULL,
    project_name varchar(200) NOT NULL,
    portfolio_name varchar(150),
    main_pm_person_id uuid NOT NULL REFERENCES people(person_id),
    project_status varchar(20) NOT NULL DEFAULT 'Draft'
        CHECK (project_status IN ('Draft', 'Active', 'OnHold', 'Completed', 'Cancelled', 'Deleted')),
    rag_status varchar(10) CHECK (rag_status IN ('Red', 'Amber', 'Green')),
    start_date date,
    target_end_date date,
    deleted_at timestamptz,
    deleted_by_person_id uuid REFERENCES people(person_id),
    deletion_reason text,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_projects_date_range CHECK (target_end_date IS NULL OR start_date IS NULL OR target_end_date >= start_date),
    CONSTRAINT ck_projects_soft_delete CHECK (
        (deleted_at IS NULL AND deleted_by_person_id IS NULL AND deletion_reason IS NULL)
        OR (deleted_at IS NOT NULL AND deleted_by_person_id IS NOT NULL AND deletion_reason IS NOT NULL)
    )
);
CREATE UNIQUE INDEX uq_projects_active_code ON projects (project_code) WHERE deleted_at IS NULL;

CREATE TABLE user_roles (
    user_role_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_account_id uuid NOT NULL REFERENCES user_accounts(user_account_id),
    role_id uuid NOT NULL REFERENCES roles(role_id),
    project_id uuid REFERENCES projects(project_id),
    workstream_code varchar(80),
    active_from date,
    active_to date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_user_roles_date_range CHECK (active_to IS NULL OR active_from IS NULL OR active_to >= active_from)
);
CREATE UNIQUE INDEX uq_user_roles_scope ON user_roles (user_account_id, role_id, COALESCE(project_id, '00000000-0000-0000-0000-000000000000'::uuid), COALESCE(workstream_code, ''));

CREATE TABLE project_members (
    project_member_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    person_id uuid NOT NULL REFERENCES people(person_id),
    project_role varchar(30) NOT NULL CHECK (project_role IN ('PM', 'ProjectAdmin', 'BALead', 'DEVLead', 'QALead', 'TeamMember', 'Reviewer')),
    is_main_pm boolean NOT NULL DEFAULT false,
    active_from date,
    active_to date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    CONSTRAINT ck_project_members_date_range CHECK (active_to IS NULL OR active_from IS NULL OR active_to >= active_from),
    UNIQUE (project_id, person_id, project_role)
);
CREATE UNIQUE INDEX uq_project_members_active_main_pm ON project_members (project_id) WHERE is_main_pm AND deleted_at IS NULL;

CREATE TABLE task_statuses (
    task_status_code varchar(30) PRIMARY KEY,
    display_name varchar(100) NOT NULL,
    sort_order smallint NOT NULL,
    is_terminal boolean NOT NULL DEFAULT false
);

CREATE TABLE rag_statuses (
    rag_status_code varchar(10) PRIMARY KEY,
    display_name varchar(100) NOT NULL,
    sort_order smallint NOT NULL
);

CREATE TABLE raid_types (
    raid_type_code varchar(20) PRIMARY KEY,
    display_name varchar(100) NOT NULL,
    sort_order smallint NOT NULL
);

CREATE TABLE risk_levels (
    scale_type varchar(20) NOT NULL CHECK (scale_type IN ('Severity', 'Probability', 'Impact')),
    level smallint NOT NULL CHECK (level BETWEEN 1 AND 5),
    display_name varchar(100) NOT NULL,
    PRIMARY KEY (scale_type, level)
);

CREATE TABLE wbs_items (
    wbs_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    parent_wbs_item_id uuid REFERENCES wbs_items(wbs_item_id),
    wbs_code varchar(100) NOT NULL,
    wbs_name varchar(200) NOT NULL,
    sort_order numeric(10,2) NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, wbs_code)
);

CREATE TABLE tasks (
    task_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    wbs_item_id uuid NOT NULL REFERENCES wbs_items(wbs_item_id),
    parent_task_id uuid REFERENCES tasks(task_id),
    task_code varchar(100) NOT NULL,
    task_type varchar(20) NOT NULL CHECK (task_type IN ('MainTask', 'Task', 'Subtask')),
    task_name varchar(300) NOT NULL,
    description text,
    owner_person_id uuid NOT NULL REFERENCES people(person_id),
    planned_start_date date,
    planned_due_date date,
    actual_start_date date,
    actual_finish_date date,
    status varchar(30) NOT NULL REFERENCES task_statuses(task_status_code),
    rag_status varchar(10) REFERENCES rag_statuses(rag_status_code),
    weight numeric(7,2) CHECK (weight IS NULL OR weight BETWEEN 0 AND 100),
    progress numeric(5,2) NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    evidence_required boolean NOT NULL DEFAULT false,
    reviewed_at timestamptz,
    reviewed_by_person_id uuid REFERENCES people(person_id),
    workstream varchar(100),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    CONSTRAINT ck_tasks_planned_dates CHECK (planned_due_date IS NULL OR planned_start_date IS NULL OR planned_due_date >= planned_start_date),
    CONSTRAINT ck_tasks_actual_dates CHECK (actual_finish_date IS NULL OR actual_start_date IS NULL OR actual_finish_date >= actual_start_date),
    CONSTRAINT ck_tasks_done_progress CHECK (status <> 'Done' OR progress = 100),
    UNIQUE (project_id, task_code)
);

CREATE TABLE task_assignments (
    task_assignment_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    person_id uuid NOT NULL REFERENCES people(person_id),
    assignment_role varchar(20) NOT NULL CHECK (assignment_role IN ('Owner', 'BA', 'DEV', 'QA', 'Reviewer', 'Contributor', 'Observer')),
    raci_role varchar(20) CHECK (raci_role IN ('Responsible', 'Accountable', 'Consulted', 'Informed')),
    allocation_percent numeric(5,2) CHECK (allocation_percent IS NULL OR allocation_percent BETWEEN 0 AND 100),
    is_primary boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (task_id, person_id, assignment_role)
);

CREATE TABLE task_dependencies (
    task_dependency_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    predecessor_task_id uuid NOT NULL REFERENCES tasks(task_id),
    successor_task_id uuid NOT NULL REFERENCES tasks(task_id),
    dependency_type varchar(10) NOT NULL DEFAULT 'FS' CHECK (dependency_type IN ('FS', 'SS', 'FF', 'SF')),
    lag_days integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_task_dependencies_distinct CHECK (predecessor_task_id <> successor_task_id),
    UNIQUE (predecessor_task_id, successor_task_id, dependency_type)
);

CREATE TABLE weekly_updates (
    weekly_update_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id uuid NOT NULL REFERENCES tasks(task_id),
    week_start_date date NOT NULL,
    submitted_by_person_id uuid NOT NULL REFERENCES people(person_id),
    progress numeric(5,2) NOT NULL CHECK (progress BETWEEN 0 AND 100),
    status varchar(30) NOT NULL REFERENCES task_statuses(task_status_code),
    rag_status varchar(10) NOT NULL REFERENCES rag_statuses(rag_status_code),
    summary text NOT NULL CHECK (length(summary) BETWEEN 1 AND 2000),
    blocker text,
    next_step text,
    review_status varchar(20) NOT NULL DEFAULT 'Draft' CHECK (review_status IN ('Draft', 'Submitted', 'Reviewed', 'Rejected', 'OverdueReview')),
    reviewed_by_person_id uuid REFERENCES people(person_id),
    reviewed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (task_id, week_start_date, submitted_by_person_id)
);

CREATE TABLE evidence (
    evidence_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    related_entity_type varchar(30) NOT NULL CHECK (related_entity_type IN ('Project', 'WBS', 'Task', 'WeeklyUpdate', 'RAID')),
    related_entity_id uuid NOT NULL,
    file_name varchar(255) NOT NULL,
    file_type varchar(100),
    storage_ref varchar(1000) NOT NULL, -- Pointer only; never embed credentials.
    uploaded_by_person_id uuid NOT NULL REFERENCES people(person_id),
    review_status varchar(20) NOT NULL DEFAULT 'Pending' CHECK (review_status IN ('Pending', 'Accepted', 'Rejected')),
    reviewed_by_person_id uuid REFERENCES people(person_id),
    reviewed_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);

CREATE TABLE raid_items (
    raid_item_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    raid_code varchar(100) NOT NULL,
    raid_type varchar(20) NOT NULL REFERENCES raid_types(raid_type_code),
    title varchar(300) NOT NULL,
    description text,
    owner_person_id uuid NOT NULL REFERENCES people(person_id),
    probability smallint CHECK (probability BETWEEN 1 AND 5),
    impact smallint CHECK (impact BETWEEN 1 AND 5),
    severity_score smallint GENERATED ALWAYS AS (probability * impact) STORED,
    mitigation_plan text,
    escalation_trigger_score smallint CHECK (escalation_trigger_score BETWEEN 1 AND 25),
    status varchar(20) NOT NULL DEFAULT 'Open' CHECK (status IN ('Open', 'Monitoring', 'Mitigated', 'Closed')),
    due_date date,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, raid_code),
    CONSTRAINT ck_raid_risk_score CHECK ((raid_type = 'Risk' AND probability IS NOT NULL AND impact IS NOT NULL) OR raid_type <> 'Risk')
);

CREATE TABLE baseline_versions (
    baseline_version_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    version_number integer NOT NULL CHECK (version_number > 0),
    baseline_status varchar(20) NOT NULL DEFAULT 'Draft' CHECK (baseline_status IN ('Draft', 'Approved', 'Superseded')),
    snapshot jsonb NOT NULL,
    approved_by_person_id uuid REFERENCES people(person_id),
    approved_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, version_number),
    CONSTRAINT ck_baseline_approval CHECK ((baseline_status = 'Approved' AND approved_by_person_id IS NOT NULL AND approved_at IS NOT NULL) OR baseline_status <> 'Approved')
);

CREATE TABLE change_requests (
    change_request_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects(project_id),
    baseline_version_id uuid REFERENCES baseline_versions(baseline_version_id),
    cr_code varchar(100) NOT NULL,
    requested_by_person_id uuid NOT NULL REFERENCES people(person_id),
    requested_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_type varchar(40) NOT NULL CHECK (change_type IN ('Scope', 'DueDate', 'Weight', 'Ownership', 'Baseline', 'Other')),
    reason text NOT NULL,
    impact_analysis text,
    approval_status varchar(20) NOT NULL DEFAULT 'Draft' CHECK (approval_status IN ('Draft', 'Submitted', 'Approved', 'Rejected', 'Cancelled')),
    approver_person_id uuid REFERENCES people(person_id),
    decided_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    UNIQUE (project_id, cr_code)
);

CREATE TABLE audit_logs (
    audit_log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_person_id uuid REFERENCES people(person_id),
    action varchar(100) NOT NULL,
    entity_type varchar(50) NOT NULL,
    entity_id uuid NOT NULL,
    before_snapshot jsonb,
    after_snapshot jsonb,
    reason text,
    occurred_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    request_id uuid
);
CREATE INDEX ix_audit_logs_entity ON audit_logs (entity_type, entity_id, occurred_at DESC);

CREATE TABLE custom_field_definitions (
    custom_field_definition_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid REFERENCES projects(project_id),
    entity_type varchar(30) NOT NULL CHECK (entity_type IN ('Project', 'WBS', 'Task', 'WeeklyUpdate', 'Evidence', 'RAID', 'People')),
    field_key varchar(100) NOT NULL,
    field_label varchar(150) NOT NULL,
    field_type varchar(20) NOT NULL CHECK (field_type IN ('Text', 'Number', 'Date', 'Boolean', 'Select', 'MultiSelect')),
    is_required boolean NOT NULL DEFAULT false,
    allowed_values jsonb,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz
);
CREATE UNIQUE INDEX uq_custom_fields_platform ON custom_field_definitions (entity_type, field_key)
    WHERE project_id IS NULL AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_custom_fields_project ON custom_field_definitions (project_id, entity_type, field_key)
    WHERE project_id IS NOT NULL AND deleted_at IS NULL;

CREATE TRIGGER trg_people_updated_at BEFORE UPDATE ON people FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_user_accounts_updated_at BEFORE UPDATE ON user_accounts FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_roles_updated_at BEFORE UPDATE ON roles FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_permissions_updated_at BEFORE UPDATE ON permissions FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_role_permissions_updated_at BEFORE UPDATE ON role_permissions FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_user_roles_updated_at BEFORE UPDATE ON user_roles FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_project_members_updated_at BEFORE UPDATE ON project_members FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_wbs_items_updated_at BEFORE UPDATE ON wbs_items FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_task_assignments_updated_at BEFORE UPDATE ON task_assignments FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_task_dependencies_updated_at BEFORE UPDATE ON task_dependencies FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_weekly_updates_updated_at BEFORE UPDATE ON weekly_updates FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_evidence_updated_at BEFORE UPDATE ON evidence FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_raid_items_updated_at BEFORE UPDATE ON raid_items FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_baseline_versions_updated_at BEFORE UPDATE ON baseline_versions FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_change_requests_updated_at BEFORE UPDATE ON change_requests FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_custom_fields_updated_at BEFORE UPDATE ON custom_field_definitions FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Service-layer requirements: validate cross-project membership, hierarchy/dependency cycles,
-- and main-PM authority. On project soft delete, insert an audit_logs row in the same transaction.
