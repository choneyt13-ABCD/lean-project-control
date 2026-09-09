# lean-project-control

Lean Project Control is an initial monorepo scaffold for project governance, task tracking, weekly reporting, evidence management, RAID tracking, and auditability.

This repository contains the initial project specification and a single-user local walkthrough. The walkthrough is intentionally limited to one demo PM identity on `localhost`; it is not a multi-user pilot, authentication implementation, GitLab integration, Active Directory integration, or production deployment.

## Folder Responsibilities

| Path | Responsibility |
| --- | --- |
| `AGENTS.md` | Repository-wide operating instructions for Codex and other coding agents, including safety rules and verification expectations. |
| `CLAUDE.md` | Claude-specific project context and implementation checklist; delegates shared rules to `AGENTS.md`. |
| `DESIGN.md` | Current and target architecture, domain boundaries, data flow, invariants, security posture, and recommended evolution path. |
| `apps/web` | Future frontend application for project control users, project teams, and administrators. |
| `apps/api` | Future backend API application for business workflows, authorization checks, imports, reports, and audit logging. |
| `packages/contracts` | Shared API contracts, DTO definitions, validation schemas, and event contract definitions when implementation begins. |
| `packages/ui` | Shared frontend UI components, design tokens, and layout primitives when implementation begins. |
| `database/migrations` | Versioned PostgreSQL schema migrations for local development and later implementation. |
| `database/seeds` | Non-sensitive reference and demo seed data for local development/testing. Passwords and production data must not be stored here. |
| `database/sqlite` | SQLite migrations and seed data for the local feasibility pilot. |
| `docs/requirements` | Requirement notes, workflow definitions, business rules, and acceptance criteria. |
| `docs/api-contracts` | API contract drafts and integration notes. |
| `docs/rbac-matrix.md` | Starter role-based access control matrix covering People Master, AD/SSO, project hierarchy, updates, evidence, RAID, and audit logs. |
| `docs/data-dictionary.md` | Starter data dictionary for core business entities and relationships. |
| `docs/import-template-spec.md` | Starter Excel import template specification for master data and project task structure. |
| `infra/docker-compose.yml` | Local PostgreSQL development environment. It reads migration/seed files only during first database initialization. |
| `.gitlab-ci.yml` | Placeholder GitLab CI pipeline definition for future validation steps. |

## Current Scope

- Git repository initialized with `git init`.
- Monorepo folder structure created.
- Phase 1 and Phase 2 specifications, initial PostgreSQL schema, seed data, and OpenAPI contract created.
- A local Fastify API and static web UI are available for a single-user walkthrough using the SQLite feasibility database.
- The walkthrough displays Project Overview, Work Breakdown, Weekly Updates, RAID Register, and Activity Log. It records demo changes in the local SQLite database and Audit Log.
- Task creation now validates WBS ownership, active project membership, parent hierarchy, dates, weight, and progress. Assignment creation rejects people who are not active RRMS project members.
- Automated API smoke tests run against an isolated temporary database with `npm test`.
- It resolves a configured active local demo account and records that actor in audit events, but has no real login or authorization enforcement. The default `RRMS Demo PM` identity is only for local demo use.
- No AD/SSO connection, GitLab connection, shared deployment, or production secret handling has been implemented.

## Run the Single-User Walkthrough

Run this from the repository root after the SQLite database has been initialized:

```powershell
npm install
npm start
```

Open `http://127.0.0.1:3000`. The first launch creates non-personal WBS and Task demo data only when the RRMS WBS is empty. The UI is deliberately bound to localhost and must not be treated as a shared pilot environment.

## Local PostgreSQL

The local database is optional until API implementation starts. It runs PostgreSQL 16 in Docker and initializes the schema and non-personal RRMS demo data on its first start.

1. Install and start Docker Desktop.
2. Create `lean-project-control/.env` from `.env.example` and set a local development-only `POSTGRES_PASSWORD`.
3. Run `docker compose --env-file .env -f infra/docker-compose.yml up -d` from `lean-project-control`.
4. Confirm health with `docker compose --env-file .env -f infra/docker-compose.yml ps`.

The mounted initialization SQL runs only for a new Docker volume. To apply future migrations, use a migration runner in the API/application workflow; do not assume restarting the container re-runs them.

## SQLite Feasibility Pilot

SQLite is the default local path for feasibility validation before shared pilot deployment. See [Run Feasibility Pilot with SQLite](docs/run-pilot-with-sqlite.md) for initialization and operating rules, and [Feasibility and Pilot Database Strategy](docs/feasibility-pilot-database-strategy.md) for the planned move to PostgreSQL.

See [Implementation Status](docs/implementation-status.md) for completed controls, remaining pilot gaps, and the recommended implementation order.

## Security Notes

- Do not commit real passwords, API keys, certificates, tokens, connection strings, or personal credentials.
- Use environment variables or a secret manager for future runtime configuration.
- Keep production data out of seed files and test fixtures unless it has been approved and anonymized.

## Domain Coverage Planned

The documentation is prepared for these future capabilities:

- People Master
- AD/SSO identity mapping
- RBAC and permission governance
- Project, WBS, Main Task, Task, and Subtask hierarchy
- Multiple assignees per task
- Weekly Update workflow
- Evidence attachment and review
- RAID management
- Audit Log
