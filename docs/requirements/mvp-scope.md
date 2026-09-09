# MVP Scope (v2 — Compiled with PM Governance Standard)

Phase 1 Foundation Specifications for Lean Project Control, using RRMS as the first pilot project.

This scope defines the first functional boundary to guide requirements, contracts, data design, and later implementation. No website, backend, database, authentication, or deployment is built in this phase.

**Document Control**

| Version | Date | Changed By | Change Summary |
| --- | --- | --- | --- |
| v1 | - | - | Initial MVP scope |
| v2 | (fill date) | (fill name) | Added Governance, Schedule Baseline, Change Control, Risk Scoring, Reporting Standard, KPI, Definition of Done |

## Pilot

| Item | Decision |
| --- | --- |
| Pilot project | RRMS |
| Primary users | PM/PMO, Project Admin, BA Lead, DEV Lead, QA Lead, Team Member, Reviewer |
| Primary objective | Establish controlled project structure, ownership, status updates, evidence tracking, RAID, and auditability. |

## In Scope

### Project Portfolio / Project Master

- Maintain a portfolio-level view of projects.
- Maintain Project Master data for RRMS.
- Identify the main PM for each project.
- Track project status, target dates, and ownership.
- Allow project deletion only by the main PM of the project with Audit Log.
- **[NEW] Portfolio Dashboard**: single-page summary across all projects showing overall RAG status, % complete, and open high-severity RAID items.

### Governance & Escalation *(NEW)*

- Define Steering Committee / Sponsor role for cross-project decisions and scope conflicts.
- Define meeting cadence: weekly team stand-up (task-level), biweekly steering review (portfolio-level).
- Define Escalation Matrix: severity level -> who is notified -> response time SLA (e.g., High severity RAID item -> escalate to main PM within 24 hours).

### People Master

- Maintain people records independently from login accounts.
- Store person identity, employee code, display name, email, department, title, and status.
- Use People Master as the reference for project members, task owners, task assignees, reviewers, and audit actors.

### RBAC and Project/Task Assignment

- Define roles: Platform Admin, PM/PMO, Project Admin, BA Lead, DEV Lead, QA Lead, Team Member, Reviewer.
- Apply permissions by role, project membership, task assignment, and workstream responsibility.
- Support Project Member records.
- Support task assignment to multiple people.
- Track assignment role such as Owner, BA, DEV, QA, Reviewer, Contributor, and Observer.
- **[NEW] RACI overview**: map each role to Responsible / Accountable / Consulted / Informed at the deliverable level (not just task assignment role).

### WBS > Main Task > Task > Subtask

- Support RRMS delivery hierarchy from WBS to Main Task, Task, and Subtask.
- Support parent-child relationships.
- Validate hierarchy consistency and prevent circular references.
- Track task status, planned dates, due dates, weight, progress, and evidence requirement.
- **[NEW] Actual Start Date / Actual Finish Date**, in addition to planned dates, to support baseline variance analysis.
- **[NEW] Task Dependency (Predecessor/Successor)**: separate from parent-child hierarchy, to represent sequencing/blocking relationships between tasks.
- **[NEW] Progress rollup rule**: define the weighted-average formula used to roll up % complete from Subtask -> Task -> Main Task -> WBS -> Project, using the existing weight field.
- **[NEW] Definition of Done**: a task cannot be marked complete unless required evidence is uploaded (where `evidence_required = true`) and status has been reviewed/approved.

### Multiple People per Task

- Allow one task or subtask to have multiple assignees.
- Require assignees to exist in People Master.
- Require assignees to be members of the RRMS project.
- Allow different assignment roles on the same task.

### Weekly Update

- Capture weekly progress against tasks or subtasks.
- Track submitted by, week start date, progress, status, summary, blocker, next step, and review status.
- Allow assigned users and authorized leads/admins to submit or review updates.
- **[NEW] RAG Status field**: Red / Amber / Green, self-assessed by submitter, used consistently across all weekly reporting and dashboards.
- **[NEW] Review SLA**: weekly updates must be reviewed by the assigned lead within a defined window (e.g., 2 business days) or auto-flag as overdue-review.

### Evidence

- Track evidence metadata against project, WBS, task, weekly update, or RAID item.
- Support evidence required flag on tasks.
- Track upload actor, storage reference, file name, and review status.
- Do not store real credentials in evidence storage references.

### RAID

- Track Risk, Assumption, Issue, and Dependency items.
- Track title, description, owner, severity, due date, and status.
- Allow authorized project roles to create, update, review, and close RAID items.
- **[NEW] Risk scoring matrix**: severity derived from Probability x Impact (e.g., 1-5 scale each), not a free-text label.
- **[NEW] Mitigation Plan field** and **Escalation Trigger** (severity threshold that forces notification per the Escalation Matrix).

### Change Control *(NEW)*

- Maintain a Change Request (CR) log for any change to approved scope, due dates, weight, or ownership after baseline is set.
- Track: requested by, date, change type, reason, impact analysis, approval status, approver.
- Project Master and WBS baseline should be versioned once approved, so history of change is preserved.

### Audit Log

- Track important create, edit, delete, approve, reject, upload, and import events.
- Include actor, action, entity, timestamp, before/after snapshots where appropriate, and reason for sensitive actions.
- Project deletion must always create an Audit Log entry.

### KPI / Metrics *(NEW)*

- Define a standard KPI set applied consistently across all projects in the portfolio:
  - Schedule Variance (Planned % complete vs Actual % complete)
  - On-time task completion rate
  - Overdue task count (open tasks past due date)
  - Evidence compliance rate (% of evidence-required tasks with evidence uploaded)
  - Weekly Update submission rate and review SLA compliance

### Excel Import for WBS/Task/Subtask

- Provide an Excel import specification for RRMS WBS and task hierarchy.
- Required import support includes Main Task, Task, Subtask, Parent WBS, Owner Person ID, Assignee Person IDs, Role, Start Date, Due Date, Status, Weight, Progress, and Evidence Required.
- Validate all rows before saving.
- Return row-level error messages.

## Out of Scope

- GitLab integration.
- Real AD/SSO integration.
- Real password login or password storage.
- Production deployment.
- Database implementation and migrations.
- Web UI implementation.
- API implementation.
- Binary evidence file upload.
- Notification workflow (automated alerts) - escalation matrix above is a manual process for MVP.
- Timesheet or cost management.
- Automated dependency scheduling (critical path auto-calculation) - dependency data is tracked, but scheduling engine is out of scope for MVP.

## Assumptions

- RRMS Project Master exists before WBS/task import.
- People Master records exist before assignment import.
- PM/PMO confirms final role behavior before implementation.
- Soft delete is preferred for project deletion unless PM decides otherwise.
- Weekly reporting cadence and escalation SLAs are defined by PM/PMO before rollout to other projects.

## Open PM Decisions

- Confirm RRMS project code and official project name.
- Confirm main PM for RRMS.
- Confirm final role mapping for BA, DEV, QA, Reviewer, and Team Member.
- Confirm whether WBS/task import can update existing records.
- Confirm evidence retention and review requirements.
- Confirm escalation SLA thresholds (severity -> response time).
- Confirm the weighted-average formula for progress rollup.
- Confirm RAG status definitions (what counts as Amber vs Red).
