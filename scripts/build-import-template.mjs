import fs from 'node:fs/promises';
import { SpreadsheetFile, Workbook } from '@oai/artifact-tool';

const outputDir = 'D:/project/MVP Project/lean-project-control/outputs/import-template-review';
const outputPath = `${outputDir}/LeanControl_Import_Template_Review.xlsx`;
const wb = Workbook.create();

const colors = {
  green: '#183B2C', lime: '#B7DC76', paper: '#F7F8F5', line: '#DCE5DC', muted: '#5D6B61', blue: '#EAF3FF', yellow: '#FFF5D9', example: '#F4F8F1'
};
const headerFormat = { fill: colors.green, font: { bold: true, color: '#FFFFFF' }, horizontalAlignment: 'center', verticalAlignment: 'center', wrapText: true };
const noteFormat = { fill: colors.yellow, font: { color: '#745B13', italic: true }, wrapText: true, verticalAlignment: 'center' };
const exampleFormat = { fill: colors.example, font: { color: '#294A36' }, wrapText: true, verticalAlignment: 'center' };

function title(sheet, titleText, subtitle, endColumn) {
  sheet.mergeCells(`A1:${endColumn}1`);
  sheet.getRange('A1').values = [[titleText]];
  sheet.getRange('A1').format = { fill: colors.green, font: { bold: true, color: '#FFFFFF', size: 16 }, verticalAlignment: 'center' };
  sheet.getRange('A1').format.rowHeight = 30;
  sheet.mergeCells(`A2:${endColumn}2`);
  sheet.getRange('A2').values = [[subtitle]];
  sheet.getRange('A2').format = { fill: '#E6F0E3', font: { color: colors.muted, italic: true }, wrapText: true, verticalAlignment: 'center' };
  sheet.getRange('A2').format.rowHeight = 28;
  sheet.showGridLines = false;
}

function setupImportSheet(sheet, sheetTitle, subtitle, headers, sample, widths) {
  const end = String.fromCharCode(64 + headers.length);
  title(sheet, sheetTitle, subtitle, end);
  sheet.getRange(`A4:${end}4`).values = [headers];
  sheet.getRange(`A4:${end}4`).format = headerFormat;
  sheet.getRange(`A4:${end}4`).format.rowHeight = 30;
  sheet.getRange(`A5:${end}5`).values = [sample];
  sheet.getRange(`A5:${end}5`).format = exampleFormat;
  sheet.getRange(`A5:${end}5`).format.rowHeight = 38;
  sheet.getRange(`A6:${end}6`).format = { fill: '#FFFFFF', borders: { preset: 'outside', style: 'thin', color: colors.line } };
  sheet.getRange(`A4:${end}104`).format.borders = { insideHorizontal: { style: 'thin', color: '#EDF1EC' }, insideVertical: { style: 'thin', color: '#EDF1EC' }, top: { style: 'thin', color: colors.line }, bottom: { style: 'thin', color: colors.line }, left: { style: 'thin', color: colors.line }, right: { style: 'thin', color: colors.line } };
  widths.forEach((width, index) => { sheet.getRangeByIndexes(0, index, 1, 1).format.columnWidth = width; });
  sheet.freezePanes.freezeRows(4);
}

