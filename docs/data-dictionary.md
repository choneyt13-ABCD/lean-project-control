# Data Dictionary

Phase 1 data specification for Lean Project Control, using RRMS as the first pilot project.

This is a logical data dictionary only. No physical database schema is created in Phase 1.

## Data Rules

- People Master and User Account are separate entities.
- People Master is the source of truth for person profile and organization information.
- User Account is the source of truth for application login identity and account status.
- Passwords must never be stored as plain text. If local authentication is ever introduced, only salted password hashes from an approved identity component may be stored.
- AD/SSO is out of scope for real integration in Phase 1, but future identity mapping fields are reserved.
- Audit Log is append-only by design.

## People

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `person_id` | UUID | Yes | Unique, immutable | Lean Project Control People Master |
| `employee_code` | String | Yes | Unique when provided by organization | HR / People Master import |
| `display_name` | String | Yes | 1-200 characters | People Master |
| `email` | String | Yes | Valid email, unique active record | People Master |
| `department` | String | No | 0-100 characters | HR / People Master import |
| `position_title` | String | No | 0-100 characters | HR / People Master import |
| `person_status` | Enum | Yes | Active, Inactive, External, Suspended | People Master |
| `created_at` | DateTime | Yes | System generated | System |
| `updated_at` | DateTime | Yes | System generated | System |

## User Account

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `user_account_id` | UUID | Yes | Unique, immutable | Lean Project Control |
| `person_id` | UUID | Yes | Must exist in People | People Master |
| `login_name` | String | Yes | Unique active login | User Account |
| `auth_provider` | Enum | Yes | LocalPlaceholder, AD, SSO | User Account / Future IdP |
| `provider_subject` | String | No | Unique per provider when used | Future AD/SSO |
| `password_hash` | String | No | Never plain text; null for AD/SSO | Approved identity component |
| `account_status` | Enum | Yes | Active, Disabled, Locked | User Account |
| `last_login_at` | DateTime | No | System generated | System |

## Role

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `role_id` | UUID | Yes | Unique | RBAC configuration |
| `role_code` | String | Yes | Unique; stable code | RBAC configuration |
| `role_name` | String | Yes | Platform Admin, PM/PMO, Project Admin, BA Lead, DEV Lead, QA Lead, Team Member, Reviewer | RBAC configuration |
| `scope_type` | Enum | Yes | Platform, Portfolio, Project, Workstream, Task | RBAC configuration |
| `is_system_role` | Boolean | Yes | True for built-in roles | RBAC configuration |

## Permission

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `permission_id` | UUID | Yes | Unique | RBAC configuration |
| `permission_code` | String | Yes | Unique action code | RBAC configuration |
| `resource` | Enum | Yes | Project, WBS, Task, Assignment, WeeklyUpdate, Evidence, RAID, People, RBAC, AuditLog | RBAC configuration |
| `action` | Enum | Yes | View, Create, Edit, Delete, Approve | RBAC configuration |

## Project

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `project_id` | UUID | Yes | Unique, immutable | Lean Project Control |
| `project_code` | String | Yes | Unique; RRMS for pilot | Project Master |
| `project_name` | String | Yes | 1-200 characters | Project Master |
| `portfolio_name` | String | No | 0-150 characters | Project Portfolio |
| `main_pm_person_id` | UUID | Yes | Must exist in People | Project Master |
| `project_status` | Enum | Yes | Draft, Active, OnHold, Completed, Cancelled, Deleted | Project Master |
| `start_date` | Date | No | ISO date | Project Master |
| `target_end_date` | Date | No | ISO date; must be >= start date when both exist | Project Master |
| `deleted_at` | DateTime | No | Required for soft-deleted records | System |
| `deleted_by_person_id` | UUID | No | Must be main PM at deletion time | System |

## Project Member

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `project_member_id` | UUID | Yes | Unique | Project membership |
| `project_id` | UUID | Yes | Must exist in Project | Project Master |
| `person_id` | UUID | Yes | Must exist in People | People Master |
| `project_role` | Enum | Yes | PM, ProjectAdmin, BALead, DEVLead, QALead, TeamMember, Reviewer | Project membership |
| `is_main_pm` | Boolean | Yes | Only one true per active project | Project Master |
| `active_from` | Date | No | ISO date | Project membership |
| `active_to` | Date | No | Must be >= active_from | Project membership |

## WBS Item

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `wbs_item_id` | UUID | Yes | Unique | WBS import / Project Admin |
| `project_id` | UUID | Yes | Must exist in Project | Project Master |
| `parent_wbs_item_id` | UUID | No | Must exist in same project | WBS import |
| `wbs_code` | String | Yes | Unique within project | WBS import |
| `wbs_name` | String | Yes | 1-200 characters | WBS import |
| `sort_order` | Number | No | >= 0 | WBS import |

