# Repository Guide for Coding Agents

## Purpose

Lean Project Control is a local feasibility application for project governance and delivery control. It currently provides a Fastify API, a static browser UI, and SQLite persistence for a single-user walkthrough. It is not yet a shared pilot or a production system.

Keep the distinction between the current implementation and the target design explicit. Requirements and OpenAPI documents describe capabilities that may not yet exist in `apps/`.

## Start Here

Before changing behavior, read the relevant sources in this order:

1. `README.md` and `docs/implementation-status.md` for current scope and known gaps.
2. `DESIGN.md` for the as-is architecture, boundaries, and invariants.
3. `docs/requirements/mvp-scope.md` and `docs/requirements/acceptance-criteria.md` for business intent.
4. `docs/rbac-matrix.md` and `docs/api-contracts/authorization-rules.md` for security rules.
5. `database/schema.md` and the matching migration files for data semantics.

When documents disagree with executable behavior, do not silently choose one. Preserve current behavior unless the task explicitly requests a change, and update the affected documentation or call out the discrepancy.

## Repository Map

- `apps/api/server.js` — Fastify server, SQLite access, validation, imports, auditing, and static-file hosting.
- `apps/web/` — framework-free HTML, CSS, and browser-side JavaScript.
- `tests/api-smoke.test.js` — end-to-end API smoke tests using an isolated temporary SQLite database.
- `database/sqlite/` — SQLite feasibility schema and seed data used by the running app.
- `database/migrations/` and `database/seeds/` — PostgreSQL target schema and reference data.
- `docs/` — requirements, controls, operating guides, data dictionary, and API contract drafts.
- `scripts/` — migration, workbook generation, inspection, conversion, and import utilities.
- `outputs/` — generated review workbooks and previews; treat them as artifacts, not source-of-truth application code.
- `infra/docker-compose.yml` — optional local PostgreSQL service; the current API does not use it.

## Commands

Run commands from the repository root:

```powershell
npm install
npm run check
npm test
npm start
```

The app listens on `http://127.0.0.1:3000` by default. It requires an initialized SQLite file. Follow `docs/run-pilot-with-sqlite.md` if the file is absent.

`npm test` is the preferred verification command because it creates and removes its own temporary database. Never point tests at the walkthrough database.

## Change Rules

- Keep the server bound to localhost until verified authentication, authorization, secrets, deployment, and shared-database controls exist.
- Treat the UI as presentation only. Permission and project-scope enforcement belongs in the API.
- Resolve the mutation actor from the request identity; never trust a client-supplied actor/person ID as proof of authority.
- Scope project data by the resolved project context. Do not allow cross-project task, WBS, member, assignment, update, or RAID references.
- Preserve business invariants: valid task hierarchy, active project membership for owners/assignees, valid dates and ranges, and `Done` implies 100% progress.
- Write a corresponding audit record for material creates, changes, deletes, imports, reviews, and uploads. Sensitive multi-write operations should be transactional.
- Prefer soft deletion where the schema already models `deleted_at`. Audit history is append-only.
- Validate every import row before committing; an invalid import must not partially mutate project data.
- Do not commit real credentials, tokens, personal data, `.env`, local database files, or uploaded attachments.
- Do not delete or recreate `data/lean-project-control.db` unless the user explicitly requests a local demo reset.

## Database Changes

SQLite is the executable feasibility path; PostgreSQL is the intended shared-pilot path. A schema change that applies to both must normally include equivalent, ordered migrations in:

- `database/sqlite/migrations/`
- `database/migrations/`

Update `database/schema.md` and `docs/data-dictionary.md` when entity semantics change. Do not rely on Docker restart to apply later PostgreSQL migrations. Avoid adding more startup-time schema mutation to `apps/api/server.js`; prefer versioned migrations and keep compatibility logic idempotent while it remains necessary.

## API and UI Conventions

- Follow the existing JSON error shape: `{ "message": "..." }`.
- Use `422` for business validation failures, `403` for an authenticated caller outside permission/scope, `401` for unresolved identity, and `404` for a missing scoped resource.
- Keep API field naming compatible with current consumers unless the task includes a coordinated migration.
- In browser-rendered HTML, escape or safely construct user-controlled content. Do not interpolate untrusted values into markup without sanitization.
- Preserve keyboard access, labels, focus behavior, readable contrast, and responsive layout when changing the UI.

## Verification Expectations

For code changes:

1. Run `npm run check`.
2. Run `npm test`.
3. Add or update a smoke test for changed API behavior, especially authorization, validation, transaction, audit, and project-scope rules.
4. For visible UI changes, run the walkthrough and inspect the affected flow at desktop and narrow widths.
5. Report any test not run and the reason.

Documentation-only changes do not require starting the server, but links, commands, filenames, current-state claims, and target-state claims must be checked against the repository.

## Known Security Boundary

The current `DEMO_LOGIN_NAME` mechanism is local identity selection, not authentication. `ALLOW_DEMO_IDENTITY_OVERRIDE=true` and the `x-demo-login` header are for isolated local tests only. Do not present the current role list or UI visibility as enforced RBAC. Consult `docs/implementation-status.md` before describing a feature as complete.

