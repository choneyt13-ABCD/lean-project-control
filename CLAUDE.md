# Claude Project Instructions

Use `AGENTS.md` as the primary repository operating guide and `DESIGN.md` as the architecture reference. These instructions add a compact working checklist for Claude-based agents.

## Working Context

- This repository is a working localhost feasibility walkthrough, not a production-ready application.
- Runtime stack: Node.js ES modules, Fastify, `better-sqlite3`, plain HTML/CSS/JavaScript, and `xlsx`.
- The current API is concentrated in `apps/api/server.js`; the browser application is concentrated in `apps/web/app.js`.
- SQLite under `data/` is the runtime path. PostgreSQL files describe the intended shared-pilot direction but are not connected to the current server.
- Requirements and `docs/api-contracts/openapi.yaml` contain target capabilities beyond the executable app. Label as-is and target-state claims clearly.

## Before Editing

1. Inspect `git status` and preserve unrelated user changes.
2. Read the closest requirements, data, and authorization documents for the feature.
3. Search for all API, UI, schema, seed, import, and test references before renaming a field or changing an invariant.
4. Prefer a small, coherent change over an unrelated refactor.

## Non-Negotiable Controls

- Do not expose the server beyond `127.0.0.1` while real authentication and authorization are absent.
- Never treat `DEMO_LOGIN_NAME`, `x-demo-login`, hidden UI controls, or a request-supplied person ID as authorization.
- Maintain project isolation and verify active membership for task owners and assignees.
- Keep `Done` and progress consistent, validate hierarchy and dates, and reject partial imports.
- Audit material mutations and keep audit records append-only.
- Keep secrets, personal data, databases, and uploaded files out of version control.
- Do not reset the local demo database without explicit user approval.

## Implementation Guidance

- Keep SQL parameterized and use transactions for related writes.
- Return predictable status codes and `{ "message": "..." }` errors.
- Add equivalent SQLite and PostgreSQL migrations when a persistent model change targets both paths.
- Update design/data/API documentation when a change alters a contract or architectural decision.
- Treat startup schema compatibility code as temporary; new schema evolution belongs in ordered migration files.
- Avoid introducing a frontend framework or major dependency unless the requested change justifies the migration cost.

## Done Means Verified

Run these from the repository root for code changes:

```powershell
npm run check
npm test
```

Add tests for changed behavior. For UI work, manually verify the affected browser flow and basic responsive/accessibility behavior. State clearly if any verification could not be completed.

