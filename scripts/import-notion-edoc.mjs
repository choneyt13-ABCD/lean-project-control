import fs from 'node:fs';

const [sourcePath, mode = '--dry-run'] = process.argv.slice(2);
if (!sourcePath) throw new Error('Usage: node scripts/import-notion-edoc.mjs <csv-path> [--apply]');

function parseCsv(text) {
  const rows = []; let row = []; let value = ''; let quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    if (quoted) {
      if (character === '"' && text[index + 1] === '"') { value += '"'; index += 1; }
      else if (character === '"') quoted = false;
      else value += character;
    } else if (character === '"') quoted = true;
    else if (character === ',') { row.push(value); value = ''; }
    else if (character === '\n') { row.push(value.replace(/\r$/, '')); rows.push(row); row = []; value = ''; }
    else value += character;
  }
  if (value || row.length) { row.push(value); rows.push(row); }
  const [rawHeaders, ...records] = rows;
  const headers = rawHeaders.map((header) => header.replace(/^\uFEFF/, ''));
  return records.filter((record) => record.some(Boolean)).map((record) => Object.fromEntries(headers.map((header, index) => [header, record[index] || ''])));
}

const titleFromReference = (value) => value.replace(/\s*\(https?:\/\/[^)]+\)\s*$/, '').trim();
const urlFromReference = (value) => value.match(/https?:\/\/[^)\s]+/)?.[0] || null;
const childReferences = (value) => Array.from(value.matchAll(/([^,]+?)\s*\((https?:\/\/[^)]+)\)/g), (match) => ({ title: match[1].trim(), url: match[2] }));
const statusFor = (value) => ({ Done: 'Done', 'In progress': 'InProgress', 'Not started': 'NotStarted' }[value] || 'NotStarted');
const ragFor = (value) => String(value).toLowerCase() === 'high' ? 'Amber' : 'Green';
const datesFor = (value) => {
  const dates = String(value).split('→').map((part) => new Date(part.trim())).filter((date) => !Number.isNaN(date.valueOf())).map((date) => date.toISOString().slice(0, 10));
  return { start: dates[0] || null, due: dates.at(-1) || null };
};

const sourceRows = parseCsv(fs.readFileSync(sourcePath, 'utf8'))
  .filter((row) => row['Project & Activity'].trim())
  .map((row, index) => ({
    index,
    title: row['Project & Activity'].trim(),
    parentLabel: titleFromReference(row['Parent item']),
    parentUrl: urlFromReference(row['Parent item']),
    children: childReferences(row['Sub-item']),
    source: row,
    ownUrl: null,
    parent: null,
    root: null,
    depth: 0
  }));

const roots = sourceRows.filter((row) => !row.parentUrl);
for (const root of roots) {
  const childParentUrls = [...new Set(sourceRows.filter((row) => row.parentLabel === root.title && row.parentUrl).map((row) => row.parentUrl))];
  if (childParentUrls.length === 1) root.ownUrl = childParentUrls[0];
}

function attachChildren(parent, root, depth) {
  parent.root = root;
  parent.depth = depth;
  for (const reference of parent.children) {
    const candidates = sourceRows.filter((row) => row.parentUrl === parent.ownUrl && row.title === reference.title && !row.parent);
    if (candidates.length !== 1) continue;
    const child = candidates[0];
    child.ownUrl = reference.url;
    child.parent = parent;
    attachChildren(child, root, depth + 1);
  }
}
for (const root of roots) attachChildren(root, root, 0);

const resolved = sourceRows.filter((row) => row.parent && row.root);
const unresolved = sourceRows.filter((row) => !roots.includes(row) && !row.parent);
for (const row of unresolved) { row.root = null; row.depth = 1; }
const importable = [...resolved, ...unresolved];
const summary = { sourceRows: sourceRows.length, activities: roots.length + (unresolved.length ? 1 : 0), workItems: importable.length, unresolved: unresolved.map((row) => row.title) };
if (mode !== '--apply') {
  console.log(JSON.stringify(summary, null, 2));
  process.exit(0);
}

async function request(path, options = {}) {
  const response = await fetch(`http://127.0.0.1:3000/api${path}`, { headers: { 'content-type': 'application/json' }, ...options });
  const data = response.status === 204 ? null : await response.json();
  if (!response.ok) throw new Error(`${path}: ${data?.message || response.statusText}`);
  return data;
}

const project = await request('/projects', { method: 'POST', body: JSON.stringify({ projectCode: 'EDOC-2026', projectName: 'Electronic Document System (E-Doc)', portfolioName: 'Digital Transformation', startDate: '2025-09-08', targetEndDate: '2026-10-31' }) });
const projectHeaders = { 'x-project-id': project.projectId };
async function projectRequest(path, options = {}) {
  return request(path, { ...options, headers: { 'content-type': 'application/json', ...projectHeaders, ...(options.headers || {}) } });
}

const activityIds = new Map();
for (const [index, root] of roots.entries()) {
  const result = await projectRequest('/wbs', { method: 'POST', body: JSON.stringify({ wbsCode: `EDOC-${String(index + 1).padStart(2, '0')}`, wbsName: root.title, sortOrder: index + 1 }) });
  activityIds.set(root, result.wbsItemId);
}
let unresolvedActivityId = null;
if (unresolved.length) {
  const result = await projectRequest('/wbs', { method: 'POST', body: JSON.stringify({ wbsCode: 'EDOC-09', wbsName: 'Imported backlog (parent reference unavailable)', sortOrder: 9 }) });
  unresolvedActivityId = result.wbsItemId;
}

const taskIds = new Map();
for (const row of [...importable].sort((left, right) => left.depth - right.depth || left.index - right.index)) {
  const taskType = row.depth === 1 ? 'MainTask' : row.depth === 2 ? 'Task' : 'Subtask';
  let parent = row.parent;
  while (parent && (taskType === 'Subtask' ? parent.depth !== 2 : parent.depth !== row.depth - 1)) parent = parent.parent;
  const { start, due } = datesFor(row.source.Duration || row.source.Actual);
  const result = await projectRequest('/tasks', { method: 'POST', body: JSON.stringify({
    wbsItemId: row.root ? activityIds.get(row.root) : unresolvedActivityId,
    parentTaskId: taskType === 'MainTask' ? null : taskIds.get(parent),
    taskCode: `EDOC-${String(row.index + 1).padStart(3, '0')}`,
    taskType,
    taskName: row.title,
    plannedStartDate: start,
    plannedDueDate: due,
    status: statusFor(row.source.Status),
    ragStatus: ragFor(row.source.Priority),
    weight: 0,
    progress: row.source.Status === 'Done' ? 100 : 0
  }) });
  taskIds.set(row, result.taskId);
}

console.log(JSON.stringify({ ...summary, projectId: project.projectId, importedActivities: activityIds.size, importedWorkItems: taskIds.size }, null, 2));