## Task

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `task_id` | UUID | Yes | Unique | Task import / Project Admin |
| `project_id` | UUID | Yes | Must exist in Project | Project Master |
| `wbs_item_id` | UUID | Yes | Must exist in same project | WBS import |
| `parent_task_id` | UUID | No | Required for Task/Subtask when nested | Task import |
| `task_code` | String | Yes | Unique within project | Task import |
| `task_type` | Enum | Yes | MainTask, Task, Subtask | Task import |
| `task_name` | String | Yes | 1-300 characters | Task import |
| `owner_person_id` | UUID | Yes | Must exist in People and project membership | Task import |
| `start_date` | Date | No | ISO date | Task import |
| `due_date` | Date | No | Must be >= start_date when both exist | Task import |
| `status` | Enum | Yes | NotStarted, InProgress, OnHold, Blocked, Done, Cancelled | Task update |
| `weight` | Decimal | No | 0-100 | Task import |
| `progress` | Decimal | Yes | 0-100; Done requires 100 | Weekly update / Task update |
| `evidence_required` | Boolean | Yes | True or false | Task import |

## Task Assignee

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `task_assignee_id` | UUID | Yes | Unique | Assignment |
| `task_id` | UUID | Yes | Must exist in Task | Assignment |
| `person_id` | UUID | Yes | Must exist in People and Project Member | Assignment |
| `assignment_role` | Enum | Yes | Owner, BA, DEV, QA, Reviewer, Contributor, Observer | Assignment |
| `allocation_percent` | Decimal | No | 0-100 | Assignment |
| `is_primary` | Boolean | Yes | At most one primary per task and role where applicable | Assignment |

## Weekly Update

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `weekly_update_id` | UUID | Yes | Unique | Weekly update |
| `task_id` | UUID | Yes | Must exist in Task | Weekly update |
| `week_start_date` | Date | Yes | Must be configured week start date | Weekly update |
| `submitted_by_person_id` | UUID | Yes | Must be task assignee or authorized lead/admin | Weekly update |
| `progress` | Decimal | Yes | 0-100 | Weekly update |
| `status` | Enum | Yes | NotStarted, InProgress, OnHold, Blocked, Done, Cancelled | Weekly update |
| `summary` | Text | Yes | 1-2000 characters | Weekly update |
| `blocker` | Text | No | 0-2000 characters | Weekly update |
| `next_step` | Text | No | 0-2000 characters | Weekly update |
| `review_status` | Enum | Yes | Draft, Submitted, Reviewed, Rejected | Weekly update review |

## Evidence

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `evidence_id` | UUID | Yes | Unique | Evidence |
| `related_entity_type` | Enum | Yes | Project, WBS, Task, WeeklyUpdate, RAID | Evidence |
| `related_entity_id` | UUID | Yes | Must exist | Evidence |
| `file_name` | String | Yes | 1-255 characters | Evidence |
| `file_type` | String | No | Approved extension list in future design | Evidence |
| `storage_ref` | String | Yes | Storage pointer only; no credentials | Evidence storage |
| `uploaded_by_person_id` | UUID | Yes | Must exist in People | Evidence |
| `review_status` | Enum | Yes | Pending, Accepted, Rejected | Evidence review |

## RAID Item

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `raid_item_id` | UUID | Yes | Unique | RAID register |
| `project_id` | UUID | Yes | Must exist in Project | RAID register |
| `raid_code` | String | Yes | Unique within project | RAID register |
| `raid_type` | Enum | Yes | Risk, Assumption, Issue, Dependency | RAID register |
| `title` | String | Yes | 1-300 characters | RAID register |
| `description` | Text | No | 0-4000 characters | RAID register |
| `owner_person_id` | UUID | Yes | Must exist in Project Member | RAID register |
| `severity` | Enum | Yes | Low, Medium, High, Critical | RAID register |
| `status` | Enum | Yes | Open, Monitoring, Mitigated, Closed | RAID register |
| `due_date` | Date | No | ISO date | RAID register |

## Audit Log

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `audit_log_id` | UUID | Yes | Unique | System |
| `actor_person_id` | UUID | Yes | Must exist in People | System |
| `action` | String | Yes | Stable action code | System |
| `entity_type` | String | Yes | Audited entity name | System |
| `entity_id` | UUID | Yes | Audited entity ID | System |
| `before_snapshot` | JSON | No | Valid JSON | System |
| `after_snapshot` | JSON | No | Valid JSON | System |
| `reason` | Text | No | Required for project deletion | User / System |
| `occurred_at` | DateTime | Yes | System generated | System |

## Custom Field Definition

| Field | Data Type | Required | Validation | Source of Truth |
| --- | --- | --- | --- | --- |
| `custom_field_definition_id` | UUID | Yes | Unique | Platform configuration |
| `entity_type` | Enum | Yes | Project, WBS, Task, WeeklyUpdate, Evidence, RAID, People | Platform configuration |
| `field_key` | String | Yes | Unique per entity type | Platform configuration |
| `field_label` | String | Yes | 1-150 characters | Platform configuration |
| `field_type` | Enum | Yes | Text, Number, Date, Boolean, Select, MultiSelect | Platform configuration |
| `is_required` | Boolean | Yes | True or false | Platform configuration |
| `allowed_values` | JSON | No | Required for Select/MultiSelect | Platform configuration |