const guide = wb.worksheets.add('Read me');
title(guide, 'LeanControl Import Template — Review Draft', 'Use this file to review the data structure. The upload screen will be implemented only after you approve this template.', 'F');
guide.getRange('A4:F4').merge();
guide.getRange('A4').values = [['How the future import will work']];
guide.getRange('A4').format = { fill: '#E6F0E3', font: { bold: true, color: colors.green } };
guide.getRange('A5:B9').values = [
  ['1', 'Prepare — Create project and people records, or fill all tabs in this workbook.'],
  ['2', 'Validate — Upload runs a full validation first. It will show all errors and will not save partial data.'],
  ['3', 'Preview — Review the number of Projects, WBS, work items, and members that will be created.'],
  ['4', 'Confirm — Confirm the import once the preview has no errors.'],
  ['5', 'Audit — The system records created / updated data in Activity log.']
];
for (let row = 5; row <= 9; row += 1) guide.mergeCells(`B${row}:F${row}`);
guide.getRange('A5:F9').format = { borders: { preset: 'inside', style: 'thin', color: colors.line }, wrapText: true, verticalAlignment: 'center' };
guide.getRange('A5:A9').format = { fill: colors.lime, font: { bold: true, color: colors.green }, horizontalAlignment: 'center' };
guide.getRange('B5:F9').format = { font: { bold: true, color: colors.green }, wrapText: true, verticalAlignment: 'center' };
guide.getRange('A11:F11').merge();
guide.getRange('A11').values = [['Rules for this draft']];
guide.getRange('A11').format = { fill: '#E6F0E3', font: { bold: true, color: colors.green } };
guide.getRange('A12:B16').values = [
  ['•', 'Keep Project Code, WBS Code, and Item Code unique within a project.'],
  ['•', 'Work Item Type must be Main Task, Task, or Subtask. Parent Item Code builds the hierarchy.'],
  ['•', 'Use Person ID values from the People master. Multiple assignees are separated by semicolons.'],
  ['•', 'Dates use YYYY-MM-DD. Status Done requires Progress = 100.'],
  ['•', 'Green sample rows are examples only; replace or delete them before upload.']
];
for (let row = 12; row <= 16; row += 1) guide.mergeCells(`B${row}:F${row}`);
guide.getRange('A12:F16').format = { wrapText: true, verticalAlignment: 'center' };
guide.getRange('A12:A16').format = { font: { bold: true, color: colors.green } };
guide.getRange('A18:F18').merge();
guide.getRange('A18').values = [['Decision needed before implementation']];
guide.getRange('A18').format = { fill: colors.yellow, font: { bold: true, color: '#745B13' } };
guide.getRange('A19:B22').values = [
  ['1', 'Import action for an existing Project / WBS / Item Code: Create only, Update, or Preview + confirm?'],
  ['2', 'Should a Project be created in the same workbook import, or must it be created first in Project setup?'],
  ['3', 'Should work-item Weight total 100% by WBS, Main Task, or only the whole Project?'],
  ['4', 'Confirm the default roles and statuses in Validation lists.']
];
for (let row = 19; row <= 22; row += 1) guide.mergeCells(`B${row}:F${row}`);
guide.getRange('A19:F22').format = noteFormat;
guide.getRange('A5:F22').format.rowHeight = 30;
guide.getRange('A:A').format.columnWidth = 8;
guide.getRange('B:B').format.columnWidth = 28;
guide.getRange('C:F').format.columnWidth = 22;

const projects = wb.worksheets.add('Project import');
setupImportSheet(projects, '1. Project import', 'One row = one project. A Project Code links every other worksheet in this file.',
  ['Project Code*', 'Project Name*', 'Project Type*', 'Project Size*', 'Portfolio', 'Status*', 'Start Date', 'Target End Date', 'Main PM Person ID*', 'RAG Status'],
  ['EDOC-2026', 'Electronic Document System', 'New', 'Large', 'Digital Transformation', 'Active', '2026-09-01', '2026-12-31', 'DEMO-RRMS-PM', 'Green'],
  [16, 30, 17, 15, 24, 15, 14, 16, 21, 14]);
