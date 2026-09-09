import fs from 'node:fs/promises';
import { SpreadsheetFile, Workbook } from '@oai/artifact-tool';

const outputDir = 'D:/project/MVP Project/lean-project-control/outputs/hierarchical-template-review';
const outputPath = `${outputDir}/LeanControl_Hierarchical_Project_Template.xlsx`;
const wb = Workbook.create();
const c = { ink: '#173B2C', lime: '#B7DC76', pale: '#EAF2E7', line: '#DCE5DC', text: '#24332A', phase1: '#8B9498', phase2: '#C75A00', phase3: '#5E8934', phase4: '#C49200', phase5: '#347AB5', phase6: '#EE822A', sample: '#EFF7EC' };
const header = { fill: c.ink, font: { bold: true, color: '#FFFFFF' }, wrapText: true, horizontalAlignment: 'center', verticalAlignment: 'center' };

function banner(sheet, titleText, subtitle, lastColumn) {
  sheet.mergeCells(`A1:${lastColumn}1`);
  sheet.getRange('A1').values = [[titleText]];
  sheet.getRange('A1').format = { fill: c.ink, font: { bold: true, color: '#FFFFFF', size: 17 }, verticalAlignment: 'center' };
  sheet.getRange('A1').format.rowHeight = 32;
  sheet.mergeCells(`A2:${lastColumn}2`);
  sheet.getRange('A2').values = [[subtitle]];
  sheet.getRange('A2').format = { fill: c.pale, font: { italic: true, color: '#587061' }, wrapText: true, verticalAlignment: 'center' };
  sheet.getRange('A2').format.rowHeight = 27;
  sheet.showGridLines = false;
}

const plan = wb.worksheets.add('Project plan');
banner(plan, 'LeanControl — Project Plan Import', 'Fill one structured table. Phase rows become headings; Main Task, Task and Subtask rows become expandable items in LeanControl.', 'O');
plan.getRange('A4:O4').merge();
plan.getRange('A4').values = [['Project information — fill once before entering the plan']];
plan.getRange('A4').format = { fill: '#DDEBDD', font: { bold: true, color: c.ink } };
plan.getRange('A5:H5').values = [['Project Code*', 'Project Name*', 'Project Type*', 'Project Size*', 'Portfolio', 'Main PM Person ID*', 'Start Date', 'Target End Date']];
plan.getRange('A5:H5').format = header;
plan.getRange('A6:H6').values = [['YOUR-PROJECT', 'Your Project Name', 'New', 'Medium', 'Your Portfolio', 'DEMO-RRMS-PM', '2026-09-01', '2026-12-31']];
plan.getRange('A6:H6').format = { fill: '#FFF8E3', font: { color: '#725B16' }, wrapText: true };
plan.getRange('A5:H6').format.borders = { preset: 'all', style: 'thin', color: c.line };
plan.getRange('G6:H6').format.numberFormat = 'yyyy-mm-dd';

