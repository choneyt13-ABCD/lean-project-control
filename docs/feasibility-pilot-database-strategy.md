# Feasibility and Pilot Database Strategy

## Purpose

Lean Project Control will begin as a feasibility and run-pilot tool for the IT team. The first goal is to validate the working process for Project, WBS, Task, multiple assignees, Weekly Update, Evidence metadata, RAID, and Audit Log before committing to a shared production-grade environment.

The same MVP scope and API contract apply throughout. Only the database deployment changes as usage grows.

## Recommended Evolution

```text
Feasibility / local pilot
Web and API -> SQLite file

Shared pilot
Web and API -> PostgreSQL on a team VM or managed cloud database

Production
Web and API -> PostgreSQL with secret management, backups, monitoring, and operational controls
```

## Phase A: SQLite Feasibility

SQLite is the default database choice while the IT team validates workflow with a small number of concurrent users.

### Appropriate Use

- Demonstrating and validating the RRMS pilot workflow.
- Developing the API and automated tests on one developer machine.
- Running a limited pilot on one machine or VM with low concurrent write activity.
- Testing Excel import, RBAC rules, task hierarchy, Weekly Update, RAID, and Audit Log behavior.

### Constraints

- SQLite is a single database file and has limited concurrent write capacity.
- It is not appropriate for many users updating tasks and Weekly Updates at the same time.
- Backups, access control, encryption, and recovery are the responsibility of the pilot environment.
- Do not place the SQLite file in a shared network folder as a multi-user database solution.

### SQLite Rules

- The Web application must access data only through the API. It must not open the SQLite file directly.
- The API or ORM creates UUID values; do not depend on PostgreSQL-only UUID functions.
- Store the SQLite database file outside source control, for example in a local `data/` directory ignored by Git.
- Do not store real passwords, tokens, or production personal data in the SQLite file or repository.
- Run migrations through a repeatable migration tool or script; do not manually alter the database file.

## Phase B: PostgreSQL Shared Pilot

Move to PostgreSQL when the pilot needs shared, concurrent usage, a central environment, stronger operational controls, or a VM/cloud deployment.

### Deployment Options

- PostgreSQL installed on a team-managed VM.
- PostgreSQL container managed by the infrastructure team.
- Managed PostgreSQL service in the selected cloud provider.

### Benefits

- Supports concurrent users and transactional updates more reliably than SQLite.
- Better fit for central backups, monitoring, access management, and recovery procedures.
- Supports the existing PostgreSQL design in `database/migrations/001_initial_schema.sql` and `database/seeds/001_reference_data.sql`.

### Required Controls Before Shared Pilot

- Use environment variables or a secret manager for connection credentials.
- Restrict database network access to the API/service environment.
- Define backup, restore, retention, and incident ownership.
- Run migration and seed scripts through a controlled release process.
- Use non-personal demo data until People Master data handling is approved.

## Portability Principles

To keep the move from SQLite to PostgreSQL low risk, implementation must follow these rules:

| Principle | Implementation direction |
| --- | --- |
| Single data boundary | Only the API/service accesses the database. |
| Stable identifiers | Create UUIDs in the application/ORM or use database-compatible UUID support. |
| Shared domain model | Keep entity names, API payloads, validation rules, and audit events independent of the database engine. |
| Separate migrations | Maintain a SQLite migration path for feasibility and PostgreSQL migration path for shared pilot. |
| Minimal database-specific logic | Put permission checks, hierarchy validation, dependency-cycle checks, and Definition of Done rules in the API/service layer. |
| Controlled configuration | Keep database URL, credentials, and storage location in local environment configuration, never source code. |

## Migration from SQLite to PostgreSQL

Do not copy a SQLite `.db` file into PostgreSQL. Use a controlled migration process instead.

1. Freeze writes to the SQLite pilot for the migration window.
2. Back up the SQLite file and record its version/checksum.
3. Run the approved PostgreSQL schema migration in the target VM/cloud environment.
4. Export data from SQLite in dependency order: reference data, People, roles/memberships, Projects, WBS, Tasks, assignments, updates, Evidence metadata, RAID, Change Requests, and Audit Logs.
5. Validate UUID references, unique project/task codes, project memberships, and row counts before importing into PostgreSQL.
6. Import data into PostgreSQL in the same dependency order.
7. Run reconciliation checks and obtain PM/IT sign-off before allowing new writes.
8. Keep the SQLite backup read-only for the agreed retention period.

## Pilot Exit Criteria

Move from SQLite to PostgreSQL when one or more of the following becomes true:

- More than one user needs to make regular concurrent updates.
- The RRMS pilot is accepted for a wider team or additional projects.
- The pilot requires a shared VM/cloud environment, scheduled backups, or centralized access control.
- Auditability and recovery requirements exceed the safeguards available for a local SQLite file.

## Open Decisions

- TODO (IT Owner): select the feasibility host machine/VM and SQLite file backup location.
- TODO (IT Owner): select the PostgreSQL target: team VM, container platform, or managed cloud service.
- TODO (PM/PMO): confirm when RRMS pilot data is approved to move from demo data to controlled People Master data.
- TODO (PM/PMO): confirm pilot exit criteria thresholds, especially expected concurrent users.
- TODO (Security/IT): confirm credential storage, network access, backup retention, and restore-test requirements for the shared pilot.
