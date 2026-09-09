# RBAC Matrix

Phase 1 RBAC specification for Lean Project Control, using RRMS as the first pilot project.

This document defines intended permissions only. It does not implement authentication, authorization middleware, AD/SSO, or production user management.

## Roles

| Role | Scope | Purpose |
| --- | --- | --- |
| Platform Admin | Platform | Maintains platform setup, People Master, RBAC definitions, and global audit visibility. |
| PM/PMO | Portfolio / Project | Owns portfolio governance, creates projects, assigns the main PM, and reviews project control data. |
| Project Admin | Project | Maintains project master data, WBS, task structure, assignment, RAID, and reporting setup for assigned projects. |
| BA Lead | Project / Workstream | Leads BA workstream planning, task updates, evidence, and reviews within assigned scope. |
| DEV Lead | Project / Workstream | Leads development workstream planning, task updates, evidence, and reviews within assigned scope. |
| QA Lead | Project / Workstream | Leads QA workstream planning, task updates, evidence, and reviews within assigned scope. |
| Team Member | Assigned task | Works on assigned tasks/subtasks, submits weekly updates, and uploads evidence. |
| Reviewer | Project / Workstream | Reviews weekly updates, evidence, RAID, and delivery status without owning execution. |

## Permission Legend

| Code | Meaning |
| --- | --- |
| `V` | View |
| `C` | Create |
| `E` | Edit |
| `D` | Delete |
| `A` | Approve or review |
| `-` | No access by default |

## Role x Permission Matrix

| Area | Platform Admin | PM/PMO | Project Admin | BA Lead | DEV Lead | QA Lead | Team Member | Reviewer |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Project | V/C/E | V/C/E/D* | V/E | V | V | V | V assigned | V |
| WBS | V/C/E/D | V/C/E | V/C/E/D | V/C/E assigned | V/C/E assigned | V/C/E assigned | V assigned | V |
| Task | V/C/E/D | V/C/E | V/C/E/D | V/C/E assigned | V/C/E assigned | V/C/E assigned | V/E assigned | V |
| Assignment | V/C/E/D | V/C/E | V/C/E/D | V/C/E assigned | V/C/E assigned | V/C/E assigned | V assigned | V |
| Weekly Update | V | V/A | V/C/E/A | V/C/E/A assigned | V/C/E/A assigned | V/C/E/A assigned | V/C/E own | V/A |
| Evidence | V | V/A | V/C/E/A/D | V/C/E/A assigned | V/C/E/A assigned | V/C/E/A assigned | V/C/E own | V/A |
| RAID | V/C/E/D | V/C/E/A | V/C/E/D | V/C/E assigned | V/C/E assigned | V/C/E assigned | V/C assigned | V/A |
| People Master | V/C/E/D | V | V | V | V | V | V self | V |
| RBAC | V/C/E/D | V/E project | V project | - | - | - | - | V |
| Audit Log | V all | V project | V project | V assigned scope | V assigned scope | V assigned scope | - | V project |

`D*` for Project means project deletion is allowed only for the main PM of that project. Every deletion must create an Audit Log record with actor, timestamp, project identifier, reason, and before snapshot.

## Project Deletion Rule

- Only the main PM assigned to the project may delete a project.
- The user must provide a deletion reason.
- The system must create an Audit Log entry before or within the same transaction as deletion.
- Soft delete is preferred for MVP so project history, evidence references, and audit records remain traceable.
- Platform Admin can recover or administratively correct deleted records only if the future product decision allows it.

## Assignment Rules

- A task can have multiple assignees.
- Each assignee must reference a People Master record.
- Assignment role can be Owner, BA, DEV, QA, Reviewer, Contributor, or Observer.
- At least one Owner is required for each task imported or created in the MVP.
- Leads can manage assignments only within their assigned project or workstream scope.

## Audit Requirements

Audit Log must be created for:

- Project create, edit, delete, and restore.
- WBS, task, and assignment create, edit, delete.
- Weekly update create, edit, review, and approval.
- Evidence upload, review, rejection, and deletion.
- RAID create, edit, close, and reopen.
- People Master and RBAC changes.

## Open PM Decisions

- Confirm whether PM/PMO and Project Admin are separate people in RRMS or can be held by the same user.
- Confirm whether BA/DEV/QA Leads can delete tasks, or only mark tasks cancelled.
- Confirm whether Reviewer approval is mandatory before weekly status is finalized.
- Confirm soft delete retention policy.
