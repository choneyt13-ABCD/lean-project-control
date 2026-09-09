import fs from 'node:fs/promises';
import { SpreadsheetFile, Workbook } from '@oai/artifact-tool';

const sourcePath = 'D:/project/MVP Project/lean-project-control/outputs/rrms-plan-review/source-values.json';
const outputDir = 'D:/project/MVP Project/lean-project-control/outputs/rrms-hierarchical-review';
const outputPath = `${outputDir}/RRMS_Hierarchical_Project_Plan_Review.xlsx`;
const source = JSON.parse(await fs.readFile(sourcePath, 'utf8'));
const rawRows = source.slice(3).filter((row) => row[3]);
const wb = Workbook.create();
const c = { ink: '#173B2C', pale: '#EAF2E7', lime: '#B7DC76', line: '#DCE5DC', phaseA: '#78868A', phaseB: '#C75A00', phaseC: '#5E8934', phaseD: '#C49200', phaseE: '#347AB5', phaseF: '#EE822A', phaseG: '#7C5AA6', phaseH: '#4C8F91', body: '#F7FBF5' };
const header = { fill: c.ink, font: { bold: true, color: '#FFFFFF' }, wrapText: true, horizontalAlignment: 'center', verticalAlignment: 'center' };
const phaseColors = [c.phaseA, c.phaseB, c.phaseC, c.phaseD, c.phaseE, c.phaseF, c.phaseG, c.phaseH];

function serialToDate(value) {
  if (typeof value !== 'number') return null;
  const utc = new Date(Date.UTC(1899, 11, 30) + value * 86400000);
  return utc.toISOString().slice(0, 10);
}
function statusMap(value) {
  return ({ 'เสร็จแล้ว': 'Done', 'กำลังดำเนินการ': 'InProgress', 'ยังไม่เริ่ม': 'NotStarted' })[String(value || '').trim()] || 'NotStarted';
}
function progressFor(status) { return status === 'Done' ? 100 : status === 'InProgress' ? 50 : 0; }
function priorityMap(value) { return String(value || '').includes('วิกฤต') || String(value || '').includes('สูง') ? 'High' : String(value || '').includes('ปานกลาง') ? 'Medium' : 'Low'; }
function title(sheet, text, subtitle, endColumn) {
  sheet.mergeCells(`A1:${endColumn}1`);
  sheet.getRange('A1').values = [[text]];
  sheet.getRange('A1').format = { fill: c.ink, font: { bold: true, color: '#FFFFFF', size: 17 }, verticalAlignment: 'center' };
  sheet.getRange('A1').format.rowHeight = 32;
  sheet.mergeCells(`A2:${endColumn}2`);
  sheet.getRange('A2').values = [[subtitle]];
  sheet.getRange('A2').format = { fill: c.pale, font: { italic: true, color: '#587061' }, wrapText: true, verticalAlignment: 'center' };
  sheet.getRange('A2').format.rowHeight = 27;
  sheet.showGridLines = false;
}

const planRows = [];
let phaseIndex = 0;
let currentPhase = null;
let mainCounter = 0;
let taskCounter = 0;
let currentTaskNo = null;
for (const row of rawRows) {
  const [sequence, coreFunction, level, wbsCode, subFunction, deliverables, role, owner, start, due, duration, dependencies, sourceStatus, risk, riskNotes] = row;
  if (coreFunction) {
    phaseIndex += 1;
    currentPhase = String(phaseIndex);
    mainCounter = 0;
    taskCounter = 0;
    planRows.push({ kind: 'phase', color: phaseColors[(phaseIndex - 1) % phaseColors.length], values: ['Phase', currentPhase, '', coreFunction, '', '', '', serialToDate(start), serialToDate(due), statusMap(sourceStatus), progressFor(statusMap(sourceStatus)), priorityMap(risk), 'FALSE', wbsCode, 'Phase created from Core Function'] });
  }
  const mappedStatus = statusMap(sourceStatus);
  let levelLabel = 'Task'; let taskNo; let parentNo = currentPhase || '';
  if (Number(level) === 1) {
    mainCounter += 1;
    taskCounter = 0;
    taskNo = `${currentPhase}.${mainCounter}`;
    parentNo = currentPhase;
    levelLabel = 'Main Task';
  } else if (Number(level) === 2) {
    taskCounter += 1;
    taskNo = `${currentPhase}.${mainCounter}.${taskCounter}`;
    parentNo = `${currentPhase}.${mainCounter}`;
    levelLabel = 'Task';
  } else {
    taskNo = `${currentTaskNo || `${currentPhase}.${mainCounter}.${Math.max(taskCounter, 1)}`}.1`;
    parentNo = currentTaskNo || `${currentPhase}.${mainCounter}.${Math.max(taskCounter, 1)}`;
    levelLabel = 'Subtask';
  }
  currentTaskNo = taskNo;
  const notes = [
    deliverables ? `Deliverables: ${deliverables}` : '',
    role ? `Responsible roles: ${role}` : '',
    dependencies ? `Dependencies: ${dependencies}` : '',
    risk ? `Risk: ${risk}` : '',
    riskNotes ? `Risk notes: ${riskNotes}` : ''
  ].filter(Boolean).join('\n');
  planRows.push({ kind: 'item', values: [levelLabel, taskNo, parentNo, subFunction || wbsCode, owner || '', '', duration || '', serialToDate(start), serialToDate(due), mappedStatus, progressFor(mappedStatus), priorityMap(risk), String(risk || '').includes('สูง') || String(risk || '').includes('วิกฤต') ? 'TRUE' : 'FALSE', wbsCode, notes] });
}

