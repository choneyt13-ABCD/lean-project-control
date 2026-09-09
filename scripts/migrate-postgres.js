/**
 * scripts/migrate-postgres.js
 *
 * Applies all pending PostgreSQL schema migrations in order.
 *
 * Usage:
 *   DATABASE_URL=postgresql://user:pass@host/db node scripts/migrate-postgres.js
 *
 * The script tracks applied migrations in a schema_migrations table.
 * Already-applied migrations are skipped — safe to run repeatedly.
 */

import { readdir, readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import pg from 'pg';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const migrationsDir = path.join(root, 'database', 'migrations');

const databaseUrl = process.env.DATABASE_URL;
if (!databaseUrl || (!databaseUrl.startsWith('postgres://') && !databaseUrl.startsWith('postgresql://'))) {
  console.error('ERROR: Set DATABASE_URL=postgresql://user:pass@host/dbname before running this script.');
  process.exit(1);
}

const pool = new pg.Pool({ connectionString: databaseUrl });

async function run() {
  const client = await pool.connect();
  try {
    // Create migration tracking table if it does not exist.
    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        migration_id  serial PRIMARY KEY,
        filename      varchar(300) NOT NULL UNIQUE,
        applied_at    timestamptz  NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Discover migration files, sorted by filename (001_, 002_, …).
    const files = (await readdir(migrationsDir))
      .filter((f) => f.endsWith('.sql'))
      .sort();

    let applied = 0;
    let skipped = 0;

    for (const file of files) {
      const { rows } = await client.query(
        'SELECT 1 FROM schema_migrations WHERE filename = $1',
        [file],
      );
      if (rows.length) {
        console.log(`  skip  ${file} (already applied)`);
        skipped += 1;
        continue;
      }

      const sql = await readFile(path.join(migrationsDir, file), 'utf8');
      console.log(`  apply ${file} …`);
      await client.query('BEGIN');
      try {
        await client.query(sql);
        await client.query(
          'INSERT INTO schema_migrations (filename) VALUES ($1)',
          [file],
        );
        await client.query('COMMIT');
        console.log(`  done  ${file}`);
        applied += 1;
      } catch (err) {
        await client.query('ROLLBACK');
        console.error(`  FAIL  ${file}: ${err.message}`);
        throw err;
      }
    }

    console.log(`\nMigrations complete — ${applied} applied, ${skipped} skipped.`);
  } finally {
    client.release();
    await pool.end();
  }
}

run().catch((err) => {
  console.error('Migration failed:', err.message);
  process.exit(1);
});
