# Acceptance Criteria

Phase 1 testable acceptance criteria for Lean Project Control MVP, using RRMS as the first pilot.

These criteria are written for later implementation and testing. Phase 1 only defines the expected behavior.

## Project

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-PROJ-001 | Create RRMS project | Given a user with PM/PMO permission, when they create project code `RRMS` with required Project Master fields, then the project is saved and an Audit Log entry is created. |
| AC-PROJ-002 | Prevent duplicate project code | Given project code `RRMS` already exists, when another project is created with code `RRMS`, then the system rejects it with a duplicate project code error. |
| AC-PROJ-003 | Delete project by main PM | Given the user is the main PM of RRMS, when they delete the project and provide a reason, then the project is soft-deleted and an Audit Log entry records actor, timestamp, reason, and project snapshot. |
| AC-PROJ-004 | Block project deletion by non-main PM | Given the user is not the main PM of RRMS, when they attempt to delete RRMS, then the system rejects the action and no project deletion occurs. |

## WBS and Task

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-TASK-001 | Create hierarchy | Given RRMS exists, when WBS, Main Task, Task, and Subtask records are created with valid parents, then the hierarchy is saved and can be retrieved in parent-child order. |
| AC-TASK-002 | Reject invalid parent | Given a Subtask references a missing parent Task, when the record is validated, then the system rejects it with a parent item not found error. |
| AC-TASK-003 | Reject circular hierarchy | Given imported rows create a circular parent-child reference, when validation runs, then the import fails with a circular reference error and no records are saved. |
| AC-TASK-004 | Validate progress | Given a task status is Done, when progress is less than 100, then validation fails. |

## Multiple Assignment

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-ASG-001 | Assign multiple people | Given a task exists in RRMS and three assignees exist as RRMS project members, when all three Person IDs are assigned, then all assignments are saved against the same task. |
| AC-ASG-002 | Reject unknown assignee | Given an Assignee Person ID does not exist in People Master, when assignment is saved or imported, then validation fails with unknown person error. |
| AC-ASG-003 | Reject non-member assignee | Given a person exists but is not an RRMS project member, when assigned to an RRMS task, then validation fails with person not project member error. |
| AC-ASG-004 | Require owner | Given a task has no Owner assignment, when validation runs, then validation fails with owner required error. |

## Weekly Update

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-WU-001 | Submit weekly update | Given a user is assigned to an RRMS task, when they submit week start date, progress, status, and summary, then the weekly update is saved with Submitted status and Audit Log is created. |
| AC-WU-002 | Block unauthorized update | Given a user is not assigned and has no lead/admin permission, when they submit a weekly update for the task, then the system rejects the action. |
| AC-WU-003 | Review weekly update | Given a Reviewer or authorized lead reviews a submitted weekly update, when they mark it Reviewed or Rejected, then review status is updated and Audit Log is created. |

## RBAC

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-RBAC-001 | Enforce People Master permission | Given a Team Member opens People Master, then they can view only allowed self/basic profile information and cannot create, edit, or delete People records. |
| AC-RBAC-002 | Enforce Project Admin scope | Given a Project Admin is assigned to RRMS, when they edit RRMS WBS/task data, then the change is allowed; when they edit another project without assignment, then the change is rejected. |
| AC-RBAC-003 | Enforce RBAC management | Given a non-Platform Admin user attempts to change platform role definitions, then the action is rejected. |
| AC-RBAC-004 | Audit RBAC changes | Given a Platform Admin changes a role or permission mapping, then an Audit Log entry is created. |

## Excel Import

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-IMP-001 | Validate complete import | Given a valid `wbs_task_import` sheet for RRMS, when validation runs, then validation succeeds with zero errors. |
| AC-IMP-002 | Save valid import | Given validation succeeds and the user confirms import, then WBS, Task, and Task Assignee records are created or updated according to the approved import behavior and Audit Log entries are created. |
| AC-IMP-003 | Return row-level errors | Given an import contains missing required fields, invalid dates, or unknown Person IDs, when validation runs, then the system returns row-level error messages with sheet, row, column, and reason. |
| AC-IMP-004 | No partial save on error | Given any validation error exists in the import file, when import is submitted, then no WBS, Task, or Assignment records are saved. |
| AC-IMP-005 | Support multiple assignees | Given `Assignee Person IDs` contains multiple semicolon-separated valid Person IDs, when import succeeds, then each Person ID becomes a task assignee. |

## Evidence

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-EVD-001 | Mark evidence required | Given a task has Evidence Required set to true, when the task is viewed or reported, then the evidence requirement is visible for follow-up. |
| AC-EVD-002 | Track evidence metadata | Given evidence metadata is added to a task or weekly update, then file name, storage reference, uploader, related entity, and review status are saved and audited. |

## RAID

| ID | Scenario | Acceptance Criteria |
| --- | --- | --- |
| AC-RAID-001 | Create RAID item | Given an authorized RRMS project role creates a Risk, Assumption, Issue, or Dependency, then the RAID item is saved and audited. |
| AC-RAID-002 | Close RAID item | Given an authorized owner closes a RAID item, then status becomes Closed and Audit Log records the change. |