const plan = wb.worksheets.add('Project plan');
title(plan, 'RRMS — Project Plan Import (Review)', 'Converted from RRMS_Project_Plan. Review hierarchy and Person IDs before any future import.', 'O');
plan.getRange('A4:O4').merge();
plan.getRange('A4').values = [['Project information — review or change these values before importing']];
plan.getRange('A4').format = { fill: '#DDEBDD', font: { bold: true, color: c.ink } };
plan.getRange('A5:H5').values = [['Project Code*', 'Project Name*', 'Project Type*', 'Project Size*', 'Portfolio', 'Main PM Person ID*', 'Start Date', 'Target End Date']];
plan.getRange('A5:H5').format = header;
plan.getRange('A6:H6').values = [['RRMS', 'Rama Research Management System', 'New', 'Large', 'Rama Research', 'DEMO-RRMS-PM', '2026-01-01', '2027-06-30']];
plan.getRange('A6:H6').format = { fill: '#FFF8E3', font: { color: '#725B16' }, wrapText: true };
plan.getRange('A5:H6').format.borders = { preset: 'all', style: 'thin', color: c.line };
plan.getRange('G6:H6').format.numberFormat = 'yyyy-mm-dd';
plan.getRange('A8:O8').merge();
plan.getRange('A8').values = [[`Converted work plan — ${rawRows.length} source items mapped into ${planRows.length} hierarchy rows`]];
plan.getRange('A8').format = { fill: '#DDEBDD', font: { bold: true, color: c.ink } };
plan.getRange('A9:O9').values = [['Level*', 'Task No.*', 'Parent No.', 'Task Title*', 'Task Owner(s)', 'Assignee Person IDs', 'Duration\n(days)', 'Start Date', 'Due Date', 'Status*', 'Progress\n%', 'Priority', 'Evidence\nrequired', 'WBS Code', 'Notes']];
plan.getRange('A9:O9').format = header;
plan.getRange('A9:O9').format.rowHeight = 32;
const values = planRows.map((record) => record.values);
const lastRow = 9 + values.length;
plan.getRange(`A10:O${lastRow}`).values = values;
plan.getRange(`A10:O${lastRow}`).format = { fill: c.body, wrapText: true, verticalAlignment: 'center' };
plan.getRange(`A10:O${lastRow}`).format.borders = { insideHorizontal: { style: 'thin', color: '#E2EAE0' }, insideVertical: { style: 'thin', color: '#E2EAE0' }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
planRows.forEach((record, index) => {
  if (record.kind === 'phase') plan.getRange(`A${10 + index}:O${10 + index}`).format = { fill: record.color, font: { bold: true, color: '#FFFFFF' }, wrapText: true, verticalAlignment: 'center' };
});
plan.getRange(`A10:O${lastRow}`).format.rowHeight = 31;
plan.getRange(`H10:I${lastRow}`).format.numberFormat = 'yyyy-mm-dd';
plan.getRange(`G10:G${lastRow}`).format.numberFormat = '0';
plan.getRange(`K10:K${lastRow}`).format.numberFormat = '0';
['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'].forEach((col, index) => { plan.getRange(`${col}:${col}`).format.columnWidth = [14,13,13,38,23,24,12,14,14,15,11,12,14,17,46][index]; });
plan.freezePanes.freezeRows(9);

const review = wb.worksheets.add('Conversion notes');
title(review, 'Conversion notes — review before import', 'This sheet records assumptions made while mapping the source RRMS plan to the new hierarchy.', 'F');
review.getRange('A4:B9').values = [
  ['Source rows converted', rawRows.length],
  ['Phase headings created', phaseIndex],
  ['Hierarchy mapping', 'Core Function → Phase; source level 1 → Main Task; level 2 → Task; level 3 → Subtask'],
  ['Status mapping', 'เสร็จแล้ว → Done; กำลังดำเนินการ → InProgress; ยังไม่เริ่ม → NotStarted'],
  ['Progress assumption', 'Done = 100%; InProgress = 50%; NotStarted = 0%'],
  ['Person ID handling', 'Task Owner(s) retains names from source; Assignee Person IDs remain blank to avoid guessing master IDs.']
];
review.getRange('A4:B9').format = { borders: { preset: 'all', style: 'thin', color: c.line }, wrapText: true, verticalAlignment: 'center' };
review.getRange('A4:A9').format = { fill: c.lime, font: { bold: true, color: c.ink } };
review.getRange('A4:B9').format.rowHeight = 34;
review.getRange('A:A').format.columnWidth = 24;
review.getRange('B:B').format.columnWidth = 110;
review.getRange('A12:F12').merge();
review.getRange('A12').values = [['Items requiring your confirmation']];
review.getRange('A12').format = { fill: '#FFF3D1', font: { bold: true, color: '#715A13' } };
review.getRange('A13:B16').values = [
  ['1', 'Confirm the Project info in Project plan row 6, especially Project Type, Size, Portfolio, Main PM, and dates.'],
  ['2', 'Fill Assignee Person IDs using values from LeanControl People Master before actual upload.'],
  ['3', 'Confirm the 50% Progress default for source rows marked กำลังดำเนินการ.'],
  ['4', 'Confirm that the generated Phase grouping from Core Function is correct.']
];
for (let row = 13; row <= 16; row += 1) review.mergeCells(`B${row}:F${row}`);
review.getRange('A13:F16').format = { fill: '#FFF8E3', font: { color: '#715A13' }, wrapText: true, verticalAlignment: 'center' };
review.getRange('A13:F16').format.rowHeight = 28;

const lists = wb.worksheets.add('Validation lists');
title(lists, 'Validation lists', 'Reference values for Project plan dropdowns.', 'F');
lists.getRange('A4:F4').values = [['Level', 'Project type', 'Project size', 'Status', 'Priority', 'True / False']];
lists.getRange('A4:F4').format = header;
lists.getRange('A5:F10').values = [
  ['Phase', 'New', 'Small', 'NotStarted', 'Low', 'TRUE'],
  ['Main Task', 'Change Major', 'Medium', 'InProgress', 'Medium', 'FALSE'],
  ['Task', 'Change Minor', 'Large', 'Blocked', 'High', null],
  ['Subtask', 'Job', null, 'Done', null, null],
  [null, null, null, 'Cancelled', null, null],
  [null, null, null, null, null, null]
];
lists.getRange('A4:F10').format.borders = { preset: 'all', style: 'thin', color: c.line };
lists.getRange('A5:F10').format = { fill: '#EAF3FF' };
['A','B','C','D','E','F'].forEach(col => { lists.getRange(`${col}:${col}`).format.columnWidth = 21; });
plan.getRange(`A10:A${lastRow + 60}`).dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$A$5:$A$8" } };
plan.getRange('C6').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$B$5:$B$8" } };
plan.getRange('D6').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$C$5:$C$7" } };
plan.getRange(`J10:J${lastRow + 60}`).dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$D$5:$D$9" } };
plan.getRange(`L10:L${lastRow + 60}`).dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$E$5:$E$7" } };
plan.getRange(`M10:M${lastRow + 60}`).dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$F$5:$F$6" } };

await fs.mkdir(outputDir, { recursive: true });
const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputPath);
const check = await wb.inspect({ kind: 'table', range: `'Project plan'!A1:O${lastRow}`, include: 'values,formulas', tableMaxRows: 55, tableMaxCols: 15 });
console.log(check.ndjson);
const errors = await wb.inspect({ kind: 'match', searchTerm: '#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A', options: { useRegex: true, maxResults: 100 }, summary: 'formula error scan' });
console.log(errors.ndjson);
for (const [sheetName, range, fileName] of [['Project plan','A1:O29','project-plan-preview-1.png'],['Project plan',`A30:O${lastRow}`,'project-plan-preview-2.png'],['Conversion notes','A1:F18','conversion-notes-preview.png'],['Validation lists','A1:F12','validation-preview.png']]) {
  const image = await wb.render({ sheetName, range, scale: 1.05, format: 'png' });
  await fs.writeFile(`${outputDir}/${fileName}`, new Uint8Array(await image.arrayBuffer()));
}
console.log(outputPath);
