import fs from 'node:fs/promises';
import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const inputPath = 'D:/Rama Research/RRMS_Project_Plan(2).xls.xlsx';
const outputDir = 'D:/project/MVP Project/lean-project-control/outputs/rrms-plan-review';
await fs.mkdir(outputDir, { recursive: true });
const source = await FileBlob.load(inputPath);
const wb = await SpreadsheetFile.importXlsx(source);
const overview = await wb.inspect({ kind: 'workbook,sheet,table', maxChars: 12000, tableMaxRows: 18, tableMaxCols: 14, tableMaxCellChars: 100 });
console.log(overview.ndjson);
const sheets = await wb.inspect({ kind: 'sheet', include: 'id,name' });
console.log(sheets.ndjson);
const values = wb.worksheets.getItem('Sheet1').getRange('A1:O39').values;
await fs.writeFile(`${outputDir}/source-values.json`, JSON.stringify(values, null, 2));
const image = await wb.render({ sheetName: 'Sheet1', range: 'A1:O5', scale: 0.5, format: 'png' });
await fs.writeFile(`${outputDir}/source-preview-header.png`, new Uint8Array(await image.arrayBuffer()));
