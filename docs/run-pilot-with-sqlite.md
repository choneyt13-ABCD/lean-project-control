# Run Feasibility Pilot with SQLite

This guide initializes a local SQLite database for the Lean Project Control feasibility pilot, then runs the local API and web walkthrough.

## Prerequisites

- SQLite CLI version 3.31 or later, available as `sqlite3`.
- PowerShell.
- The repository source files.

## Initialize the Local Database

Run from the `lean-project-control` repository root:

```powershell
New-Item -ItemType Directory -Force data
sqlite3 data/lean-project-control.db ".read database/sqlite/migrations/001_initial_schema.sql"
sqlite3 data/lean-project-control.db ".read database/sqlite/seeds/001_reference_data.sql"
sqlite3 data/lean-project-control.db ".tables"
```

Expected demo data includes the RRMS project and two non-personal records: `RRMS Demo PM` and `RRMS Demo BA`.

## Local Configuration

Create `.env` from `.env.example` and use SQLite as the feasibility default:

```text
DATABASE_PROVIDER=sqlite
DATABASE_URL=file:./data/lean-project-control.db
DEMO_LOGIN_NAME=rrms.demo.pm
ALLOW_DEMO_IDENTITY_OVERRIDE=false
```

The local API reads `DATABASE_URL`. Only a `file:` SQLite URL is supported by the current feasibility server.

`DEMO_LOGIN_NAME` selects an active seeded local account and is not a password login. Keep `ALLOW_DEMO_IDENTITY_OVERRIDE=false` during normal walkthroughs. Setting it to `true` permits the `x-demo-login` request header and is intended only for automated local authorization tests.

## Run the Walkthrough

From the repository root:

```powershell
npm install
npm start
```

Open `http://127.0.0.1:3000` in a browser. Use `npm test` to run the API smoke tests against an isolated temporary database; the tests do not modify `data/lean-project-control.db`.

## Safety and Operating Rules

- The `data/` directory is ignored by Git. Do not commit the database file.
- Do not put real passwords, tokens, or unapproved personal data in the database.
- Back up the file before schema experiments, imports, or changes to demo data.
- Do not use a shared network drive database file for multiple users. Move to PostgreSQL for shared concurrent pilot usage.
- The API/service must be the only component that opens the database once implementation begins.

## Reset Local Demo Data

Delete only the explicit local database file, then repeat initialization:

```powershell
Remove-Item -LiteralPath data/lean-project-control.db
```

This is a local feasibility reset only. Do not use this command against a shared pilot or any approved data environment.

## Move to PostgreSQL

Follow [Feasibility and Pilot Database Strategy](feasibility-pilot-database-strategy.md) when concurrent use, shared access, or stronger backup/operational controls are required.
