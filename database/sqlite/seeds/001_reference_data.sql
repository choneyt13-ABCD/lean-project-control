-- SQLite feasibility reference data. All people are non-personal demo records.
PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO roles (role_id, role_code, role_name, scope_type) VALUES
('10000000-0000-0000-0000-000000000001','PLATFORM_ADMIN','Platform Admin','Platform'),
('10000000-0000-0000-0000-000000000002','PM_PMO','PM/PMO','Portfolio'),
('10000000-0000-0000-0000-000000000003','PROJECT_ADMIN','Project Admin','Project'),
('10000000-0000-0000-0000-000000000004','BA_LEAD','BA Lead','Workstream'),
('10000000-0000-0000-0000-000000000005','DEV_LEAD','DEV Lead','Workstream'),
('10000000-0000-0000-0000-000000000006','QA_LEAD','QA Lead','Workstream'),
('10000000-0000-0000-0000-000000000007','TEAM_MEMBER','Team Member','Task'),
('10000000-0000-0000-0000-000000000008','REVIEWER','Reviewer','Project');
INSERT OR IGNORE INTO permissions (permission_id, permission_code, resource, action) VALUES
('11000000-0000-0000-0000-000000000001','project.view','Project','View'),
('11000000-0000-0000-0000-000000000002','project.create','Project','Create'),
('11000000-0000-0000-0000-000000000003','project.edit','Project','Edit'),
('11000000-0000-0000-0000-000000000004','project.delete','Project','Delete'),
('11000000-0000-0000-0000-000000000005','people.view','People','View'),
('11000000-0000-0000-0000-000000000006','people.edit','People','Edit'),
('11000000-0000-0000-0000-000000000007','rbac.view','RBAC','View'),
('11000000-0000-0000-0000-000000000008','rbac.manage','RBAC','Edit'),
('11000000-0000-0000-0000-000000000009','wbs.create','WBS','Create'),
('11000000-0000-0000-0000-000000000010','task.create','Task','Create'),
('11000000-0000-0000-0000-000000000011','assignment.create','Assignment','Create'),
('11000000-0000-0000-0000-000000000012','weekly_update.submit','WeeklyUpdate','Create'),
('11000000-0000-0000-0000-000000000013','weekly_update.review','WeeklyUpdate','Approve'),
('11000000-0000-0000-0000-000000000014','evidence.create','Evidence','Create'),
('11000000-0000-0000-0000-000000000015','raid.create','RAID','Create'),
('11000000-0000-0000-0000-000000000016','change_request.create','ChangeRequest','Create'),
('11000000-0000-0000-0000-000000000017','audit_log.view','AuditLog','View'),
('11000000-0000-0000-0000-000000000018','import.validate','Import','Import'),
('11000000-0000-0000-0000-000000000021','people.create','People','Create'),
('11000000-0000-0000-0000-000000000022','wbs.view','WBS','View'),
('11000000-0000-0000-0000-000000000023','task.view','Task','View'),
('11000000-0000-0000-0000-000000000024','task.edit','Task','Edit'),
('11000000-0000-0000-0000-000000000025','assignment.view','Assignment','View'),
('11000000-0000-0000-0000-000000000026','evidence.approve','Evidence','Approve'),
('11000000-0000-0000-0000-000000000027','raid.view','RAID','View'),
('11000000-0000-0000-0000-000000000028','raid.edit','RAID','Edit'),
('11000000-0000-0000-0000-000000000029','change_request.view','ChangeRequest','View'),
('11000000-0000-0000-0000-000000000030','change_request.approve','ChangeRequest','Approve');
INSERT OR IGNORE INTO task_statuses VALUES
('NotStarted','Not Started',1,0),('InProgress','In Progress',2,0),('OnHold','On Hold',3,0),('Blocked','Blocked',4,0),('Done','Done',5,1),('Cancelled','Cancelled',6,1);
INSERT OR IGNORE INTO rag_statuses VALUES ('Red','Red',1),('Amber','Amber',2),('Green','Green',3);
INSERT OR IGNORE INTO raid_types VALUES ('Risk','Risk',1),('Assumption','Assumption',2),('Issue','Issue',3),('Dependency','Dependency',4);
INSERT OR IGNORE INTO risk_levels VALUES
('Severity',1,'Very Low'),('Severity',2,'Low'),('Severity',3,'Medium'),('Severity',4,'High'),('Severity',5,'Very High'),
('Probability',1,'Rare'),('Probability',2,'Unlikely'),('Probability',3,'Possible'),('Probability',4,'Likely'),('Probability',5,'Almost Certain'),
('Impact',1,'Negligible'),('Impact',2,'Minor'),('Impact',3,'Moderate'),('Impact',4,'Major'),('Impact',5,'Critical');
INSERT OR IGNORE INTO people (person_id, employee_code, display_name, email, department, position_title) VALUES
('20000000-0000-0000-0000-000000000001','DEMO-RRMS-PM','RRMS Demo PM','rrms.demo.pm@example.invalid','Demo Office','Project Manager'),
('20000000-0000-0000-0000-000000000002','DEMO-RRMS-BA','RRMS Demo BA','rrms.demo.ba@example.invalid','Demo Office','Business Analyst');
INSERT OR IGNORE INTO user_accounts (user_account_id, person_id, login_name, auth_provider, password_hash) VALUES
('21000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','rrms.demo.pm','LocalPlaceholder',NULL),
('21000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000002','rrms.demo.ba','LocalPlaceholder',NULL);
INSERT OR IGNORE INTO projects (project_id, project_code, project_name, portfolio_name, main_pm_person_id, project_status, rag_status) VALUES
('30000000-0000-0000-0000-000000000001','RRMS','RRMS Pilot Project','Lean Project Control Pilot','20000000-0000-0000-0000-000000000001','Draft','Green');
INSERT OR IGNORE INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm) VALUES
('31000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','PM',1),
('31000000-0000-0000-0000-000000000002','30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000002','BALead',0);
INSERT OR IGNORE INTO user_roles (user_role_id, user_account_id, role_id, project_id) VALUES
('32000000-0000-0000-0000-000000000001','21000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000002','30000000-0000-0000-0000-000000000001'),
('32000000-0000-0000-0000-000000000002','21000000-0000-0000-0000-000000000002','10000000-0000-0000-0000-000000000004','30000000-0000-0000-0000-000000000001');

-- TODO (PM Decision): approve full role-permission mappings from docs/rbac-matrix.md before pilot authorization is implemented.
