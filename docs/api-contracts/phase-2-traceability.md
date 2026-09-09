# Phase 2 Traceability

This traceability check maps Phase 1 MVP requirements to the Phase 2 proposed tables/fields and OpenAPI operations. `Pass` means an explicit structure and contract exist. `Gap` marks an intentionally unresolved PM decision rather than an assumed business rule.

| Requirement | Table/Field supported | API supported | Status |
| --- | --- | --- | --- |
| Project Portfolio and Project Master | `projects.project_code`, `project_name`, `portfolio_name`, `main_pm_person_id`, `project_status`, `rag_status` | `GET/POST /projects`, `GET/PATCH /projects/{projectId}` | Pass |
| Project deletion only by Main PM with audit | `projects.deleted_at`, `deleted_by_person_id`, `deletion_reason`; `audit_logs` | `DELETE /projects/{projectId}` requires `reason`; scope requires active Main PM | Pass |
| People Master separate from login | `people`; `user_accounts.person_id`; no plaintext password field | `GET/POST /people`, `PATCH /people/{personId}` | Pass |
| RBAC and multiple roles per person | `roles`, `permissions`, `role_permissions`, `user_roles` | `GET/POST /roles`, `PUT /roles/{roleId}/permissions`, `POST /user-roles` | Pass |
| Project membership and task assignment | `project_members`, `task_assignments` with `assignment_role` and `raci_role` | `GET/POST /projects/{projectId}/members`, `GET/POST /tasks/{taskId}/assignments` | Pass |
| WBS, Main Task, Task, Subtask | `wbs_items`; `tasks.task_type`, `parent_task_id`, `wbs_item_id` | `GET/POST /projects/{projectId}/wbs`, `GET/POST /projects/{projectId}/tasks`, `PATCH /tasks/{taskId}` | Pass |
| Planned/actual dates, dependency, progress and evidence requirement | `tasks.planned_*`, `actual_*`, `progress`, `weight`, `evidence_required`; `task_dependencies` | Task create/update and `POST /tasks/{taskId}/dependencies` | Pass |
| Progress rollup formula | `tasks.weight`, `progress` | Readable through project/task endpoints | Gap - TODO (PM Decision): confirm formula, aggregation level, and rounding. |
| Definition of Done | `tasks.status`, `progress`, `evidence_required`, `reviewed_at`, `reviewed_by_person_id`; `evidence.review_status` | `PATCH /tasks/{taskId}`, evidence create/review endpoints | Gap - TODO (PM Decision): define final evidence review state and approver. |
| Weekly Update, RAG, review | `weekly_updates.rag_status`, `review_status`, reviewer fields | `POST /tasks/{taskId}/weekly-updates`, `POST /weekly-updates/{weeklyUpdateId}/review` | Pass |
| Weekly review SLA | `weekly_updates.review_status` includes `OverdueReview` | Review endpoint exists | Gap - TODO (PM Decision): configure SLA duration and assigned reviewer rule. |
| Evidence metadata without binary files | `evidence` metadata and credential-free `storage_ref` | `POST /evidence`, `POST /evidence/{evidenceId}/review` | Pass |
| RAID scoring, mitigation, escalation trigger | `raid_items.probability`, `impact`, generated `severity_score`, `mitigation_plan`, `escalation_trigger_score`; `risk_levels` | `GET/POST /projects/{projectId}/raid-items`, `PATCH /raid-items/{raidItemId}` | Pass |
| Escalation matrix/notification | No automated notification tables are proposed; manual escalation is MVP scope | No notification endpoint | Pass - explicitly out of scope for automation; TODO (PM Decision): thresholds and recipients. |
| Change Control and baseline versioning | `change_requests`, `baseline_versions.snapshot` | Change Request list/create/decision endpoints | Pass |
| Change approval governance | `change_requests.approver_person_id`, `approval_status` | `POST /change-requests/{changeRequestId}/decision` | Gap - TODO (PM Decision): confirm approver role and controlled fields. |
| Audit Log | Append-only `audit_logs`, before/after JSON snapshots, reason | `GET /audit-logs`; no write endpoint | Pass |
| Excel WBS/Task import validation | Existing WBS/task/assignment tables; no persistence during validation | `POST /projects/{projectId}/imports/wbs-tasks/validate` | Pass |
| Existing-record import behavior | Existing unique keys support detection | Validation endpoint returns errors only | Gap - TODO (PM Decision): reject, update, or preview-and-confirm. |