plan.getRange('A8:O8').merge();
plan.getRange('A8').values = [['Work plan — replace the colored example rows, then add more rows below']];
plan.getRange('A8').format = { fill: '#DDEBDD', font: { bold: true, color: c.ink } };
const cols = ['Level*', 'Task No.*', 'Parent No.', 'Task Title*', 'Task Owner(s)', 'Assignee Person IDs', 'Duration\n(days)', 'Start Date', 'Due Date', 'Status*', 'Progress\n%', 'Priority', 'Evidence\nrequired', 'WBS Code', 'Notes'];
plan.getRange('A9:O9').values = [cols];
plan.getRange('A9:O9').format = header;
plan.getRange('A9:O9').format.rowHeight = 32;
const rows = [
  ['Phase', '1', '', 'Exploration', '', '', '', '2026-09-01', '2026-09-02', 'Done', 100, 'Medium', 'FALSE', 'YOUR-PROJECT-01', 'Phase heading'],
  ['Main Task', '1.1', '1', 'Feasibility assessment', 'PM; BA', 'DEMO-RRMS-PM', 2, '2026-09-01', '2026-09-02', 'Done', 100, 'Medium', 'FALSE', 'YOUR-PROJECT-01', 'Example main task'],
  ['Task', '1.1.1', '1.1', 'Confirm scope and approach', 'BA', 'DEMO-RRMS-PM', 1, '2026-09-01', '2026-09-01', 'Done', 100, 'Low', 'FALSE', 'YOUR-PROJECT-01', 'Example task'],
  ['Phase', '2', '', 'Requirements', '', '', '', '2026-09-03', '2026-09-16', 'InProgress', 50, 'High', 'TRUE', 'YOUR-PROJECT-02', 'Phase heading'],
  ['Main Task', '2.1', '2', 'Realize specification', 'PM; BA', 'DEMO-RRMS-PM', 10, '2026-09-03', '2026-09-16', 'InProgress', 50, 'High', 'TRUE', 'YOUR-PROJECT-02', 'Example main task'],
  ['Task', '2.1.1', '2.1', 'Meeting #1 — workflow as-is', 'BA', 'DEMO-RRMS-PM', 1, '2026-09-03', '2026-09-03', 'Done', 100, 'Medium', 'FALSE', 'YOUR-PROJECT-02', 'Example task'],
  ['Subtask', '2.1.1.1', '2.1.1', 'Record actions and open points', 'BA', 'DEMO-RRMS-PM', 1, '2026-09-03', '2026-09-03', 'Done', 100, 'Low', 'FALSE', 'YOUR-PROJECT-02', 'Example subtask'],
  ['Phase', '3', '', 'Develop / Design', '', '', '', '2026-09-17', '2026-10-31', 'NotStarted', 0, 'High', 'TRUE', 'YOUR-PROJECT-03', 'Phase heading'],
  ['Main Task', '3.1', '3', 'Design and development', 'BA; DEV', 'DEMO-RRMS-PM', 30, '2026-09-17', '2026-10-31', 'NotStarted', 0, 'High', 'TRUE', 'YOUR-PROJECT-03', 'Example main task'],
  ['Phase', '4', '', 'Testing', '', '', '', '2026-11-01', '2026-11-15', 'NotStarted', 0, 'Medium', 'TRUE', 'YOUR-PROJECT-04', 'Phase heading'],
  ['Phase', '5', '', 'Training', '', '', '', '2026-11-16', '2026-11-20', 'NotStarted', 0, 'Medium', 'FALSE', 'YOUR-PROJECT-05', 'Phase heading'],
  ['Phase', '6', '', 'Go Live & Support', '', '', '', '2026-11-21', '2026-11-30', 'NotStarted', 0, 'High', 'TRUE', 'YOUR-PROJECT-06', 'Phase heading']
];
plan.getRange('A10:O21').values = rows;
plan.getRange('A10:O21').format = { fill: c.sample, wrapText: true, verticalAlignment: 'center' };
plan.getRange('A10:O21').format.borders = { insideHorizontal: { style: 'thin', color: '#E2EAE0' }, insideVertical: { style: 'thin', color: '#E2EAE0' }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
for (const row of [10, 13, 17, 19, 20, 21]) {
  const color = ({10:c.phase1,13:c.phase2,17:c.phase3,19:c.phase4,20:c.phase5,21:c.phase6})[row];
  plan.getRange(`A${row}:O${row}`).format = { fill: color, font: { bold: true, color: '#FFFFFF' }, wrapText: true, verticalAlignment: 'center' };
}
plan.getRange('A22:O101').format = { borders: { insideHorizontal: { style: 'thin', color: '#EDF1EC' }, insideVertical: { style: 'thin', color: '#EDF1EC' }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } }, verticalAlignment: 'center' };
plan.getRange('H10:I101').format.numberFormat = 'yyyy-mm-dd';
plan.getRange('G10:G101').format.numberFormat = '0';
plan.getRange('K10:K101').format.numberFormat = '0';
plan.getRange('A10:O101').format.rowHeight = 24;
['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'].forEach((col, index) => { plan.getRange(`${col}:${col}`).format.columnWidth = [14,12,12,34,19,24,12,14,14,15,11,12,14,19,28][index]; });
plan.freezePanes.freezeRows(9);

