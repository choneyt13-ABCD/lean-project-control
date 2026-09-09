import fs from 'node:fs/promises';
import { SpreadsheetFile, Workbook } from '@oai/artifact-tool';

const outputDir = 'D:/project/MVP Project/lean-project-control/outputs/project-data-collection';
const outputPath = `${outputDir}/LeanControl_ProjectDataCollection_Template.xlsx`;

const wb = Workbook.create();

const c = {
  darkGreen: '#173B2C', lime: '#B7DC76', pale: '#EAF2E7', line: '#C8D8C8',
  text: '#24332A', yellow: '#FFF8E3', yellowDark: '#715A13', blue: '#EAF3FF',
  red: '#FFECEC', white: '#FFFFFF',
};
const headerFmt = {
  fill: c.darkGreen, font: { bold: true, color: c.white, size: 10 },
  horizontalAlignment: 'center', verticalAlignment: 'center', wrapText: true,
};

function addBanner(sheet, title, subtitle, lastCol) {
  sheet.mergeCells(`A1:${lastCol}1`);
  sheet.getRange('A1').values = [[title]];
  sheet.getRange('A1').format = { fill: c.darkGreen, font: { bold: true, color: c.white, size: 15 }, verticalAlignment: 'center' };
  sheet.getRange('A1').format.rowHeight = 36;
  sheet.mergeCells(`A2:${lastCol}2`);
  sheet.getRange('A2').values = [[subtitle]];
  sheet.getRange('A2').format = { fill: c.pale, font: { italic: true, color: '#587061', size: 10 }, wrapText: true, verticalAlignment: 'center' };
  sheet.getRange('A2').format.rowHeight = 28;
  sheet.showGridLines = false;
}

// ---- SHEET 1: README ----
const guide = wb.worksheets.add('วิธีกรอก');
addBanner(guide, 'LeanControl — แบบฟอร์มรวบรวมข้อมูลโครงการ', 'กรอกข้อมูลโครงการ 5-6 โครงการ เพื่อนำเข้าระบบ | กรอกเป็นลำดับตามแท็บด้านล่าง', 'E');
guide.getRange('A4:E4').merge();
guide.getRange('A4').values = [['ลำดับการกรอกข้อมูล']];
guide.getRange('A4').format = { fill: c.pale, font: { bold: true, color: c.darkGreen, size: 11 } };
const steps = [
  ['1', 'แท็บ "โครงการ"', 'กรอกข้อมูลพื้นฐาน: ชื่อโครงการ ประเภท ขนาด ช่วงเวลา สถานะปัจจุบัน'],
  ['2', 'แท็บ "สมาชิกทีม"', 'ระบุสมาชิกทุกคนในแต่ละโครงการ พร้อมบทบาท (PM, BA, DEV, QA เป็นต้น)'],
  ['3', 'แท็บ "WBS และ Phase"', 'กำหนดโครงสร้างการส่งมอบ เช่น Requirements, Design, Development, Testing, Go Live'],
  ['4', 'แท็บ "งาน (Tasks)"', 'รายการงานทุกชิ้น พร้อมเจ้าของ กำหนดส่ง สถานะ และความคืบหน้า %'],
  ['5', 'แท็บ "RAID"', 'ความเสี่ยง สมมติฐาน ประเด็น และ Dependency ของแต่ละโครงการ (ถ้ามี)'],
];
guide.getRange('A5:C9').values = steps;
for (let r = 5; r <= 9; r++) guide.mergeCells(`C${r}:E${r}`);
guide.getRange('A5:E9').format = { borders: { preset: 'all', style: 'thin', color: c.line }, wrapText: true, verticalAlignment: 'center', rowHeight: 30 };
guide.getRange('A5:A9').format = { fill: c.lime, font: { bold: true, color: c.darkGreen, size: 12 }, horizontalAlignment: 'center' };
guide.getRange('B5:B9').format = { font: { bold: true, color: c.darkGreen } };

