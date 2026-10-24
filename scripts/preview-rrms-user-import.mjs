import fs from 'node:fs';
import path from 'node:path';
import Database from 'better-sqlite3';
import ExcelJS from 'exceljs';

const inputPath = process.argv[2];
const databasePath = process.argv[3] || path.resolve('data/lean-project-control.db');
if (!inputPath) {
  console.error('Usage: node scripts/preview-rrms-user-import.mjs <xlsx-path> [sqlite-path]');
  process.exit(1);
}

const workbook = new ExcelJS.Workbook();
await workbook.xlsx.readFile(inputPath);
const sheet = workbook.worksheets[0];
const headers = new Map();
sheet.getRow(1).eachCell((cell, column) => headers.set(String(cell.value || '').trim(), column));
const requiredHeaders = ['Pers.No.', 'Personnel Number', 'Employment Status', 'Role'];
for (const header of requiredHeaders) {
  if (!headers.has(header)) throw new Error(`Missing required column: ${header}`);
}

const db = new Database(databasePath, { readonly: true });
const lookup = db.prepare(`SELECT person_id, employee_code, display_name, email FROM people
  WHERE deleted_at IS NULL AND replace(ltrim(employee_code, '0'), '', '') = replace(ltrim(?, '0'), '', '')`);
const rows = [];
for (let rowNumber = 2; rowNumber <= sheet.rowCount; rowNumber += 1) {
  const row = sheet.getRow(rowNumber);
  const employeeCode = String(row.getCell(headers.get('Pers.No.')).value || row.getCell(headers.get('Personnel Number')).value || '').trim();
  const displayName = String(row.getCell(headers.get('Personnel Number')).value || '').trim();
  const employmentStatus = String(row.getCell(headers.get('Employment Status')).value || '').trim();
  const sourceRole = String(row.getCell(headers.get('Role')).value || '').trim();
  if (!employeeCode && !displayName) continue;
  const existing = lookup.get(employeeCode);
  const isPm = /\bPM(?:\/PMO)?\b|PMO/i.test(sourceRole);
  rows.push({
    rowNumber,
    employeeCode,
    displayName,
    employmentStatus,
    sourceRole,
    targetRole: isPm ? 'PM' : 'Member',
    action: existing ? 'Update existing user' : 'Create new user',
    existingUser: existing || null
  });
}
db.close();

const summary = rows.reduce((result, row) => {
  result.total += 1;
  result[row.targetRole] += 1;
  result[row.action === 'Update existing user' ? 'existing' : 'new'] += 1;
  return result;
}, { total: 0, PM: 0, Member: 0, existing: 0, new: 0 });
process.stdout.write(`${JSON.stringify({ inputPath, summary, rows }, null, 2)}\n`);
