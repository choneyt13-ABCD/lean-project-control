# Authorization Rules and Data Scope

Phase 2 authorization rules for the RRMS pilot. Every API must authenticate the caller, resolve assigned roles, then enforce both permission and data scope before reading or changing data. The web UI may hide unavailable controls but is never the authorization boundary.

## Enforcement Model

1. Resolve the caller from `user_accounts` to `people`.
2. Resolve all active `user_roles`, `role_permissions`, and `project_members` records.
3. Check the requested resource/action permission.
4. Check the target project, workstream, task assignment, and ownership scope.
5. Validate business invariants, then write the data change and required Audit Log entry in one transaction.
6. Return `403` for denied permission/scope and `422` for a valid caller whose requested change violates a business validation rule.

No endpoint may rely on a front-end role flag, hidden button, client-provided `personId`, or client-provided `projectId` as proof of authority.

## Role Rules

| Role | Permission and data scope |
| --- | --- |
| Platform Admin | Manages People Master and platform RBAC; has global audit visibility. Project deletion is still restricted to the project's active Main PM. |
| PM/PMO | Creates and governs portfolio/projects, assigns Main PM, and views/reviews project control data within portfolio/project scope. Can delete only where the caller is that project's Main PM. |
| Project Admin | Maintains Project, WBS, Task, Assignment, RAID, and reporting setup only in projects where they are an active member. |
| BA Lead | Creates/edits WBS, Task, Assignment, Weekly Update, Evidence, and RAID only in assigned project/workstream scope. |
| DEV Lead | Creates/edits WBS, Task, Assignment, Weekly Update, Evidence, and RAID only in assigned project/workstream scope. |
| QA Lead | Creates/edits WBS, Task, Assignment, Weekly Update, Evidence, and RAID only in assigned project/workstream scope. |
| Team Member | Views assigned work, edits permitted assigned tasks, submits own Weekly Updates, and manages Evidence metadata for own assigned tasks. Cannot manage People Master or platform RBAC. |
| Reviewer | Views permitted project/workstream data and reviews Weekly Updates, Evidence, RAID, and delivery status. Does not gain execution ownership from reviewer access. |

The detailed resource/action matrix remains the source of truth: [RBAC Matrix](../../rbac-matrix.md).

## Special Rules

### Project deletion

- Require `project.delete` permission **and** confirm that `projects.main_pm_person_id` equals the authenticated caller's `person_id` and that the caller is an active `project_members.is_main_pm = true` member.
- The `DELETE /projects/{projectId}` request body requires a non-empty `reason`.
- Perform a soft delete and create an Audit Log record with the actor, timestamp, project ID, reason, and before snapshot in the same transaction.
- Platform Admin, PM/PMO, and Project Admin cannot bypass the Main PM condition merely because they hold a higher role.

### Project and task scope

- A person referenced as task owner or assignee must be an active project member of the task project.
- Lead access is bounded by active project membership and assigned workstream/task scope. **TODO (PM Decision):** define the authoritative workstream-to-WBS/task mapping.
- Team Member access is bounded to an active `task_assignments` record; self-service access does not permit editing a colleague's assignment.
- Reviewer access permits review, not automatic edit/delete rights.

### Baseline, change, and completion

- A task marked `Done` must have `progress = 100`.
- For evidence-required tasks, completion must also satisfy evidence/review conditions. **TODO (PM Decision):** confirm acceptable review status and final approver role.
- Baseline-controlled changes must be represented by a Change Request. **TODO (PM Decision):** confirm controlled field list, approval authority, and enforcement point.

### Audit and sensitive actions

- Audit creates, edits, deletes, approvals, rejections, evidence metadata actions, and imports as defined in the RBAC Matrix.
- Audit Log is append-only. No standard API exposes create, update, or delete operations for it.
- Filter audit visibility by the caller's project/task scope; Team Member has no default Audit Log access.

## Open PM Decisions Carried into the API

- Confirm final BA/DEV/QA/Reviewer/Team Member role mapping and whether Leads may delete tasks or only cancel them.
- Confirm weekly update review SLA, assigned lead selection, and whether reviewer approval is mandatory.
- Confirm RAG status definitions and risk score threshold that triggers manual escalation.
- Confirm progress-rollup weight rules and dashboard calculation ownership.
- Confirm import behavior for existing WBS/Task records.
- Confirm evidence retention and review requirements.
- Confirm Change Request requestor/approver roles, baseline approval authority, and baseline-controlled fields.