guide.getRange('A11:E11').merge();
guide.getRange('A11').values = [['ค่าที่ใช้ได้ในแต่ละช่อง (Valid Values)']];
guide.getRange('A11').format = { fill: c.pale, font: { bold: true, color: c.darkGreen } };
const allowed = [
  ['Project Type', 'New | Change Major | Change Minor | Job'],
  ['Project Size', 'Small | Medium | Large'],
  ['Project Status', 'Active | Draft | OnHold | Completed | Cancelled'],
  ['RAG Status', 'Green | Amber | Red'],
  ['Task Status', 'NotStarted | InProgress | Blocked | Done | Cancelled'],
  ['Item Type (ประเภทงาน)', 'Main Task | Task | Subtask'],
  ['Project Role (บทบาท)', 'PM | BA | DEV | QA | Reviewer | Contributor | Observer'],
  ['RAID Type', 'Risk | Assumption | Issue | Dependency'],
  ['RAID Severity', 'Critical | High | Medium | Low'],
];
guide.getRange('A12:B20').values = allowed;
for (let r = 12; r <= 20; r++) guide.mergeCells(`B${r}:E${r}`);
guide.getRange('A12:E20').format = { borders: { preset: 'all', style: 'thin', color: c.line }, wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
guide.getRange('A12:A20').format = { fill: '#F0F0F0', font: { bold: true, color: c.darkGreen } };
guide.getRange('A:A').format.columnWidth = 22;
guide.getRange('B:E').format.columnWidth = 26;

// ---- SHEET 2: PROJECTS ----
const projSheet = wb.worksheets.add('โครงการ');
addBanner(projSheet, '1. ข้อมูลพื้นฐานโครงการ', 'กรอกทุกโครงการที่อยู่ในความรับผิดชอบ | หนึ่งแถว = หนึ่งโครงการ | * = จำเป็นต้องกรอก', 'K');
const projHdr = ['รหัสโครงการ *\n(Project Code)', 'ชื่อโครงการ *\n(ภาษาไทย/อังกฤษ)', 'ประเภทโครงการ *\n(Project Type)', 'ขนาดโครงการ *\n(Project Size)', 'Portfolio\n(กลุ่มงาน)', 'ผู้จัดการโครงการ *\n(Main PM - ชื่อ)', 'สถานะ *\n(Status)', 'วันเริ่มต้น *\n(YYYY-MM-DD)', 'วันสิ้นสุด *\n(YYYY-MM-DD)', 'RAG Status\n(ปัจจุบัน)', 'หมายเหตุ / บริบท'];
projSheet.getRange('A4:K4').values = [projHdr];
projSheet.getRange('A4:K4').format = { ...headerFmt, rowHeight: 44 };
const projSample = [
  ['RRMS', 'ระบบบริหารจัดการวิจัยโรงพยาบาลรามาธิบดี', 'New', 'Large', 'Hospital IS', 'Chonthawat', 'Active', '2026-01-01', '2027-06-30', 'Red', '(ตัวอย่าง - มีในระบบแล้ว)'],
  ['EDOC-2026', 'ระบบสารบรรณอิเล็กทรอนิกส์ ระยะที่ 2', 'New', 'Large', 'Hospital IS', 'RRMS Demo PM', 'Active', '2025-09-08', '2026-10-31', 'Amber', '(ตัวอย่าง - มีในระบบแล้ว)'],
  ['PROJECT-03', 'กรอกชื่อโครงการที่ 3', 'New', 'Medium', '', 'ชื่อ PM', 'Active', '', '', 'Green', ''],
  ['PROJECT-04', 'กรอกชื่อโครงการที่ 4', 'New', 'Medium', '', 'ชื่อ PM', 'Active', '', '', 'Green', ''],
  ['PROJECT-05', 'กรอกชื่อโครงการที่ 5', 'New', 'Small', '', 'ชื่อ PM', 'Active', '', '', 'Green', ''],
  ['PROJECT-06', 'กรอกชื่อโครงการที่ 6', 'New', 'Small', '', 'ชื่อ PM', 'Active', '', '', 'Green', ''],
];
projSheet.getRange('A5:K10').values = projSample;
projSheet.getRange('A5:K6').format = { fill: c.yellow, font: { color: c.yellowDark, italic: true }, wrapText: true, verticalAlignment: 'center', rowHeight: 28 };
projSheet.getRange('A7:K50').format = { fill: '#FAFFFE', wrapText: true, verticalAlignment: 'center', rowHeight: 28 };
projSheet.getRange('A5:K50').format.borders = { insideHorizontal: { style: 'thin', color: c.line }, insideVertical: { style: 'thin', color: c.line }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
projSheet.getRange('C5:C50').dataValidation = { rule: { type: 'list', formula1: '"New,Change Major,Change Minor,Job"' } };
projSheet.getRange('D5:D50').dataValidation = { rule: { type: 'list', formula1: '"Small,Medium,Large"' } };
projSheet.getRange('G5:G50').dataValidation = { rule: { type: 'list', formula1: '"Active,Draft,OnHold,Completed,Cancelled"' } };
projSheet.getRange('J5:J50').dataValidation = { rule: { type: 'list', formula1: '"Green,Amber,Red"' } };
projSheet.getRange('H5:I50').format.numberFormat = 'yyyy-mm-dd';
projSheet.freezePanes.freezeRows(4);
[16, 34, 17, 14, 20, 22, 14, 15, 15, 12, 28].forEach((w, i) => { projSheet.getRangeByIndexes(0, i, 1, 1).format.columnWidth = w; });

// ---- SHEET 3: TEAM ----
const teamSheet = wb.worksheets.add('สมาชิกทีม');
addBanner(teamSheet, '2. สมาชิกทีมและบทบาท', 'ระบุสมาชิกทุกคนในแต่ละโครงการ | หนึ่งแถว = หนึ่งคนในหนึ่งโครงการ | บุคคลเดียวอยู่หลายโครงการได้', 'H');
const teamHdr = ['รหัสโครงการ *\n(Project Code)', 'ชื่อ-นามสกุล *', 'Email *\n(ใช้เป็น Person ID)', 'แผนก / หน่วยงาน', 'ตำแหน่ง\n(Position Title)', 'บทบาทในโครงการ *\n(Project Role)', 'เป็น Main PM?\n(TRUE/FALSE)', 'หมายเหตุ'];
teamSheet.getRange('A4:H4').values = [teamHdr];
teamSheet.getRange('A4:H4').format = { ...headerFmt, rowHeight: 44 };
const teamSample = [
  ['RRMS', 'Chonthawat Tangmanomana', 'chonthawat.tan@mahidol.ac.th', 'ฝ่ายสารสนเทศ', 'Project Manager', 'PM', 'TRUE', '(ตัวอย่าง)'],
  ['RRMS', 'Chanyawan', 'Chanyawan.sit@mahidol.ac.th', 'งานสารสนเทศ', 'Business Analyst', 'BA', 'FALSE', '(ตัวอย่าง)'],
  ['PROJECT-03', 'ชื่อสมาชิก 1', 'email@mahidol.ac.th', 'ระบุแผนก', 'ระบุตำแหน่ง', 'PM', 'TRUE', ''],
  ['PROJECT-03', 'ชื่อสมาชิก 2', 'email2@mahidol.ac.th', 'ระบุแผนก', 'ระบุตำแหน่ง', 'BA', 'FALSE', ''],
  ['PROJECT-04', 'ชื่อสมาชิก 1', 'email@mahidol.ac.th', '', '', 'PM', 'TRUE', ''],
];
teamSheet.getRange('A5:H9').values = teamSample;
teamSheet.getRange('A5:H6').format = { fill: c.yellow, font: { color: c.yellowDark, italic: true }, wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
teamSheet.getRange('A7:H100').format = { fill: '#FAFFFE', wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
teamSheet.getRange('A5:H100').format.borders = { insideHorizontal: { style: 'thin', color: c.line }, insideVertical: { style: 'thin', color: c.line }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
teamSheet.getRange('F5:F100').dataValidation = { rule: { type: 'list', formula1: '"PM,BA,DEV,QA,Reviewer,Contributor,Observer"' } };
teamSheet.getRange('G5:G100').dataValidation = { rule: { type: 'list', formula1: '"TRUE,FALSE"' } };
teamSheet.freezePanes.freezeRows(4);
[18, 28, 30, 24, 22, 18, 14, 26].forEach((w, i) => { teamSheet.getRangeByIndexes(0, i, 1, 1).format.columnWidth = w; });

// ---- SHEET 4: WBS ----
const wbsSheet = wb.worksheets.add('WBS และ Phase');
addBanner(wbsSheet, '3. โครงสร้างการส่งมอบ (Phase และ WBS)', 'กำหนด Phase และกลุ่มงาน (WBS) | เช่น Requirements, Design, Development, Testing, Go Live', 'H');
const wbsHdr = ['รหัสโครงการ *\n(Project Code)', 'รหัส Phase *\n(Phase Code)', 'ชื่อ Phase *', 'รหัส WBS *\n(WBS Code)', 'ชื่อ WBS *\n(WBS Name)', 'คำอธิบาย\n(Description)', 'วันเริ่ม Phase\n(YYYY-MM-DD)', 'วันสิ้นสุด Phase\n(YYYY-MM-DD)'];
wbsSheet.getRange('A4:H4').values = [wbsHdr];
wbsSheet.getRange('A4:H4').format = { ...headerFmt, rowHeight: 44 };
const wbsSample = [
  ['RRMS', 'PH-01', 'Requirements and Analysis', 'RRMS-01', 'Business Requirements', 'รวบรวมและวิเคราะห์ความต้องการ', '2026-01-01', '2026-03-31'],
  ['RRMS', 'PH-02', 'Design and Development', 'RRMS-02', 'System Design', 'ออกแบบและพัฒนาระบบ', '2026-04-01', '2026-09-30'],
  ['PROJECT-03', 'PH-01', 'ชื่อ Phase 1 ของโครงการ', 'P3-01', 'ชื่อกลุ่มงาน 1', 'คำอธิบาย', '', ''],
  ['PROJECT-03', 'PH-02', 'ชื่อ Phase 2 ของโครงการ', 'P3-02', 'ชื่อกลุ่มงาน 2', '', '', ''],
  ['PROJECT-04', 'PH-01', 'ชื่อ Phase 1 ของโครงการ', 'P4-01', 'ชื่อกลุ่มงาน 1', '', '', ''],
];
wbsSheet.getRange('A5:H9').values = wbsSample;
wbsSheet.getRange('A5:H6').format = { fill: c.yellow, font: { color: c.yellowDark, italic: true }, wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
wbsSheet.getRange('A7:H100').format = { fill: '#FAFFFE', wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
wbsSheet.getRange('A5:H100').format.borders = { insideHorizontal: { style: 'thin', color: c.line }, insideVertical: { style: 'thin', color: c.line }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
wbsSheet.getRange('G5:H100').format.numberFormat = 'yyyy-mm-dd';
wbsSheet.freezePanes.freezeRows(4);
[18, 16, 30, 16, 28, 36, 15, 15].forEach((w, i) => { wbsSheet.getRangeByIndexes(0, i, 1, 1).format.columnWidth = w; });

// ---- SHEET 5: TASKS ----
const taskSheet = wb.worksheets.add('งาน (Tasks)');
addBanner(taskSheet, '4. รายการงาน (Work Items)', 'กรอกงานทุกชิ้นของทุกโครงการ | ระบุเจ้าของงาน วันกำหนดส่ง สถานะ และความคืบหน้า | หนึ่งแถว = หนึ่งงาน', 'P');
const taskHdr = [
  'รหัสโครงการ *', 'รหัส WBS *', 'รหัสงาน *\n(Item Code)',
  'ประเภทงาน *\n(Main Task/Task/Subtask)', 'งานแม่\n(Parent Code)',
  'ชื่องาน *', 'คำอธิบาย', 'เจ้าของงาน *\n(Owner - Email)',
  'ผู้รับงาน\n(Assignees - แยกด้วย ;)', 'Workstream\n(กลุ่มงาน เช่น Frontend)',
  'วันเริ่ม\n(YYYY-MM-DD)', 'วันกำหนดส่ง *\n(YYYY-MM-DD)',
  'สถานะ *', 'ความคืบหน้า *\n(Progress 0-100)',
  'RAG *\n(Green/Amber/Red)', 'หมายเหตุ',
];
taskSheet.getRange('A4:P4').values = [taskHdr];
taskSheet.getRange('A4:P4').format = { ...headerFmt, rowHeight: 48 };
const taskSample = [
  ['RRMS', 'RRMS-01', 'RRMS-MT-001', 'Main Task', '', 'กำหนดขอบเขตระบบ', 'จัดทำ TOR และ Scope', 'chonthawat.tan@mahidol.ac.th', '', 'Requirements', '2026-01-01', '2026-02-28', 'Done', 100, 'Green', ''],
  ['RRMS', 'RRMS-01', 'RRMS-T-001', 'Task', 'RRMS-MT-001', 'ประชุมผู้มีส่วนได้เสีย ครั้งที่ 1', '', 'chonthawat.tan@mahidol.ac.th', '', 'Requirements', '2026-01-05', '2026-01-10', 'Done', 100, 'Green', ''],
  ['PROJECT-03', 'P3-01', 'P3-MT-001', 'Main Task', '', 'กรอกชื่องานหลัก', '', 'email@mahidol.ac.th', '', 'ระบุ Workstream', '', '', 'NotStarted', 0, 'Green', ''],
  ['PROJECT-03', 'P3-01', 'P3-T-001', 'Task', 'P3-MT-001', 'กรอกชื่องานย่อย', '', 'email@mahidol.ac.th', '', '', '', '', 'NotStarted', 0, 'Green', ''],
];
taskSheet.getRange('A5:P8').values = taskSample;
taskSheet.getRange('A5:P6').format = { fill: c.yellow, font: { color: c.yellowDark, italic: true }, wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
taskSheet.getRange('A7:P300').format = { fill: '#FAFFFE', wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
taskSheet.getRange('A5:P300').format.borders = { insideHorizontal: { style: 'thin', color: c.line }, insideVertical: { style: 'thin', color: c.line }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
taskSheet.getRange('D5:D300').dataValidation = { rule: { type: 'list', formula1: '"Main Task,Task,Subtask"' } };
taskSheet.getRange('M5:M300').dataValidation = { rule: { type: 'list', formula1: '"NotStarted,InProgress,Blocked,Done,Cancelled"' } };
taskSheet.getRange('O5:O300').dataValidation = { rule: { type: 'list', formula1: '"Green,Amber,Red"' } };
taskSheet.getRange('K5:L300').format.numberFormat = 'yyyy-mm-dd';
taskSheet.getRange('N5:N300').format.numberFormat = '0';
taskSheet.freezePanes.freezeRows(4);
[14, 14, 16, 16, 14, 30, 28, 26, 28, 18, 13, 14, 14, 12, 10, 24].forEach((w, i) => { taskSheet.getRangeByIndexes(0, i, 1, 1).format.columnWidth = w; });

// ---- SHEET 6: RAID ----
const raidSheet = wb.worksheets.add('RAID');
addBanner(raidSheet, '5. RAID Register (ความเสี่ยงและประเด็น)', 'Risk, Assumption, Issue, Dependency | กรอกเฉพาะที่มีข้อมูลจริง | ช่วยให้การประชุมสมบูรณ์ขึ้น', 'K');
const raidHdr = ['รหัสโครงการ *', 'รหัส RAID\n(เช่น R-001)', 'ประเภท *\n(Risk/Issue/etc)', 'หัวข้อ *', 'คำอธิบาย', 'ระดับ *\n(Critical/High/Medium/Low)', 'สถานะ *\n(Open/Mitigated/Closed)', 'แนวทางแก้ไข', 'เจ้าของ\n(Owner - Email)', 'วันกำหนดแก้ไข\n(YYYY-MM-DD)', 'หมายเหตุ'];
raidSheet.getRange('A4:K4').values = [raidHdr];
raidSheet.getRange('A4:K4').format = { ...headerFmt, rowHeight: 44 };
const raidSample = [
  ['RRMS', 'R-001', 'Risk', 'ผู้ใช้งานไม่เข้า UAT ตามกำหนด', 'ผู้ใช้งานมีภาระงานประจำสูง', 'High', 'Open', 'ประสานงานกับหัวหน้าแผนก', 'chonthawat.tan@mahidol.ac.th', '2026-10-01', ''],
  ['PROJECT-03', 'R-001', 'Risk', 'กรอกชื่อความเสี่ยง', '', 'Medium', 'Open', '', '', '', ''],
];
raidSheet.getRange('A5:K6').values = raidSample;
raidSheet.getRange('A5:K5').format = { fill: c.yellow, font: { color: c.yellowDark, italic: true }, wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
raidSheet.getRange('A6:K100').format = { fill: '#FAFFFE', wrapText: true, verticalAlignment: 'center', rowHeight: 26 };
raidSheet.getRange('A5:K100').format.borders = { insideHorizontal: { style: 'thin', color: c.line }, insideVertical: { style: 'thin', color: c.line }, top: { style: 'thin', color: c.line }, bottom: { style: 'thin', color: c.line }, left: { style: 'thin', color: c.line }, right: { style: 'thin', color: c.line } };
raidSheet.getRange('C5:C100').dataValidation = { rule: { type: 'list', formula1: '"Risk,Assumption,Issue,Dependency"' } };
raidSheet.getRange('F5:F100').dataValidation = { rule: { type: 'list', formula1: '"Critical,High,Medium,Low"' } };
raidSheet.getRange('G5:G100').dataValidation = { rule: { type: 'list', formula1: '"Open,Mitigated,Closed"' } };
raidSheet.getRange('J5:J100').format.numberFormat = 'yyyy-mm-dd';
raidSheet.freezePanes.freezeRows(4);
[16, 13, 16, 28, 34, 20, 16, 30, 26, 15, 24].forEach((w, i) => { raidSheet.getRangeByIndexes(0, i, 1, 1).format.columnWidth = w; });

// ---- SAVE ----
await fs.mkdir(outputDir, { recursive: true });
const xlsx = await SpreadsheetFile.exportXlsx(wb);
await xlsx.save(outputPath);

for (const [sheetName, range, fileName] of [
  ['วิธีกรอก', 'A1:E22', 'preview-guide.png'],
  ['โครงการ', 'A1:K11', 'preview-projects.png'],
  ['สมาชิกทีม', 'A1:H10', 'preview-team.png'],
  ['WBS และ Phase', 'A1:H11', 'preview-wbs.png'],
  ['งาน (Tasks)', 'A1:P10', 'preview-tasks.png'],
  ['RAID', 'A1:K8', 'preview-raid.png'],
]) {
  const img = await wb.render({ sheetName, range, scale: 1.3, format: 'png' });
  await fs.writeFile(`${outputDir}/${fileName}`, new Uint8Array(await img.arrayBuffer()));
}
console.log('Template saved:', outputPath);