const guide = wb.worksheets.add('How to fill');
banner(guide, 'How to fill the hierarchical plan', 'The structure is easy to enter in Excel and will become an expandable hierarchy after import.', 'F');
guide.getRange('A4:F4').merge();
guide.getRange('A4').values = [['What to enter']];
guide.getRange('A4').format = { fill: '#DDEBDD', font: { bold: true, color: c.ink } };
guide.getRange('A5:B10').values = [
  ['Phase', 'A colored section heading such as Requirements or Testing. It does not need an owner.'],
  ['Main Task', 'A large delivery group under a Phase. Parent No. must be the Phase Task No.'],
  ['Task', 'A deliverable under a Main Task. Parent No. must be the Main Task No.'],
  ['Subtask', 'A smaller action under a Task. Parent No. must be the Task No.'],
  ['Task No.', 'Use a simple hierarchy: 1 → 1.1 → 1.1.1 → 1.1.1.1.'],
  ['Person IDs', 'Use IDs already listed in LeanControl People Master. Separate multiple assignees with semicolons.']
];
for (let row = 5; row <= 10; row += 1) guide.mergeCells(`B${row}:F${row}`);
guide.getRange('A5:F10').format = { borders: { preset: 'all', style: 'thin', color: c.line }, wrapText: true, verticalAlignment: 'center' };
guide.getRange('A5:A10').format = { fill: c.lime, font: { bold: true, color: c.ink } };
guide.getRange('A5:F10').format.rowHeight = 28;
guide.getRange('A12:F12').merge();
guide.getRange('A12').values = [['Important rules for future upload']];
guide.getRange('A12').format = { fill: '#FFF3D1', font: { bold: true, color: '#715A13' } };
guide.getRange('A13:B17').values = [
  ['1', 'Phase rows must have Level = Phase and no Parent No.'],
  ['2', 'Every Main Task / Task / Subtask must have a Parent No. that exists above it.'],
  ['3', 'Status Done requires Progress = 100. Dates use YYYY-MM-DD.'],
  ['4', 'WBS Code groups the work items. Use one WBS Code for each Phase unless you need a further split.'],
  ['5', 'Yellow project information cells and green rows are examples. Replace them before upload.']
];
for (let row = 13; row <= 17; row += 1) guide.mergeCells(`B${row}:F${row}`);
guide.getRange('A13:F17').format = { fill: '#FFF8E3', font: { color: '#715A13' }, wrapText: true, verticalAlignment: 'center' };
guide.getRange('A13:F17').format.rowHeight = 26;
guide.getRange('A:A').format.columnWidth = 16;
guide.getRange('B:F').format.columnWidth = 25;

const lists = wb.worksheets.add('Validation lists');
banner(lists, 'Validation lists', 'Drop-down values for the Project plan sheet. Review these values before the Import feature is implemented.', 'F');
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

plan.getRange('A10:A101').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$A$5:$A$8" } };
plan.getRange('C6:C6').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$B$5:$B$8" } };
plan.getRange('D6:D6').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$C$5:$C$7" } };
plan.getRange('J10:J101').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$D$5:$D$9" } };
plan.getRange('L10:L101').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$E$5:$E$7" } };
plan.getRange('M10:M101').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$F$5:$F$6" } };

await fs.mkdir(outputDir, { recursive: true });
const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputPath);
const check = await wb.inspect({ kind: 'table', range: "'Project plan'!A1:O21", include: 'values,formulas', tableMaxRows: 21, tableMaxCols: 15 });
console.log(check.ndjson);
const errors = await wb.inspect({ kind: 'match', searchTerm: '#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A', options: { useRegex: true, maxResults: 100 }, summary: 'formula error scan' });
console.log(errors.ndjson);
for (const [sheetName, range, name] of [['Project plan','A1:O25','project-plan-preview.png'],['How to fill','A1:F18','how-to-fill-preview.png'],['Validation lists','A1:F12','validation-preview.png']]) {
  const image = await wb.render({ sheetName, range, scale: 1.2, format: 'png' });
  await fs.writeFile(`${outputDir}/${name}`, new Uint8Array(await image.arrayBuffer()));
}
console.log(outputPath);
