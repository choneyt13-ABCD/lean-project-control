-- Reference data and non-personal RRMS pilot data. Safe for local design/testing only.

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

INSERT INTO permissions (permission_id, permission_code, resource, action) VALUES
('11000000-0000-0000-0000-000000000001', 'project.view', 'Project', 'View'),
('11000000-0000-0000-0000-000000000002', 'project.create', 'Project', 'Create'),
('11000000-0000-0000-0000-000000000003', 'project.edit', 'Project', 'Edit'),
('11000000-0000-0000-0000-000000000004', 'project.delete', 'Project', 'Delete'),
('11000000-0000-0000-0000-000000000005', 'people.manage', 'People', 'Edit'),
('11000000-0000-0000-0000-000000000006', 'rbac.manage', 'RBAC', 'Edit'),
('11000000-0000-0000-0000-000000000007', 'wbs.manage', 'WBS', 'Edit'),
('11000000-0000-0000-0000-000000000008', 'task.manage', 'Task', 'Edit'),
('11000000-0000-0000-0000-000000000009', 'assignment.manage', 'Assignment', 'Edit'),
('11000000-0000-0000-0000-000000000010', 'weekly_update.submit', 'WeeklyUpdate', 'Create'),
('11000000-0000-0000-0000-000000000011', 'weekly_update.review', 'WeeklyUpdate', 'Approve'),
('11000000-0000-0000-0000-000000000012', 'evidence.manage', 'Evidence', 'Edit'),
('11000000-0000-0000-0000-000000000013', 'raid.manage', 'RAID', 'Edit'),
('11000000-0000-0000-0000-000000000014', 'change_request.manage', 'ChangeRequest', 'Edit'),
('11000000-0000-0000-0000-000000000015', 'audit_log.view', 'AuditLog', 'View'),
('11000000-0000-0000-0000-000000000016', 'import.validate', 'Import', 'Import')
ON CONFLICT (permission_code) DO NOTHING;

INSERT INTO permissions (permission_id, permission_code, resource, action) VALUES
('11000000-0000-0000-0000-000000000021', 'people.view', 'People', 'View'),
('11000000-0000-0000-0000-000000000022', 'people.create', 'People', 'Create'),
('11000000-0000-0000-0000-000000000023', 'people.edit', 'People', 'Edit'),
('11000000-0000-0000-0000-000000000024', 'rbac.view', 'RBAC', 'View'),
('11000000-0000-0000-0000-000000000025', 'wbs.view', 'WBS', 'View'),
('11000000-0000-0000-0000-000000000026', 'wbs.create', 'WBS', 'Create'),
('11000000-0000-0000-0000-000000000027', 'task.view', 'Task', 'View'),
('11000000-0000-0000-0000-000000000028', 'task.create', 'Task', 'Create'),
('11000000-0000-0000-0000-000000000029', 'task.edit', 'Task', 'Edit'),
('11000000-0000-0000-0000-000000000030', 'assignment.view', 'Assignment', 'View'),
('11000000-0000-0000-0000-000000000031', 'assignment.create', 'Assignment', 'Create'),
('11000000-0000-0000-0000-000000000032', 'evidence.create', 'Evidence', 'Create'),
('11000000-0000-0000-0000-000000000033', 'evidence.approve', 'Evidence', 'Approve'),
('11000000-0000-0000-0000-000000000034', 'raid.view', 'RAID', 'View'),
('11000000-0000-0000-0000-000000000035', 'raid.create', 'RAID', 'Create'),
('11000000-0000-0000-0000-000000000036', 'raid.edit', 'RAID', 'Edit'),
('11000000-0000-0000-0000-000000000037', 'change_request.view', 'ChangeRequest', 'View'),
('11000000-0000-0000-0000-000000000038', 'change_request.create', 'ChangeRequest', 'Create'),
('11000000-0000-0000-0000-000000000039', 'change_request.approve', 'ChangeRequest', 'Approve')
ON CONFLICT (permission_code) DO NOTHING;

