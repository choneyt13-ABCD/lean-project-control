import ExcelJS from 'exceljs';

const inputPath = process.argv[2];
const baseUrl = process.argv[3] || 'https://lean-project-api.onrender.com';
if (!inputPath) {
  console.error('Usage: node scripts/import-rrms-users.mjs <xlsx-path> [api-url]');
  process.exit(1);
}

const workbook = new ExcelJS.Workbook();
await workbook.xlsx.readFile(inputPath);
const sheet = workbook.worksheets[0];
const headers = new Map();
sheet.getRow(1).eachCell((cell, column) => headers.set(String(cell.value || '').trim(), column));
const get = (row, header) => String(row.getCell(headers.get(header)).value || '').trim();
const rows = [];
for (let rowNumber = 2; rowNumber <= sheet.rowCount; rowNumber += 1) {
  const row = sheet.getRow(rowNumber);
  const employeeCode = get(row, 'Pers.No.');
  const displayName = get(row, 'Personnel Number');
  const sourceRole = get(row, 'Role');
  if (!employeeCode || !displayName) continue;
  rows.push({
    employeeCode,
    displayName,
    projectRole: /\bPM(?:\/PMO)?\b|PMO/i.test(sourceRole) ? 'PM' : 'TeamMember'
  });
}

const results = [];
for (const row of rows) {
  const response = await fetch(`${baseUrl.replace(/\/$/, '')}/api/people`, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(row)
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(`${row.employeeCode}: ${body.message || response.statusText}`);
  results.push({ ...row, personId: body.personId });
}
console.log(JSON.stringify({ total: results.length, results }, null, 2));
