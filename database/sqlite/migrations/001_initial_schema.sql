-- Lean Project Control: SQLite feasibility schema (SQLite 3.31+).
-- Application/ORM must generate UUID values and set updated_at on updates.
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;

CREATE TABLE people (
    person_id TEXT PRIMARY KEY, employee_code TEXT NOT NULL UNIQUE, display_name TEXT NOT NULL,
    email TEXT NOT NULL, department TEXT, position_title TEXT,
    person_status TEXT NOT NULL DEFAULT 'Active' CHECK (person_status IN ('Active','Inactive','External','Suspended')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT
);
CREATE UNIQUE INDEX uq_people_active_email ON people (lower(email)) WHERE deleted_at IS NULL;

CREATE TABLE user_accounts (
    user_account_id TEXT PRIMARY KEY, person_id TEXT NOT NULL REFERENCES people(person_id), login_name TEXT NOT NULL,
    auth_provider TEXT NOT NULL DEFAULT 'LocalPlaceholder' CHECK (auth_provider IN ('LocalPlaceholder','AD','SSO')),
    provider_subject TEXT, password_hash TEXT, account_status TEXT NOT NULL DEFAULT 'Active' CHECK (account_status IN ('Active','Disabled','Locked')),
    last_login_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    CHECK (auth_provider = 'LocalPlaceholder' OR password_hash IS NULL)
);
CREATE UNIQUE INDEX uq_user_accounts_active_login ON user_accounts (lower(login_name)) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX uq_user_accounts_provider_subject ON user_accounts (auth_provider, provider_subject) WHERE provider_subject IS NOT NULL AND deleted_at IS NULL;

CREATE TABLE roles (
    role_id TEXT PRIMARY KEY, role_code TEXT NOT NULL UNIQUE, role_name TEXT NOT NULL,
    scope_type TEXT NOT NULL CHECK (scope_type IN ('Platform','Portfolio','Project','Workstream','Task')),
    is_system_role INTEGER NOT NULL DEFAULT 1 CHECK (is_system_role IN (0,1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE permissions (
    permission_id TEXT PRIMARY KEY, permission_code TEXT NOT NULL UNIQUE, resource TEXT NOT NULL,
    action TEXT NOT NULL CHECK (action IN ('View','Create','Edit','Delete','Approve','Import')),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE role_permissions (
    role_permission_id TEXT PRIMARY KEY, role_id TEXT NOT NULL REFERENCES roles(role_id), permission_id TEXT NOT NULL REFERENCES permissions(permission_id),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, UNIQUE (role_id, permission_id)
);

CREATE TABLE projects (
    project_id TEXT PRIMARY KEY, project_code TEXT NOT NULL, project_name TEXT NOT NULL, portfolio_name TEXT,
    main_pm_person_id TEXT NOT NULL REFERENCES people(person_id), project_status TEXT NOT NULL DEFAULT 'Draft'
        CHECK (project_status IN ('Draft','Active','OnHold','Completed','Cancelled','Deleted')),
    rag_status TEXT CHECK (rag_status IN ('Red','Amber','Green')), start_date TEXT, target_end_date TEXT,
    deleted_at TEXT, deleted_by_person_id TEXT REFERENCES people(person_id), deletion_reason TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (target_end_date IS NULL OR start_date IS NULL OR target_end_date >= start_date),
    CHECK ((deleted_at IS NULL AND deleted_by_person_id IS NULL AND deletion_reason IS NULL) OR (deleted_at IS NOT NULL AND deleted_by_person_id IS NOT NULL AND deletion_reason IS NOT NULL))
);
CREATE UNIQUE INDEX uq_projects_active_code ON projects(project_code) WHERE deleted_at IS NULL;

CREATE TABLE user_roles (
    user_role_id TEXT PRIMARY KEY, user_account_id TEXT NOT NULL REFERENCES user_accounts(user_account_id), role_id TEXT NOT NULL REFERENCES roles(role_id),
    project_id TEXT REFERENCES projects(project_id), workstream_code TEXT, active_from TEXT, active_to TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (active_to IS NULL OR active_from IS NULL OR active_to >= active_from)
);
CREATE UNIQUE INDEX uq_user_roles_scope ON user_roles(user_account_id, role_id, ifnull(project_id, ''), ifnull(workstream_code, ''));

CREATE TABLE project_members (
    project_member_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), person_id TEXT NOT NULL REFERENCES people(person_id),
    project_role TEXT NOT NULL CHECK (project_role IN ('PM','ProjectAdmin','BALead','DEVLead','QALead','TeamMember','Reviewer')),
    is_main_pm INTEGER NOT NULL DEFAULT 0 CHECK (is_main_pm IN (0,1)), active_from TEXT, active_to TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    CHECK (active_to IS NULL OR active_from IS NULL OR active_to >= active_from), UNIQUE (project_id, person_id, project_role)
);
CREATE UNIQUE INDEX uq_project_members_active_main_pm ON project_members(project_id) WHERE is_main_pm = 1 AND deleted_at IS NULL;

CREATE TABLE task_statuses (task_status_code TEXT PRIMARY KEY, display_name TEXT NOT NULL, sort_order INTEGER NOT NULL, is_terminal INTEGER NOT NULL DEFAULT 0 CHECK (is_terminal IN (0,1)));
CREATE TABLE rag_statuses (rag_status_code TEXT PRIMARY KEY, display_name TEXT NOT NULL, sort_order INTEGER NOT NULL);
CREATE TABLE raid_types (raid_type_code TEXT PRIMARY KEY, display_name TEXT NOT NULL, sort_order INTEGER NOT NULL);
CREATE TABLE risk_levels (scale_type TEXT NOT NULL CHECK (scale_type IN ('Severity','Probability','Impact')), level INTEGER NOT NULL CHECK (level BETWEEN 1 AND 5), display_name TEXT NOT NULL, PRIMARY KEY (scale_type, level));

CREATE TABLE wbs_items (
    wbs_item_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), parent_wbs_item_id TEXT REFERENCES wbs_items(wbs_item_id),
    wbs_code TEXT NOT NULL, wbs_name TEXT NOT NULL, sort_order REAL NOT NULL DEFAULT 0 CHECK (sort_order >= 0),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    UNIQUE (project_id, wbs_code)
);
CREATE TABLE tasks (
    task_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), wbs_item_id TEXT NOT NULL REFERENCES wbs_items(wbs_item_id),
    parent_task_id TEXT REFERENCES tasks(task_id), task_code TEXT NOT NULL, task_type TEXT NOT NULL CHECK (task_type IN ('MainTask','Task','Subtask')),
    task_name TEXT NOT NULL, description TEXT, owner_person_id TEXT NOT NULL REFERENCES people(person_id),
    planned_start_date TEXT, planned_due_date TEXT, actual_start_date TEXT, actual_finish_date TEXT,
    status TEXT NOT NULL REFERENCES task_statuses(task_status_code), rag_status TEXT REFERENCES rag_statuses(rag_status_code),
    weight REAL CHECK (weight IS NULL OR weight BETWEEN 0 AND 100), progress REAL NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    evidence_required INTEGER NOT NULL DEFAULT 0 CHECK (evidence_required IN (0,1)), reviewed_at TEXT, reviewed_by_person_id TEXT REFERENCES people(person_id),
    workstream TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    CHECK (planned_due_date IS NULL OR planned_start_date IS NULL OR planned_due_date >= planned_start_date),
    CHECK (actual_finish_date IS NULL OR actual_start_date IS NULL OR actual_finish_date >= actual_start_date),
    CHECK (status <> 'Done' OR progress = 100), UNIQUE (project_id, task_code)
);
CREATE TABLE task_assignments (
    task_assignment_id TEXT PRIMARY KEY, task_id TEXT NOT NULL REFERENCES tasks(task_id), person_id TEXT NOT NULL REFERENCES people(person_id),
    assignment_role TEXT NOT NULL,
    raci_role TEXT CHECK (raci_role IN ('Responsible','Accountable','Consulted','Informed')), allocation_percent REAL CHECK (allocation_percent IS NULL OR allocation_percent BETWEEN 0 AND 100),
    is_primary INTEGER NOT NULL DEFAULT 0 CHECK (is_primary IN (0,1)), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    UNIQUE (task_id, person_id, assignment_role)
);
CREATE TABLE task_dependencies (
    task_dependency_id TEXT PRIMARY KEY, predecessor_task_id TEXT NOT NULL REFERENCES tasks(task_id), successor_task_id TEXT NOT NULL REFERENCES tasks(task_id),
    dependency_type TEXT NOT NULL DEFAULT 'FS' CHECK (dependency_type IN ('FS','SS','FF','SF')), lag_days INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (predecessor_task_id <> successor_task_id), UNIQUE (predecessor_task_id, successor_task_id, dependency_type)
);
CREATE TABLE weekly_updates (
    weekly_update_id TEXT PRIMARY KEY, task_id TEXT NOT NULL REFERENCES tasks(task_id), week_start_date TEXT NOT NULL,
    submitted_by_person_id TEXT NOT NULL REFERENCES people(person_id), progress REAL NOT NULL CHECK (progress BETWEEN 0 AND 100),
    status TEXT NOT NULL REFERENCES task_statuses(task_status_code), rag_status TEXT NOT NULL REFERENCES rag_statuses(rag_status_code), summary TEXT NOT NULL CHECK (length(summary) BETWEEN 1 AND 2000),
    blocker TEXT, next_step TEXT, review_status TEXT NOT NULL DEFAULT 'Draft' CHECK (review_status IN ('Draft','Submitted','Reviewed','Rejected','OverdueReview')),
    reviewed_by_person_id TEXT REFERENCES people(person_id), reviewed_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    UNIQUE (task_id, week_start_date, submitted_by_person_id)
);
CREATE TABLE evidence (
    evidence_id TEXT PRIMARY KEY, related_entity_type TEXT NOT NULL CHECK (related_entity_type IN ('Project','WBS','Task','WeeklyUpdate','RAID')), related_entity_id TEXT NOT NULL,
    file_name TEXT NOT NULL, file_type TEXT, storage_ref TEXT NOT NULL, uploaded_by_person_id TEXT NOT NULL REFERENCES people(person_id),
    review_status TEXT NOT NULL DEFAULT 'Pending' CHECK (review_status IN ('Pending','Accepted','Rejected')), reviewed_by_person_id TEXT REFERENCES people(person_id), reviewed_at TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT
);
CREATE TABLE raid_items (
    raid_item_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), raid_code TEXT NOT NULL, raid_type TEXT NOT NULL REFERENCES raid_types(raid_type_code),
    title TEXT NOT NULL, description TEXT, owner_person_id TEXT NOT NULL REFERENCES people(person_id), probability INTEGER CHECK (probability BETWEEN 1 AND 5), impact INTEGER CHECK (impact BETWEEN 1 AND 5),
    severity_score INTEGER GENERATED ALWAYS AS (probability * impact) STORED, mitigation_plan TEXT, escalation_trigger_score INTEGER CHECK (escalation_trigger_score BETWEEN 1 AND 25),
    status TEXT NOT NULL DEFAULT 'Open' CHECK (status IN ('Open','Monitoring','Mitigated','Closed')), due_date TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    UNIQUE (project_id, raid_code), CHECK ((raid_type = 'Risk' AND probability IS NOT NULL AND impact IS NOT NULL) OR raid_type <> 'Risk')
);
CREATE TABLE baseline_versions (
    baseline_version_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), version_number INTEGER NOT NULL CHECK (version_number > 0),
    baseline_status TEXT NOT NULL DEFAULT 'Draft' CHECK (baseline_status IN ('Draft','Approved','Superseded')), snapshot TEXT NOT NULL,
    approved_by_person_id TEXT REFERENCES people(person_id), approved_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, version_number), CHECK ((baseline_status = 'Approved' AND approved_by_person_id IS NOT NULL AND approved_at IS NOT NULL) OR baseline_status <> 'Approved')
);
CREATE TABLE change_requests (
    change_request_id TEXT PRIMARY KEY, project_id TEXT NOT NULL REFERENCES projects(project_id), baseline_version_id TEXT REFERENCES baseline_versions(baseline_version_id),
    cr_code TEXT NOT NULL, requested_by_person_id TEXT NOT NULL REFERENCES people(person_id), requested_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_type TEXT NOT NULL CHECK (change_type IN ('Scope','DueDate','Weight','Ownership','Baseline','Other')), reason TEXT NOT NULL, impact_analysis TEXT,
    approval_status TEXT NOT NULL DEFAULT 'Draft' CHECK (approval_status IN ('Draft','Submitted','Approved','Rejected','Cancelled')),
    approver_person_id TEXT REFERENCES people(person_id), decided_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT,
    UNIQUE (project_id, cr_code)
);
CREATE TABLE audit_logs (
    audit_log_id TEXT PRIMARY KEY, actor_person_id TEXT REFERENCES people(person_id), action TEXT NOT NULL, entity_type TEXT NOT NULL, entity_id TEXT NOT NULL,
    before_snapshot TEXT, after_snapshot TEXT, reason TEXT, occurred_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, request_id TEXT
);
CREATE INDEX ix_audit_logs_entity ON audit_logs(entity_type, entity_id, occurred_at DESC);
CREATE TABLE custom_field_definitions (
    custom_field_definition_id TEXT PRIMARY KEY, project_id TEXT REFERENCES projects(project_id),
    entity_type TEXT NOT NULL CHECK (entity_type IN ('Project','WBS','Task','WeeklyUpdate','Evidence','RAID','People')), field_key TEXT NOT NULL, field_label TEXT NOT NULL,
    field_type TEXT NOT NULL CHECK (field_type IN ('Text','Number','Date','Boolean','Select','MultiSelect')), is_required INTEGER NOT NULL DEFAULT 0 CHECK (is_required IN (0,1)),
    allowed_values TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, deleted_at TEXT
);
CREATE UNIQUE INDEX uq_custom_fields_platform ON custom_field_definitions(entity_type, field_key) WHERE project_id IS NULL AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_custom_fields_project ON custom_field_definitions(project_id, entity_type, field_key) WHERE project_id IS NOT NULL AND deleted_at IS NULL;

-- API/service validation remains required for cross-project membership, task/WBS/dependency cycles,
-- Main PM project deletion authority, Audit Log creation, Definition of Done, and all TODO PM decisions.