projects.getRange('C5:C104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$A$2:$A$5" } };
projects.getRange('D5:D104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$B$2:$B$4" } };
projects.getRange('F5:F104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$C$2:$C$6" } };
projects.getRange('J5:J104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$D$2:$D$4" } };
projects.getRange('G5:H104').format.numberFormat = 'yyyy-mm-dd';

const members = wb.worksheets.add('Project members');
setupImportSheet(members, '2. Project members', 'One row = one member and role in a Project. Add all people before assigning work items.',
  ['Project Code*', 'Person ID*', 'Project Role*', 'Is Main PM*'],
  ['EDOC-2026', 'DEMO-RRMS-PM', 'PM', 'TRUE'], [18, 22, 20, 15]);
members.getRange('C5:C104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$E$2:$E$8" } };
members.getRange('D5:D104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$F$2:$F$3" } };

const wbs = wb.worksheets.add('WBS import');
setupImportSheet(wbs, '3. WBS import', 'One row = one WBS. Parent WBS is optional; leave blank for a top-level WBS.',
  ['Project Code*', 'Parent WBS', 'WBS Code*', 'WBS Name*', 'Description', 'Phase Code', 'Planned Start', 'Planned Due'],
  ['EDOC-2026', '', 'EDOC-01', 'Requirements', 'Collect and approve business requirements.', 'REQ', '2026-09-01', '2026-09-15'],
  [18, 18, 16, 28, 40, 15, 15, 15]);
wbs.getRange('G5:H104').format.numberFormat = 'yyyy-mm-dd';

const items = wb.worksheets.add('Work items');
setupImportSheet(items, '4. Work items import', 'One row = one Main Task, Task, or Subtask. Use Parent Item Code to create expandable task levels.',
  ['Project Code*', 'WBS Code*', 'Item Code*', 'Item Type*', 'Parent Item Code', 'Title*', 'Description', 'Owner Person ID*', 'Assignee Person IDs*', 'Role*', 'Start Date', 'Due Date', 'Status*', 'Weight', 'Progress*', 'Evidence Required*'],
  ['EDOC-2026', 'EDOC-01', 'EDOC-MT-001', 'Main Task', '', 'Gather requirements', 'Run interviews and record requirements.', 'DEMO-RRMS-PM', 'DEMO-RRMS-PM', 'BA', '2026-09-01', '2026-09-10', 'InProgress', 30, 40, 'TRUE'],
  [17, 15, 17, 16, 20, 28, 38, 22, 30, 15, 14, 14, 15, 11, 12, 19]);
items.getRange('D5:D104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$G$2:$G$4" } };
items.getRange('J5:J104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$H$2:$H$8" } };
items.getRange('M5:M104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$I$2:$I$6" } };
items.getRange('P5:P104').dataValidation = { rule: { type: 'list', formula1: "'Validation lists'!$F$2:$F$3" } };
items.getRange('K5:L104').format.numberFormat = 'yyyy-mm-dd';
items.getRange('N5:O104').format.numberFormat = '0';

const lists = wb.worksheets.add('Validation lists');
title(lists, 'Validation lists', 'Reference values used by drop-down lists. Do not change values until you approve the import rules.', 'I');
lists.getRange('A4:I4').values = [['Project Type', 'Project Size', 'Project Status', 'RAG Status', 'Project Role', 'True / False', 'Item Type', 'Assignment Role', 'Work Item Status']];
lists.getRange('A4:I4').format = headerFormat;
lists.getRange('A5:I12').values = [
  ['New', 'Small', 'Active', 'Green', 'PM', 'TRUE', 'Main Task', 'Owner', 'NotStarted'],
  ['Change Major', 'Medium', 'Draft', 'Amber', 'ProjectAdmin', 'FALSE', 'Task', 'BA', 'InProgress'],
  ['Change Minor', 'Large', 'OnHold', 'Red', 'BALead', null, 'Subtask', 'DEV', 'Blocked'],
  ['Job', null, 'Completed', null, 'DEVLead', null, null, 'QA', 'Done'],
  [null, null, 'Cancelled', null, 'QALead', null, null, 'Reviewer', 'Cancelled'],
  [null, null, null, null, 'TeamMember', null, null, 'Contributor', null],
  [null, null, null, null, 'Reviewer', null, null, 'Observer', null],
  [null, null, null, null, null, null, null, null, null]
];
lists.getRange('A4:I12').format.borders = { preset: 'all', style: 'thin', color: colors.line };
lists.getRange('A5:I12').format = { fill: colors.blue };
for (const column of ['A','B','C','D','E','F','G','H','I']) lists.getRange(`${column}:${column}`).format.columnWidth = 20;

await fs.mkdir(outputDir, { recursive: true });
const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputPath);

const check = await wb.inspect({ kind: 'table', range: "'Work items'!A1:P6", include: 'values,formulas', tableMaxRows: 6, tableMaxCols: 16 });
console.log(check.ndjson);
for (const [sheetName, range, fileName] of [
  ['Read me', 'A1:F22', 'read-me-preview.png'],
  ['Project import', 'A1:J8', 'project-preview.png'],
  ['Project members', 'A1:D8', 'members-preview.png'],
  ['WBS import', 'A1:H8', 'wbs-preview.png'],
  ['Work items', 'A1:P8', 'work-items-preview.png'],
  ['Validation lists', 'A1:I12', 'validation-preview.png']
]) {
  const preview = await wb.render({ sheetName, range, scale: 1.2, format: 'png' });
  await fs.writeFile(`${outputDir}/${fileName}`, new Uint8Array(await preview.arrayBuffer()));
}
console.log(outputPath);