INSERT INTO task_statuses (task_status_code, display_name, sort_order, is_terminal) VALUES
('NotStarted', 'Not Started', 1, false), ('InProgress', 'In Progress', 2, false),
('OnHold', 'On Hold', 3, false), ('Blocked', 'Blocked', 4, false),
('Done', 'Done', 5, true), ('Cancelled', 'Cancelled', 6, true)
ON CONFLICT (task_status_code) DO NOTHING;

INSERT INTO rag_statuses (rag_status_code, display_name, sort_order) VALUES
('Red', 'Red', 1), ('Amber', 'Amber', 2), ('Green', 'Green', 3)
ON CONFLICT (rag_status_code) DO NOTHING;

INSERT INTO raid_types (raid_type_code, display_name, sort_order) VALUES
('Risk', 'Risk', 1), ('Assumption', 'Assumption', 2), ('Issue', 'Issue', 3), ('Dependency', 'Dependency', 4)
ON CONFLICT (raid_type_code) DO NOTHING;

INSERT INTO risk_levels (scale_type, level, display_name) VALUES
('Severity', 1, 'Very Low'), ('Severity', 2, 'Low'), ('Severity', 3, 'Medium'), ('Severity', 4, 'High'), ('Severity', 5, 'Very High'),
('Probability', 1, 'Rare'), ('Probability', 2, 'Unlikely'), ('Probability', 3, 'Possible'), ('Probability', 4, 'Likely'), ('Probability', 5, 'Almost Certain'),
('Impact', 1, 'Negligible'), ('Impact', 2, 'Minor'), ('Impact', 3, 'Moderate'), ('Impact', 4, 'Major'), ('Impact', 5, 'Critical')
ON CONFLICT (scale_type, level) DO NOTHING;

-- Role-to-permission mapping is intentionally minimal; full behavior remains governed by RBAC Matrix.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r CROSS JOIN permissions p
WHERE r.role_code = 'PLATFORM_ADMIN'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status) VALUES
('20000000-0000-0000-0000-000000000001', 'DEMO-RRMS-PM', 'RRMS Demo PM', 'rrms.demo.pm@example.invalid', 'Demo Office', 'Project Manager', 'Active'),
('20000000-0000-0000-0000-000000000002', 'DEMO-RRMS-BA', 'RRMS Demo BA', 'rrms.demo.ba@example.invalid', 'Demo Office', 'Business Analyst', 'Active')
ON CONFLICT (employee_code) DO NOTHING;

INSERT INTO user_accounts (user_account_id, person_id, login_name, auth_provider, password_hash, account_status) VALUES
('21000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'rrms.demo.pm', 'LocalPlaceholder', NULL, 'Active'),
('21000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', 'rrms.demo.ba', 'LocalPlaceholder', NULL, 'Active')
ON CONFLICT DO NOTHING;

INSERT INTO projects (project_id, project_code, project_name, portfolio_name, main_pm_person_id, project_status, rag_status) VALUES
('30000000-0000-0000-0000-000000000001', 'RRMS', 'RRMS Pilot Project', 'Lean Project Control Pilot', '20000000-0000-0000-0000-000000000001', 'Draft', 'Green')
ON CONFLICT (project_code) WHERE deleted_at IS NULL DO NOTHING;

INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm) VALUES
('31000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'PM', true),
('31000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'BALead', false)
ON CONFLICT (project_id, person_id, project_role) DO NOTHING;

INSERT INTO user_roles (user_role_id, user_account_id, role_id, project_id) VALUES
('32000000-0000-0000-0000-000000000001', '21000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001'),
('32000000-0000-0000-0000-000000000002', '21000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;

-- TODO (PM Decision): add the approved role-permission mappings beyond Platform Admin.
-- TODO (PM Decision): confirm RAG definitions and severity-score escalation thresholds.
