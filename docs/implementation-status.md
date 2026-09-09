# Implementation Status

Last reviewed: 2026-08-30

## Current Stage

The repository is a working single-user feasibility walkthrough. It is suitable for validating screens, data shape, and basic RRMS workflows on localhost. It is not yet a shared or production pilot.

## Implemented

- Local Fastify API, static web UI, and SQLite persistence.
- RRMS project overview, WBS/task structure, weekly updates, RAID register, People Master, assignments, and Audit Log views.
- Audited create/update operations used by the walkthrough.
- Active RRMS project membership validation for task owners and assignees.
- Main Task > Task > Subtask parent validation within the same WBS.
- Task progress, weight, planned-date, and Done/100% validation.
- Atomic creation of a mock person and their RRMS project membership from the Admin workflow.
- Local request identity resolution from active `user_accounts`, exposed through `/api/session`.
- Request-actor ownership and Audit Log attribution instead of hard-coded mutation actors.
- Optional demo identity override guarded by an explicit environment flag for local tests only.
- Isolated API smoke tests that do not modify the local demo database.

## Remaining Before a Shared Pilot

1. Replace local placeholder identity selection with cryptographically verified authentication from the approved identity provider.
2. Approve and seed the final role-permission mappings, then enforce permission and data scope on every endpoint. Identity resolution is present, but it does not yet grant or deny endpoint access.
3. Add weekly update review/rejection and review-SLA behavior.
4. Implement Evidence metadata and Definition of Done enforcement after the evidence approval rule is confirmed.
5. Implement validated Excel import with an all-or-nothing transaction and row-level errors.
6. Move the shared pilot database to PostgreSQL and add migration, backup, secret, and deployment procedures.
7. Add browser-level workflow and accessibility tests before user acceptance testing.

## Decisions Still Required

- Identity provider and authenticated identity claims for the pilot.
- Final role-permission mapping and lead workstream boundaries.
- Evidence approver and acceptable review status for task completion.
- Weekly review SLA and reviewer selection.
- Import update/overwrite behavior.
