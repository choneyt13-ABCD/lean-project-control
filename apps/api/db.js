/**
 * apps/api/db.js — PostgreSQL query helper
 *
 * Exposes a thin async query() wrapper around pg.Pool so individual routes can
 * be migrated from better-sqlite3 to PostgreSQL one at a time.
 *
 * Usage (in a route handler):
 *   import { query, getPool } from './db.js';
 *   const rows = await query('SELECT * FROM tasks WHERE project_id = $1', [projectId]);
 *   // rows.rows — pg ResultSet rows array
 *
 * When DATABASE_PROVIDER is not 'postgres' the functions throw immediately so
 * accidental usage in SQLite mode fails fast rather than silently.
 */

const databaseProvider = (process.env.DATABASE_PROVIDER || 'sqlite').toLowerCase();

let _pool = null;

/**
 * Initialise the pool reference. Called by server.js after it creates pgPool.
 * @param {import('pg').Pool} pool
 */
export function setPool(pool) {
  _pool = pool;
}

/**
 * Return the active pg.Pool, or throw if not in postgres mode.
 * @returns {import('pg').Pool}
 */
export function getPool() {
  if (databaseProvider !== 'postgres' || !_pool) {
    throw new Error('getPool() called but DATABASE_PROVIDER is not postgres or pool is not initialised.');
  }
  return _pool;
}

/**
 * Run a parameterised SQL query against PostgreSQL.
 * Uses $1, $2, … placeholders (pg style, not ? SQLite style).
 *
 * @param {string} text  — SQL query string
 * @param {unknown[]} [params] — query parameters
 * @returns {Promise<import('pg').QueryResult>}
 */
export async function query(text, params) {
  return getPool().query(text, params);
}

/**
 * Execute a callback inside a single PostgreSQL transaction.
 * Rolls back automatically on error.
 *
 * @param {(client: import('pg').PoolClient) => Promise<T>} callback
 * @returns {Promise<T>}
 */
export async function withTransaction(callback) {
  const client = getPool().connect();
  try {
    await (await client).query('BEGIN');
    const result = await callback(await client);
    await (await client).query('COMMIT');
    return result;
  } catch (error) {
    await (await client).query('ROLLBACK');
    throw error;
  } finally {
    (await client).release();
  }
}
