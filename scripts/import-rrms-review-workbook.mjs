import fs from 'node:fs/promises';
import { FileBlob, SpreadsheetFile } from '@oai/artifact-tool';

const workbookPath = 'D:/project/MVP Project/lean-project-control/outputs/rrms-hierarchical-review/RRMS_Hierarchical_Project_Plan_Review.xlsx';
const baseUrl = 'http://127.0.0.1:3000/api';
const projectId = '30000000-0000-0000-0000-000000000001';
const headers = { 'content-type': 'application/json', 'x-project-id': projectId };

async function api(path, options = {}) {
  const response = await fetch(`${baseUrl}${path}`, { ...options, headers: { ...headers, ...(options.headers || {}) } });
  if (response.status === 204) return null;
  const body = await response.json();
  if (!response.ok) throw new Error(`${options.method || 'GET'} ${path}: ${body.message || response.statusText}`);
  return body;
}
function asDate(value) {
  if (value instanceof Date) return value.toISOString().slice(0, 10);
  if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value)) return value;
  return null;
}
function asBool(value) { return String(value || '').trim().toUpperCase() === 'TRUE'; }
function ragFor(priority) { return priority === 'High' ? 'Red' : priority === 'Medium' ? 'Amber' : 'Green'; }

const source = await FileBlob.load(workbookPath);
const workbook = await SpreadsheetFile.importXlsx(source);
const sheet = workbook.worksheets.getItem('Project plan');
const projectInfo = sheet.getRange('A6:H6').values[0];
const planRows = sheet.getRange('A10:O200').values
  .filter((row) => row[0] && row[1])
  .map((row) => ({
    level: String(row[0]), taskNo: String(row[1]), parentNo: row[2] ? String(row[2]) : '', title: String(row[3] || ''), ownerNames: String(row[4] || ''),
    duration: Number(row[6]) || 0, startDate: asDate(row[7]), dueDate: asDate(row[8]), status: String(row[9] || 'NotStarted'), progress: Number(row[10]) || 0,
    priority: String(row[11] || 'Medium'), evidenceRequired: asBool(row[12]), sourceCode: String(row[13] || ''), notes: String(row[14] || '')
  }));
if (!planRows.length) throw new Error('No import rows found in Project plan.');
const phases = planRows.filter((row) => row.level === 'Phase');
const items = planRows.filter((row) => row.level !== 'Phase');
if (!phases.length || !items.length) throw new Error('The workbook needs Phase and work-item rows.');

const existingTasks = await api('/tasks');
const pendingDelete = new Map(existingTasks.map((task) => [task.task_id, task]));
while (pendingDelete.size) {
  const leaf = [...pendingDelete.values()].find((task) => ![...pendingDelete.values()].some((candidate) => candidate.parent_task_id === task.task_id));
  if (!leaf) throw new Error('Existing RRMS work item hierarchy cannot be safely archived.');
  await api(`/tasks/${leaf.task_id}`, { method: 'DELETE' });
  pendingDelete.delete(leaf.task_id);
}
for (const wbs of await api('/wbs')) await api(`/wbs/${wbs.wbs_item_id}`, { method: 'DELETE' });
for (const phase of await api('/phases')) await api(`/phases/${phase.phase_id}`, { method: 'DELETE' });

await api(`/projects/${projectId}`, {
  method: 'PATCH',
  body: JSON.stringify({
    projectName: String(projectInfo[1] || 'RRMS Pilot Project'), portfolioName: String(projectInfo[4] || ''), projectType: String(projectInfo[2] || 'New'),
    projectSize: String(projectInfo[3] || 'Large'), projectStatus: 'Active', startDate: asDate(projectInfo[6]), targetEndDate: asDate(projectInfo[7])
  })
});

const phaseMap = new Map();
for (let index = 0; index < phases.length; index += 1) {
  const phase = phases[index];
  const phaseCode = `RRMS-PH-${String(index + 1).padStart(2, '0')}`;
  const createdPhase = await api('/phases', { method: 'POST', body: JSON.stringify({ phaseCode, phaseName: phase.title, sortOrder: index + 1, plannedStartDate: phase.startDate, plannedDueDate: phase.dueDate }) });
  const createdWbs = await api('/wbs', { method: 'POST', body: JSON.stringify({ wbsCode: phaseCode, wbsName: phase.title, phaseId: createdPhase.phaseId, sortOrder: index + 1 }) });
  phaseMap.set(phase.taskNo, { phaseId: createdPhase.phaseId, wbsItemId: createdWbs.wbsItemId });
}

const taskMap = new Map();
const taskWeight = Math.round((100 / items.length) * 100) / 100;
let currentPhaseNo = null;
let noteCount = 0;
for (const item of items) {
  const phaseNo = item.level === 'Main Task' ? item.parentNo : currentPhaseNo;
  if (item.level === 'Main Task') currentPhaseNo = item.parentNo;
  const phase = phaseMap.get(phaseNo);
  if (!phase) throw new Error(`Cannot resolve Phase for work item ${item.taskNo}.`);
  const parentTaskId = item.level === 'Main Task' ? null : taskMap.get(item.parentNo);
  if (item.level !== 'Main Task' && !parentTaskId) throw new Error(`Cannot resolve parent ${item.parentNo} for ${item.taskNo}.`);
  const taskType = item.level === 'Main Task' ? 'MainTask' : item.level === 'Task' ? 'Task' : 'Subtask';
  const created = await api('/tasks', { method: 'POST', body: JSON.stringify({
    wbsItemId: phase.wbsItemId, parentTaskId, taskCode: `RRMS-${item.sourceCode || item.taskNo.replaceAll('.', '-')}`, taskType, taskName: item.title,
    plannedStartDate: item.startDate, plannedDueDate: item.dueDate, status: item.status, ragStatus: ragFor(item.priority), weight: taskWeight,
    progress: item.progress, evidenceRequired: item.evidenceRequired
  }) });
  taskMap.set(item.taskNo, created.taskId);
  if (item.notes) {
    await api('/task-notes', { method: 'POST', body: JSON.stringify({ taskId: created.taskId, noteType: 'Note', noteText: item.notes }) });
    noteCount += 1;
  }
}

const summary = { projectId, phases: phases.length, activities: phases.length, workItems: items.length, notes: noteCount, archivedWorkItems: existingTasks.length };
await fs.writeFile('outputs/rrms-hierarchical-review/import-result.json', JSON.stringify(summary, null, 2));
console.log(JSON.stringify(summary));
