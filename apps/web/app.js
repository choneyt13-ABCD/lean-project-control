const content = document.querySelector('#content');
const title = document.querySelector('#page-title');
const quickAction = document.querySelector('#quick-action');
const modal = document.querySelector('#modal');
const modalContent = document.querySelector('#modal-content');
const form = document.querySelector('#modal-form');
const toast = document.querySelector('#toast');

let activeProjectId = localStorage.getItem('lean_active_project_id') || null;
let tasks = [];
let activeTaskForNotes = null;
let weeklyItems = [];
let weeklyPlans = [];
let roleUpdates = [];
let raidItems = [];
let peopleItems = [];
let assignmentItems = [];
let controlPortalSession = localStorage.getItem('lean_control_portal_session') || 'portfolio';
let portalSession = localStorage.getItem('lean_portal_session') || 'setup';
let weeklyPortalSession = localStorage.getItem('lean_weekly_portal_session') || 'weekly';
let currentTaskGrouping = localStorage.getItem('lean_task_grouping') || 'activity';
const collapsedTreeNodes = new Set();
const collapsedTaskGroups = new Set();
const collapsedParentTasks = new Set();

const api = (path, options = {}) => fetch(`/api${path}`, {
  ...options,
  headers: { 'content-type': 'application/json', ...(activeProjectId ? { 'x-project-id': activeProjectId } : {}), ...(options.headers || {}) }
}).then(async (response) => {
  const raw = response.status === 204 ? '' : await response.text();
  let data = null;
  if (raw) {
    try { data = JSON.parse(raw); } catch { data = { message: raw }; }
  }
  if (!response.ok) throw new Error(data?.message || 'Unable to save data.');
  return data;
});

const selected = (current, value) => current === value ? 'selected' : '';
const badge = (value) => {
  const v = String(value);
  let color = 'gray';
  if (v === 'InProgress') color = 'blue';
  else if (v === 'Blocked' || v.toLowerCase().includes('red')) color = 'red';
  else if (v === 'OnHold' || v === 'Hold') color = 'yellow';
  else if (v === 'Done' || v === 'Green') color = 'green';
  else if (v.toLowerCase().includes('amber')) color = 'amber';
  const label = v === 'InProgress' ? 'In progress' : v === 'NotStarted' ? 'Not started' : v === 'OnHold' ? 'On hold' : v;
  return `<span class="badge ${color}">${label}</span>`;
};
const typeBadge = (type) => {
  const t = type || 'New';
  const color = t === 'New' ? 'blue' : t === 'Change Major' ? 'purple' : t === 'Change Minor' ? 'cyan' : 'gray';
  return `<span class="badge ${color}">${t}</span>`;
};
const sizeBadge = (size) => {
  const s = size || 'Medium';
  const color = s === 'Large' ? 'amber' : s === 'Medium' ? 'blue' : 'green';
  return `<span class="badge ${color}">${s}</span>`;
};
const actions = (type, id, noteCount = 0, item = null) => {
  if (type === 'task') {
    const isMain = item?.task_type === 'MainTask';
    const isTask = item?.task_type === 'Task';
    const addBtn = isMain
      ? `<button class="primary compact-btn" data-add-task-child="${id}" title="Add Task under this Main Task">+ Task</button>`
      : isTask
      ? `<button class="secondary compact-btn" data-add-subtask-child="${id}" title="Add Subtask under this Task">+ Subtask</button>`
      : '';
    return `<span class="row-actions">${addBtn}<button data-edit-task="${id}">Edit</button><button class="danger" data-delete-task="${id}">Delete</button></span>`;
  }
  return `<span class="row-actions"><button data-edit-${type}="${id}">Edit</button><button class="danger" data-delete-${type}="${id}">Delete</button></span>`;
};
const statusOptions = (current) => ['NotStarted', 'InProgress', 'OnHold', 'Blocked', 'Done', 'Cancelled'].map((value) => `<option value="${value}" ${selected(current, value)}>${value === 'NotStarted' ? 'Not started' : value === 'InProgress' ? 'In progress' : value === 'OnHold' ? 'On hold' : value}</option>`).join('');
const ragOptions = (current) => ['Green', 'Amber', 'Red'].map((value) => `<option ${selected(current, value)}>${value}</option>`).join('');
const showToast = (message) => {
  if (modal.open) {
    let errorBox = modalContent.querySelector('.modal-error');
    if (!errorBox) {
      errorBox = document.createElement('p');
      errorBox.className = 'modal-error';
      errorBox.setAttribute('role', 'alert');
      modalContent.insertBefore(errorBox, modalContent.querySelector('.actions'));
    }
    errorBox.textContent = message;
    errorBox.scrollIntoView({ block: 'nearest' });
    return;
  }
  toast.textContent = message;
  toast.classList.add('show');
  setTimeout(() => toast.classList.remove('show'), 2600);
};
const mondayOf = (value = new Date()) => {
  const date = new Date(value);
  const day = date.getDay() || 7;
  date.setDate(date.getDate() - day + 1);
  return date.toISOString().slice(0, 10);
};
let controlWeek = localStorage.getItem('lean_control_week') || mondayOf();

async function projectContext() {
  const [current, projects] = await Promise.all([api('/project'), api('/portfolio')]);
  if (!activeProjectId && current?.project_id) {
    activeProjectId = current.project_id;
  }
  return { current, projects };
}

function contextBar(current, projects) {
  const meta = [
    current.portfolio_name || 'No portfolio',
    `${current.project_type || 'New'} (${current.project_size || 'Medium'})`,
    `PM: ${current.main_pm_name}`
  ].filter(Boolean).join(' &middot; ');
  return `<section class="project-context"><div class="project-context-summary"><span class="section-kicker">CURRENT PROJECT</span><div class="project-context-title"><span class="project-context-code">${current.project_code}</span><div><strong>${current.project_name}</strong><small>${meta}</small></div></div></div><label class="project-switcher"><span class="project-switcher-heading"><span class="project-switcher-icon" aria-hidden="true">⇄</span><span><strong>Switch project</strong><small>Change active project</small></span></span><select data-project-context>${projects.map((project) => `<option value="${project.project_id}" ${selected(current.project_id, project.project_id)}>${project.project_code} &middot; ${project.project_name} [${project.project_type || 'New'}]</option>`).join('')}</select></label></section>`;
}

async function overview() {
  const data = await api(`/master-control?weekStart=${controlWeek}`);
  const s = data.summary;
  content.innerHTML = `<section class="control-hero"><div><span class="section-kicker">MASTER PROJECT CONTROL</span><h2>Overall delivery control</h2><p>One view of every project you hold, this week's commitments, role updates, and delivery attention.</p></div><label class="week-control"><span>Week starting</span><input type="date" value="${data.weekStart}" data-control-week></label></section>
  <div class="cards"><div class="card"><p>Projects held</p><div class="metric">${s.projectCount}</div><p>${s.completed} of ${s.taskCount} work items done</p></div><div class="card"><p>Portfolio progress</p><div class="metric">${s.progress}%</div><div class="progress"><span style="width:${s.progress}%"></span></div></div><div class="card"><p>Weekly plan</p><div class="metric">${s.planDone}<span class="subtle"> / ${s.planCount}</span></div><p>commitments completed</p></div><div class="card"><p>Needs attention</p><div class="metric">${s.blocked + s.overdue}</div><p>${s.blocked} blocked &middot; ${s.overdue} overdue</p></div></div>
  <section class="panel"><div class="panel-head"><div><h2>Project master report</h2><span class="subtle">Live totals calculated from the source work items, RAID, plans, and updates.</span></div><button class="secondary" data-go="portfolio">Open portfolio</button></div><div class="table-wrap"><table class="table master-table"><thead><tr><th>PROJECT</th><th>TYPE / SIZE</th><th>PM</th><th>PROGRESS</th><th>HEALTH</th><th>WEEKLY PLAN</th><th>ROLE UPDATES</th><th>ATTENTION</th><th></th></tr></thead><tbody>${data.projects.map((project) => `<tr><td><span class="code">${project.project_code}</span><strong>${project.project_name}</strong></td><td>${typeBadge(project.project_type)} ${sizeBadge(project.project_size)}</td><td>${project.main_pm_name}</td><td><strong>${project.progress}%</strong><div class="progress compact"><span style="width:${project.progress}%"></span></div></td><td>${badge(project.calculatedRag)}</td><td>${project.planDone} / ${project.planCount}</td><td>${project.roleUpdateCount}</td><td>${project.blocked + project.overdue ? `<span class="attention-count">${project.blocked + project.overdue}</span>` : '<span class="badge green">Clear</span>'}</td><td><button class="secondary" data-select-project="${project.project_id}" data-go="updates">Manage</button></td></tr>`).join('')}</tbody></table></div></section>
  <div class="two-col control-columns"><section class="panel"><div class="panel-head"><div><h2>This week's commitments</h2><span class="subtle">Plan versus actual across projects.</span></div><button class="secondary" data-go="updates">Open weekly workspace</button></div>${data.plans.length ? data.plans.slice(0, 8).map((item) => `<article class="control-list-row"><div><span class="code">${item.project_code}${item.task_code ? ` &middot; ${item.task_code}` : ''}</span><strong>${item.plan_title}</strong><small>${item.owner_name}${item.owner_role ? ` &middot; ${item.owner_role}` : ''}</small></div>${badge(item.status)}</article>`).join('') : '<p class="empty">No commitments planned for this week yet.</p>'}</section><section class="panel"><div class="panel-head"><div><h2>Role movement updates</h2><span class="subtle">A concise update by person and role.</span></div></div>${data.roleUpdates.length ? data.roleUpdates.slice(0, 8).map((item) => `<article class="control-list-row"><div><span class="code">${item.project_code} &middot; ${item.role_name}</span><strong>${item.display_name}</strong><small>${item.accomplished || item.next_actions || item.blocker || item.support_needed}</small></div>${item.blocker ? '<span class="badge red">Blocker</span>' : '<span class="badge green">Updated</span>'}</article>`).join('') : '<p class="empty">No role updates recorded for this week.</p>'}</section></div>`;
}

async function portfolio() {
  const projects = await api('/portfolio');
  content.innerHTML = `<section class="portfolio-intro"><div><span class="section-kicker">PORTFOLIO VIEW</span><h2>Project delivery at a glance</h2><p>Compare project health, then select one project to manage its work.</p></div><div class="portfolio-total"><strong>${projects.length}</strong><span>active projects</span></div></section><div class="portfolio-projects">${projects.map((project) => `<section class="panel portfolio-project"><div class="panel-head"><div><div style="display:flex;align-items:center;gap:7px;margin-bottom:5px"><span class="code" style="margin-bottom:0">${project.project_code}</span>${typeBadge(project.project_type)}${sizeBadge(project.project_size)}</div><h2>${project.project_name}</h2><span class="subtle">${project.portfolio_name ? `${project.portfolio_name} &middot; ` : ''}Main PM: ${project.main_pm_name}</span></div><button class="secondary" data-select-project="${project.project_id}" data-go="tasks">Manage work items</button></div><div class="project-kpis"><div><span>Progress</span><strong>${project.progress}%</strong></div><div><span>Completed</span><strong>${project.completed} / ${project.taskCount}</strong></div><div><span>Open RAID</span><strong>${project.openRaid}</strong></div><div><span>High severity</span><strong>${project.highRaid}</strong></div></div></section>`).join('')}</div>`;
}

function buildTaskGroups(items, grouping) {
  if (!items.length) return [];
  if (grouping === 'none') {
    const completed = items.filter((t) => t.status === 'Done').length;
    const avgProgress = Math.round(items.reduce((s, t) => s + (t.progress || 0), 0) / items.length);
    const groupRag = items.some((t) => t.rag_status === 'Red') ? 'Red' : items.some((t) => t.rag_status === 'Amber') ? 'Amber' : 'Green';
    return [{
      key: 'all',
      code: '',
      name: 'All Work Items',
      badgeLabel: 'Flat list',
      total: items.length,
      completed,
      avgProgress,
      groupRag,
      items
    }];
  }

  const map = new Map();
  for (const task of items) {
    let key, name, code = '', badgeLabel = '';
    if (grouping === 'activity') {
      key = `wbs:${task.wbs_item_id || 'unassigned'}`;
      code = task.wbs_code || '';
      name = task.wbs_name || 'Unassigned Activity';
      badgeLabel = task.phase_name ? `${task.phase_code || 'PHASE'}: ${task.phase_name}` : 'WBS Activity';
    } else if (grouping === 'workstream') {
      const ws = (task.workstream || '').trim();
      key = `ws:${ws || 'general'}`;
      code = ws ? 'STREAM' : '';
      name = ws || 'General / Unassigned Stream';
      badgeLabel = 'Workstream Group';
    } else if (grouping === 'phase') {
      const ph = (task.phase_name || '').trim();
      key = `phase:${task.phase_id || 'unassigned'}`;
      code = task.phase_code || '';
      name = ph || 'Unassigned Phase';
      badgeLabel = 'Implementation Phase';
    } else if (grouping === 'status') {
      key = `status:${task.status}`;
      name = task.status === 'InProgress' ? 'In progress' : task.status === 'NotStarted' ? 'Not started' : task.status;
      badgeLabel = 'Status Group';
    } else if (grouping === 'owner') {
      key = `owner:${task.owner_person_id || 'unassigned'}`;
      name = task.owner_name || 'Unassigned';
      badgeLabel = 'Owner Group';
    }

    if (!map.has(key)) {
      map.set(key, { key, code, name, badgeLabel, items: [] });
    }
    map.get(key).items.push(task);
  }

  return [...map.values()].map((g) => {
    const total = g.items.length;
    const completed = g.items.filter((t) => t.status === 'Done').length;
    const avgProgress = Math.round(g.items.reduce((s, t) => s + (t.progress || 0), 0) / total);
    const groupRag = g.items.some((t) => t.rag_status === 'Red') ? 'Red' : g.items.some((t) => t.rag_status === 'Amber') ? 'Amber' : 'Green';
    return { ...g, total, completed, avgProgress, groupRag };
  });
}

function flattenTaskHierarchy(items, collapsedParents = new Set()) {
  const childrenMap = new Map();
  const itemMap = new Map();
  const roots = [];

  items.forEach((item) => itemMap.set(item.task_id, item));

  items.forEach((item) => {
    if (item.parent_task_id && itemMap.has(item.parent_task_id)) {
      if (!childrenMap.has(item.parent_task_id)) childrenMap.set(item.parent_task_id, []);
      childrenMap.get(item.parent_task_id).push(item);
    } else {
      roots.push(item);
    }
  });

  const result = [];
  function traverse(task, depth, isHidden) {
    const children = childrenMap.get(task.task_id) || [];
    const hasChildren = children.length > 0;
    const isCollapsed = collapsedParents.has(task.task_id);

    if (!isHidden) {
      result.push({
        ...task,
        depth,
        hasChildren,
        childCount: children.length,
        isCollapsed
      });
    }

    if (hasChildren) {
      children.forEach((child) => {
        traverse(child, depth + 1, isHidden || isCollapsed);
      });
    }
  }

  roots.forEach((root) => traverse(root, 0, false));
  return result;
}

async function workBreakdown() {
  const [{ current, projects }, workItems] = await Promise.all([projectContext(), api('/tasks')]);
  tasks = workItems;
  const groups = buildTaskGroups(tasks, currentTaskGrouping);

  const groupOptions = [
    { value: 'activity', label: 'Activity (WBS)' },
    { value: 'workstream', label: 'Workstream / Custom Group' },
    { value: 'phase', label: 'Implementation Phase' },
    { value: 'status', label: 'Status' },
    { value: 'owner', label: 'Owner / Assignee' },
    { value: 'none', label: 'None (Flat list)' }
  ].map((opt) => `<option value="${opt.value}" ${selected(currentTaskGrouping, opt.value)}>${opt.label}</option>`).join('');

  const groupsHtml = groups.length ? groups.map((group) => {
    const isCollapsed = collapsedTaskGroups.has(group.key);
    const flatHierarchy = flattenTaskHierarchy(group.items, collapsedParentTasks);
    const groupTypePill = currentTaskGrouping === 'activity'
      ? '<span class="type-pill wbs-pill">WBS</span>'
      : currentTaskGrouping === 'phase'
      ? '<span class="type-pill phase-pill">PHASE</span>'
      : currentTaskGrouping === 'workstream' && group.code
      ? '<span class="type-pill stream-pill">STREAM</span>'
      : '';
    const groupCodeClass = currentTaskGrouping === 'activity'
      ? 'wbs-code-pill'
      : currentTaskGrouping === 'phase'
      ? 'phase-code-pill'
      : '';
    let groupAction = '';
    if (currentTaskGrouping === 'phase') {
      const phaseId = group.key.replace('phase:', '');
      groupAction = group.key === 'phase:unassigned'
        ? '<button class="secondary compact-btn" data-create-phase-from-unassigned>Create phase</button>'
        : `<div class="row-actions"><button class="secondary compact-btn" data-add-activity-to-phase="${phaseId}" title="Add Activity under this Phase">+ Activity</button><button class="secondary compact-btn" data-edit-phase="${phaseId}">Edit</button><button class="danger compact-btn" data-delete-phase="${phaseId}">Delete</button></div>`;
    } else if (currentTaskGrouping === 'activity') {
      const wbsId = group.key.replace('wbs:', '');
      groupAction = wbsId === 'unassigned'
        ? ''
        : `<div class="row-actions"><button class="secondary compact-btn" data-add-task-to-wbs="${wbsId}" title="Add Main Task under this Activity">+ Main Task</button><button class="secondary compact-btn" data-edit-activity="${wbsId}">Edit</button><button class="danger compact-btn" data-delete-activity="${wbsId}">Delete</button></div>`;
    }
    groupAction = '';

    return `
      <section class="task-group ${isCollapsed ? 'collapsed' : ''}" data-group-key="${group.key}">
        <div class="task-group-head" data-group-toggle="${group.key}">
          <div class="task-group-title">
            <button type="button" class="group-toggle-btn" aria-label="${isCollapsed ? 'Expand' : 'Collapse'}">${isCollapsed ? '▸' : '▾'}</button>
            <div>
              <div class="task-group-name">
                ${groupTypePill}
                ${group.code ? `<span class="group-code-pill ${groupCodeClass}">${group.code}</span>` : ''}
                <strong>${group.name}</strong>
                <span class="group-count-pill">${group.total} item${group.total > 1 ? 's' : ''}</span>
                ${badge(group.groupRag)}
              </div>
              <small class="group-badge-sub">${group.badgeLabel}</small>
            </div>
          </div>
          <div class="task-group-summary">
            ${groupAction}
            <div class="task-group-progress-box">
              <div class="progress"><span style="width:${group.avgProgress}%"></span></div>
              <div class="group-progress-meta">
                <strong>${group.avgProgress}%</strong>
                <span>${group.completed}/${group.total} Done</span>
              </div>
            </div>
          </div>
        </div>
        ${!isCollapsed ? `
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th>WORK ITEM / HIERARCHY</th>
                  ${currentTaskGrouping !== 'workstream' ? '<th>WORKSTREAM</th>' : ''}
                  ${currentTaskGrouping !== 'activity' ? '<th>ACTIVITY (WBS)</th>' : ''}
                  ${currentTaskGrouping !== 'owner' ? '<th>OWNER</th>' : ''}
                  ${currentTaskGrouping !== 'status' ? '<th>STATUS</th>' : ''}
                  <th>RAG</th>
                  <th>PROGRESS</th>
                  <th>ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                ${flatHierarchy.map((task) => {
                  const isMain = task.task_type === 'MainTask';
                  const indentClass = `task-indent-${Math.min(task.depth, 2)}`;
                  const toggleBtn = task.hasChildren ? `
                    <button type="button" class="subtask-toggle-btn" data-parent-toggle="${task.task_id}" aria-label="${task.isCollapsed ? 'Expand subtasks' : 'Collapse subtasks'}">${task.isCollapsed ? '▸' : '▾'}</button>
                  ` : (task.depth > 0 ? '<span class="tree-branch-icon">↳</span>' : '');
                  const typeClass = task.task_type === 'MainTask' ? 'main-task' : task.task_type === 'Task' ? 'task-level' : 'subtask-level';
                  const typeDisplay = task.task_type === 'MainTask' ? 'MAIN TASK' : task.task_type === 'Task' ? 'TASK' : 'SUBTASK';

                  return `
                    <tr class="${isMain ? 'task-row-main' : 'task-row-child'}">
                      <td>
                        <div class="task-cell-content ${indentClass}">
                          ${toggleBtn}
                          <div class="task-title-wrap">
                            <div class="task-code-line">
                              <span class="type-pill ${typeClass}">${typeDisplay}</span>
                              <span class="code inline-code">${task.task_code}</span>
                              ${task.hasChildren ? `<span class="subtask-count-tag">${task.childCount} sub-item${task.childCount > 1 ? 's' : ''}</span>` : ''}
                            </div>
                            <strong>${task.task_name}</strong>
                          </div>
                        </div>
                      </td>
                      ${currentTaskGrouping !== 'workstream' ? `<td>${task.workstream ? `<span class="workstream-pill">${task.workstream}</span>` : '<span class="subtle">—</span>'}</td>` : ''}
                      ${currentTaskGrouping !== 'activity' ? `<td><span class="type-pill wbs-pill">WBS</span> <span class="code inline-code">${task.wbs_code}</span> ${task.wbs_name}</td>` : ''}
                      ${currentTaskGrouping !== 'owner' ? `<td>${task.owner_name}</td>` : ''}
                  ${currentTaskGrouping !== 'status' ? `<td>${badge(task.status)}</td>` : ''}
                  <td>${badge(task.rag_status || 'Green')}</td>
                  <td><strong>${task.progress}%</strong></td>
                  <td><div class="row-actions"><button data-open-task-history="${task.task_id}">Update &amp; history</button></div></td>
                    </tr>
                  `;
                }).join('')}
              </tbody>
            </table>
          </div>
        ` : ''}
      </section>
    `;
  }).join('') : '<p class="empty">No work items in this project yet. Add activities and work items from Structure & timeline.</p>';

  content.innerHTML = `
    ${contextBar(current, projects)}
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2>Work items</h2>
          <span class="subtle">Operational workspace for managing deliverables, progress, and assignments.</span>
        </div>
        <div class="row-actions work-items-controls">
          <label class="group-filter-control">
            <span>Group by</span>
            <select data-task-group-by>${groupOptions}</select>
          </label>
          <span class="subtle">Structure changes are managed in Project Builder.</span>
        </div>
      </div>
      <div class="task-groups-container">
        ${groupsHtml}
      </div>
    </section>
  `;
}

function expandableNode({ key, depth, type, code, name, status, phaseId, wbsId, taskId, taskItem, children = [] }) {
  const hasChildren = children.length > 0;
  const expanded = !collapsedTreeNodes.has(key);
  const toggle = hasChildren ? `<button class="tree-toggle" data-tree-toggle="${key}" aria-label="${expanded ? 'Collapse' : 'Expand'} ${name}">${expanded ? '▾' : '▸'}</button>` : '<span class="tree-spacer"></span>';
  const childMarkup = hasChildren && expanded ? children.map(expandableNode).join('') : '';
  const typeUpper = String(type).toUpperCase();
  const typeClass = type === 'MainTask' || typeUpper === 'MAINTASK' ? 'main-task' : type === 'Task' || typeUpper === 'TASK' ? 'task-level' : type === 'Subtask' || typeUpper === 'SUBTASK' ? 'subtask-level' : typeUpper === 'ACTIVITY' || typeUpper === 'WBS' ? 'wbs-pill' : typeUpper === 'PHASE' ? 'phase-pill' : 'stream-pill';
  const displayLabel = typeUpper === 'MAINTASK' || type === 'MainTask' ? 'MAIN TASK' : typeUpper === 'ACTIVITY' ? 'WBS' : type;
  const ownerBadge = taskItem?.owner_name ? `<span class="badge gray" style="font-size:11px;font-weight:600;padding:1px 6px">👤 ${taskItem.owner_name}</span>` : '';
  const dueBadge = taskItem?.planned_due_date ? `<span class="subtle" style="font-size:11px">📅 ${taskItem.planned_due_date}</span>` : '';

  let actionBtns = '';
  if (typeUpper === 'PHASE' && phaseId) {
    actionBtns = `<button class="secondary compact-btn" data-add-activity-to-phase="${phaseId}" title="Add Activity under this Phase">+ Activity</button><button class="secondary compact-btn" data-edit-phase="${phaseId}">Edit</button><button class="danger compact-btn" data-delete-phase="${phaseId}">Delete</button>`;
  } else if (typeUpper === 'ACTIVITY' && wbsId) {
    actionBtns = `<button class="secondary compact-btn" data-add-task-to-wbs="${wbsId}" title="Add Main Task under this Activity">+ Main Task</button><button class="secondary compact-btn" data-edit-activity="${wbsId}">Edit</button><button class="danger compact-btn" data-delete-activity="${wbsId}">Delete</button>`;
  } else if (type === 'MainTask' && taskId) {
    actionBtns = `<button class="primary compact-btn" data-add-task-child="${taskId}" title="Add Task under this Main Task">+ Task</button><button class="secondary compact-btn" data-edit-task="${taskId}">Edit</button><button class="danger compact-btn" data-delete-task="${taskId}">Delete</button>`;
  } else if (type === 'Task' && taskId) {
    actionBtns = `<button class="secondary compact-btn" data-add-subtask-child="${taskId}" title="Add Subtask under this Task">+ Subtask</button><button class="secondary compact-btn" data-edit-task="${taskId}">Edit</button><button class="danger compact-btn" data-delete-task="${taskId}">Delete</button>`;
  } else if (type === 'Subtask' && taskId) {
    actionBtns = `<button class="secondary compact-btn" data-edit-task="${taskId}">Edit</button><button class="danger compact-btn" data-delete-task="${taskId}">Delete</button>`;
  }

  return `<div class="tree-node" style="--tree-depth:${depth}"><div class="tree-row"><span class="tree-rail"></span>${toggle}<div class="tree-node-copy"><div class="task-code-line"><span class="type-pill ${typeClass}">${displayLabel}</span>${code ? `<span class="code inline-code">${code}</span>` : ''}${ownerBadge}${dueBadge}</div><strong>${name}</strong></div>${status ? badge(status) : ''}<div class="tree-actions">${actionBtns}</div></div>${childMarkup}</div>`;
}

function expandableHierarchy(activities, rows, phases = []) {
  const taskChildren = new Map();
  rows.forEach((task) => {
    const parentKey = task.parent_task_id || `activity:${task.wbs_item_id}`;
    taskChildren.set(parentKey, [...(taskChildren.get(parentKey) || []), task]);
  });
  const toTaskNode = (task, depth) => ({
    key: `task:${task.task_id}`, depth, type: task.task_type, code: task.task_code, name: task.task_name, status: task.status,
    taskId: task.task_id, taskItem: task,
    children: (taskChildren.get(task.task_id) || []).map((child) => toTaskNode(child, depth + 1))
  });
  const groups = new Map(phases.map((phase) => [phase.phase_id, { key: phase.phase_id, phaseId: phase.phase_id, name: phase.phase_name, code: phase.phase_code, activities: [] }]));
  activities.forEach((activity) => {
    const groupKey = activity.phase_id || 'unassigned';
    const group = groups.get(groupKey) || { key: groupKey, phaseId: activity.phase_id, name: activity.phase_name || 'Unassigned heading', code: activity.phase_code || '', activities: [] };
    group.activities.push(activity);
    groups.set(groupKey, group);
  });
  return [...groups.values()].map((group) => ({
    key: `phase:${group.key}`, depth: 0, type: 'PHASE', code: group.code, name: group.name, phaseId: group.phaseId,
    children: group.activities.map((activity) => ({
      key: `activity:${activity.wbs_item_id}`, depth: 1, type: 'ACTIVITY', code: activity.wbs_code, name: activity.wbs_name, wbsId: activity.wbs_item_id,
      children: (taskChildren.get(`activity:${activity.wbs_item_id}`) || []).map((task) => toTaskNode(task, 2))
    }))
  })).map(expandableNode).join('');
}

async function structureEditable() {
  const [{ current, projects }, activities, rows, phases] = await Promise.all([projectContext(), api('/wbs'), api('/tasks'), api('/phases')]);
  tasks = rows;
  const unassigned = activities.filter((activity) => !activity.phase_id);
  content.innerHTML = `${contextBar(current, projects)}
    <section class="panel">
      <div class="panel-head"><div><span class="section-kicker">PROJECT BUILDER</span><h2>Project structure</h2><span class="subtle">Create and arrange Phase → Activity → Main Task → Task → Subtask in one connected tree.</span></div><div class="row-actions"><button class="secondary compact-btn" data-open-phase>+ Phase</button><button class="primary" data-open-activity>+ Activity</button></div></div>
      ${unassigned.length ? `<div class="import-conflicts"><strong>${unassigned.length} Activity needs attention</strong><p>These Activities were created without a Phase before the new rule. Select Edit and assign each one to the correct Phase.</p></div>` : ''}
      <div class="hierarchy-tree">${expandableHierarchy(activities, rows, phases) || '<p class="empty">Add a Phase, then add an Activity below it to begin.</p>'}</div>
    </section>`;
  return;
  const indent = { MainTask: 'main', Task: 'task', Subtask: 'subtask' };
  const gantt = rows.map((task, index) => `<div class="gantt-row"><div><span class="code">${task.task_type} &middot; ${task.wbs_code}</span><strong>${task.task_name}</strong></div><div class="gantt-track"><span class="gantt-bar ${String(task.rag_status).toLowerCase()}" style="left:${(index * 9) % 55}%;width:${Math.max(18, task.progress || 20)}%">${task.progress}%</span></div></div>`).join('');
  content.innerHTML = `${contextBar(current, projects)}<section class="panel"><div class="panel-head"><div><h2>Structure & timeline</h2><span class="subtle">Set up WBS activities and the parent-child delivery structure. Status changes belong in Work items.</span></div><div class="row-actions"><button class="secondary compact-btn" data-open-phase>+ Add phase</button><button class="secondary compact-btn" data-open-activity>+ Add activity</button><button class="primary" data-open-task>+ Add work item</button></div></div>${activities.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ACTIVITY</th><th>CODE</th><th>WORK ITEMS</th><th>ACTIONS</th></tr></thead><tbody>${activities.map((activity) => `<tr><td><strong>${activity.wbs_name}</strong></td><td>${activity.wbs_code}</td><td>${activity.task_count}</td><td><div class="row-actions"><button class="secondary compact-btn" data-add-task-to-wbs="${activity.wbs_item_id}">+ Main Task</button>${actions('activity', activity.wbs_item_id)}</div></td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">Start by adding a project activity.</p>'}</section><section class="panel"><div class="panel-head"><div><h2>Work hierarchy</h2><span class="subtle">Manage deliverables and tasks directly across all levels.</span></div><div class="row-actions"><button class="secondary compact-btn" data-open-task>+ Add work item</button><button class="secondary compact-btn" data-go="tasks">Open work items view</button></div></div>${rows.length ? `<div class="table-wrap"><table class="table hierarchy-table"><thead><tr><th>ACTIVITY</th><th>LEVEL</th><th>WORK ITEM</th><th>PLAN END</th><th>PROGRESS</th><th>ACTIONS</th></tr></thead><tbody>${rows.map((task) => `<tr><td>${task.wbs_code}</td><td>${task.task_type}</td><td><div class="hierarchy-name ${indent[task.task_type]}"><span class="code">${task.task_code}</span><strong>${task.task_name}</strong></div></td><td>${task.planned_due_date || '—'}</td><td>${task.progress}%</td><td>${actions('task', task.task_id, task.note_count, task)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No work items yet.</p>'}</section><section class="panel"><div class="panel-head"><div><h2>Timeline</h2><span class="subtle">Visual view of work progress.</span></div></div><div class="gantt">${gantt || '<p class="empty">No work items yet.</p>'}</div></section>`;
  content.insertAdjacentHTML('beforeend', `<section class="panel hierarchy-tree-panel"><div class="panel-head"><div><h2>Expandable delivery tree</h2><span class="subtle">Select the arrow to expand or collapse each heading, Activity, and work item. Manage them directly with inline actions.</span></div></div><div class="hierarchy-tree">${expandableHierarchy(activities, rows) || '<p class="empty">Add a heading or Activity to start the delivery tree.</p>'}</div></section>`);
}

async function weeklyUpdatesEditable() {
  const [{ current, projects }, updates, plans, roleItems] = await Promise.all([projectContext(), api('/weekly-updates'), api(`/weekly-plans?weekStart=${controlWeek}`), api(`/role-updates?weekStart=${controlWeek}`)]);
  weeklyItems = updates;
  weeklyPlans = plans;
  roleUpdates = roleItems;
  content.innerHTML = `${contextBar(current, projects)}<section class="weekly-hero"><div><span class="section-kicker">WEEKLY CONTROL CYCLE</span><h2>Plan, update, and unblock</h2><p>Plan commitments first, record actual task movement, then summarize each role's contribution.</p></div><label class="week-control"><span>Week starting</span><input type="date" value="${controlWeek}" data-control-week></label></section>
  <section class="panel"><div class="panel-head"><div><h2>1. Weekly plan</h2><span class="subtle">The commitments and expected outcomes for this project.</span></div><button class="primary" data-open-weekly-plan>+ Add plan</button></div>${plans.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>COMMITMENT</th><th>OWNER / ROLE</th><th>DUE</th><th>PRIORITY</th><th>STATUS</th><th>ACTIONS</th></tr></thead><tbody>${plans.map((item) => `<tr><td><strong>${item.plan_title}</strong><span class="code inline-code">${item.task_code ? `${item.task_code} &middot; ${item.task_name}` : 'Project-level commitment'}</span>${item.target_outcome ? `<small>${item.target_outcome}</small>` : ''}</td><td>${item.owner_name}<small>${item.owner_role || 'Role not specified'}</small></td><td>${item.planned_due_date || '—'}</td><td>${badge(item.priority)}</td><td>${badge(item.status)}</td><td>${actions('plan', item.weekly_plan_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No commitments for this week. Add a plan to make the weekly target visible.</p>'}</section>
  <section class="panel"><div class="panel-head"><div><h2>2. Task progress updates</h2><span class="subtle">Actual movement against a work item. This also updates its status, RAG, and progress.</span></div><button class="primary" data-open-update>+ Add task update</button></div>${updates.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>WORK ITEM</th><th>WEEK OF</th><th>STATUS</th><th>RAG</th><th>SUMMARY</th><th>ACTIONS</th></tr></thead><tbody>${updates.map((item) => `<tr><td><strong>${item.task_name}</strong></td><td>${item.week_start_date}</td><td>${badge(item.status)}</td><td>${badge(item.rag_status)}</td><td>${item.summary}</td><td>${actions('update', item.weekly_update_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No task progress updates yet.</p>'}</section>
  <section class="panel"><div class="panel-head"><div><h2>3. Role updates</h2><span class="subtle">A concise movement summary per person and role, without duplicating task detail.</span></div><button class="primary" data-open-role-update>+ Add role update</button></div>${roleItems.length ? `<div class="role-update-grid">${roleItems.map((item) => `<article class="role-update-card"><div class="role-update-head"><div><span class="code">${item.role_name}</span><h3>${item.display_name}</h3></div>${item.blocker ? '<span class="badge red">Blocker</span>' : '<span class="badge green">Updated</span>'}</div>${item.accomplished ? `<div><small>ACCOMPLISHED</small><p>${item.accomplished}</p></div>` : ''}${item.next_actions ? `<div><small>NEXT ACTIONS</small><p>${item.next_actions}</p></div>` : ''}${item.blocker ? `<div><small>BLOCKER</small><p>${item.blocker}</p></div>` : ''}${item.support_needed ? `<div><small>SUPPORT NEEDED</small><p>${item.support_needed}</p></div>` : ''}<div class="row-actions">${actions('role', item.role_update_id)}</div></article>`).join('')}</div>` : '<p class="empty">No role update for this week yet.</p>'}</section>`;
}

async function pmActions() {
  const [{ current, projects }, workItems, updates, raids] = await Promise.all([projectContext(), api('/tasks'), api('/weekly-updates'), api('/raid')]);
  const blockedTasks = workItems.filter((item) => item.status === 'Blocked' || item.rag_status === 'Red');
  const blockedUpdates = updates.filter((item) => item.status === 'Blocked' || item.rag_status === 'Red');
  const openRaids = raids.filter((item) => item.status !== 'Closed');
  const attentionCard = (count, label, detail, page) => `<article class="attention-card"><strong>${count}</strong><div><h3>${label}</h3><p>${detail}</p></div><button class="secondary" data-go="${page}">Review</button></article>`;
  content.innerHTML = `${contextBar(current, projects)}<section class="panel"><div class="panel-head"><div><h2>Delivery attention</h2><span class="subtle">A triage view only. Update the original record in its dedicated workspace.</span></div></div><div class="attention-grid">${attentionCard(blockedTasks.length, 'Blocked or at-risk work', 'Update delivery status in Work items.', 'tasks')}${attentionCard(blockedUpdates.length, 'Blocked weekly updates', 'Review delivery notes in Weekly workspace.', 'updates')}${attentionCard(openRaids.length, 'Open RAID items', 'Assess, mitigate, or close items in RAID register.', 'raid')}</div></section><section class="panel"><div class="panel-head"><div><h2>Items requiring attention</h2><span class="subtle">Only exceptions are listed here; this is not another register.</span></div></div>${[...blockedTasks.map((item) => `<div class="attention-row"><span>${badge(item.rag_status || item.status)}</span><div><span class="code">WORK ITEM &middot; ${item.task_code}</span><strong>${item.task_name}</strong></div><button class="text-button" data-go="tasks">Open work items</button></div>`), ...blockedUpdates.map((item) => `<div class="attention-row"><span>${badge(item.rag_status || item.status)}</span><div><span class="code">WEEKLY UPDATE &middot; ${item.week_start_date}</span><strong>${item.task_name}</strong></div><button class="text-button" data-go="updates">Open weekly workspace</button></div>`), ...openRaids.map((item) => `<div class="attention-row"><span>${badge(item.severity_score ? `Score ${item.severity_score}` : item.status)}</span><div><span class="code">RAID &middot; ${item.raid_code}</span><strong>${item.title}</strong></div><button class="text-button" data-go="raid">Open RAID register</button></div>`)].join('') || '<p class="empty">No blocked, at-risk, or open RAID items.</p>'}</section>`;
}

async function raidEditable() {
  const [{ current, projects }, items] = await Promise.all([projectContext(), api('/raid')]);
  raidItems = items;
  content.innerHTML = `${contextBar(current, projects)}<section class="panel"><div class="panel-head"><div><h2>RAID register</h2><span class="subtle">Manage risks, assumptions, issues, and dependencies.</span></div><button class="primary" data-open-raid>+ Add RAID item</button></div>${items.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>CODE</th><th>TYPE</th><th>TITLE</th><th>OWNER</th><th>SCORE</th><th>STATUS</th><th>ACTIONS</th></tr></thead><tbody>${items.map((item) => `<tr><td>${item.raid_code}</td><td>${badge(item.raid_type)}</td><td><strong>${item.title}</strong></td><td>${item.owner_name}</td><td>${item.severity_score || '—'}</td><td>${badge(item.status)}</td><td>${actions('raid', item.raid_item_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No RAID items yet.</p>'}</section>`;
}

async function adminEditable() {
  const [{ current, projects }, people, assignments, roles] = await Promise.all([
    projectContext(),
    api('/project-members'),
    api('/assignments'),
    api('/roles').catch(() => [])
  ]);
  peopleItems = people;
  assignmentItems = assignments;
  const rolesPanel = `<section class="panel"><div class="panel-head"><div><h2>Team roles (Master data)</h2><span class="subtle">Define project roles, responsibilities, and functional titles.</span></div><div class="row-actions"><button class="secondary" data-seed-roles>Use standard roles</button><button class="primary" data-open-role-master>+ Add team role</button></div></div>${roles.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ORDER</th><th>CODE</th><th>ROLE NAME</th><th>DESCRIPTION</th><th>MEMBERS</th><th>ACTIONS</th></tr></thead><tbody>${roles.map((role) => `<tr><td>${role.sort_order}</td><td><span class="code inline-code">${role.role_code}</span></td><td><strong>${role.role_name}</strong></td><td>${role.description || '—'}</td><td>${role.member_count}</td><td><div class="row-actions"><button class="secondary" data-edit-role-master="${role.role_id}">Edit</button><button class="secondary" data-delete-role-master="${role.role_id}">Delete</button></div></td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No team roles defined yet. Add custom roles or use standard templates.</p>'}</section>`;
  content.innerHTML = `${contextBar(current, projects)}<section class="panel"><div class="panel-head"><div><h2>Team members</h2><span class="subtle">Only people assigned to this project appear here and can be selected as an Owner or Assignee.</span></div><div class="row-actions"><button class="secondary" data-open-existing-person>+ Add existing people</button><button class="primary" data-open-person>+ Add person</button></div></div>${people.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>PERSON</th><th>TEAM / ROLE</th><th>STATUS</th><th>ACTIONS</th></tr></thead><tbody>${people.map((person) => `<tr><td><strong>${person.display_name}</strong><span class="code">${person.employee_code}</span></td><td>${person.department || 'Not specified'}<small class="cell-note">${person.project_role || 'No role'}${person.position_title ? ` &middot; ${person.position_title}` : ''}</small></td><td>${badge(person.person_status)}</td><td>${actions('person', person.person_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No project members yet. Add existing people or create a new person.</p>'}</section>${rolesPanel}<section class="panel"><div class="panel-head"><div><h2>Current assignments</h2><span class="subtle">One work item can have multiple contributors.</span></div><button class="primary" data-open-assignment>+ Assign work</button></div>${assignments.length ? `<div class="assignment-list">${assignments.map((assignment) => `<article class="assignment-item"><div class="assignment-icon">${assignment.task_code.slice(-2)}</div><div><span class="code">${assignment.task_code}</span><strong>${assignment.task_name}</strong><small>${assignment.display_name}</small></div>${badge(assignment.assignment_role)}${actions('assignment', assignment.task_assignment_id)}</article>`).join('')}</div>` : '<p class="empty">No assignments yet.</p>'}</section>`;
}

async function audit() {
  const [{ current, projects }, entries] = await Promise.all([projectContext(), api('/audit')]);
  content.innerHTML = `${contextBar(current, projects)}<section class="panel"><div class="panel-head"><div><h2>Activity log</h2><span class="subtle">Auditable record of changes for this project.</span></div></div><div class="table-wrap"><table class="table"><thead><tr><th>WHEN</th><th>ACTION</th><th>ENTITY</th><th>ACTOR</th></tr></thead><tbody>${entries.map((entry) => `<tr><td>${new Date(entry.occurred_at.replace(' ', 'T') + 'Z').toLocaleString()}</td><td><strong>${entry.action}</strong></td><td>${entry.entity_type}</td><td>${entry.actor_name || 'System'}</td></tr>`).join('')}</tbody></table></div></section>`;
}

async function projectSetup() {
  const [{ current, projects: activeProjects }, allProjects, phases, workstreams, roles, projectTypeList] = await Promise.all([
    projectContext(),
    api('/projects'),
    api('/phases'),
    api('/workstreams'),
    api('/roles').catch(() => []),
    api('/project-types')
  ]);
  const phasePanel = `<section class="panel"><div class="panel-head"><div><h2>Implementation phases</h2><span class="subtle">Set delivery stages first, then place each Activity into its Phase.</span></div><div class="row-actions"><button class="secondary" data-seed-phases>Use standard phases</button><button class="primary" data-open-phase>+ Add phase</button></div></div>${phases.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ORDER</th><th>PHASE</th><th>PLANNED WINDOW</th><th>ACTIVITIES</th><th>ACTIONS</th></tr></thead><tbody>${phases.map((phase) => `<tr><td>${phase.sort_order}</td><td><strong>${phase.phase_name}</strong><span class="code inline-code">${phase.phase_code}</span></td><td>${phase.planned_start_date || '—'} ${phase.planned_due_date ? `→ ${phase.planned_due_date}` : ''}</td><td>${phase.activity_count}</td><td>${actions('phase', phase.phase_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No phases yet. Add your own, or start with Plan → Go Live.</p>'}</section>`;
  const workstreamPanel = `<section class="panel"><div class="panel-head"><div><h2>Workstreams (Master data)</h2><span class="subtle">Define functional domains or specialized delivery streams to categorize work items.</span></div><div class="row-actions"><button class="secondary" data-seed-workstreams>Use standard workstreams</button><button class="primary" data-open-workstream>+ Add workstream</button></div></div>${workstreams.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ORDER</th><th>CODE</th><th>WORKSTREAM NAME</th><th>DESCRIPTION</th><th>TASKS</th><th>ACTIONS</th></tr></thead><tbody>${workstreams.map((ws) => `<tr><td>${ws.sort_order}</td><td><span class="code inline-code">${ws.workstream_code}</span></td><td><strong>${ws.workstream_name}</strong></td><td>${ws.description || '—'}</td><td>${ws.task_count}</td><td>${actions('workstream', ws.workstream_id)}</td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No master workstreams defined yet. Add custom streams or use standard templates.</p>'}</section>`;
  const rolesPanel = `<section class="panel"><div class="panel-head"><div><h2>Team roles (Master data)</h2><span class="subtle">Define project roles, responsibilities, and functional titles.</span></div><div class="row-actions"><button class="secondary" data-seed-roles>Use standard roles</button><button class="primary" data-open-role-master>+ Add team role</button></div></div>${roles && roles.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ORDER</th><th>CODE</th><th>ROLE NAME</th><th>DESCRIPTION</th><th>MEMBERS</th><th>ACTIONS</th></tr></thead><tbody>${roles.map((role) => `<tr><td>${role.sort_order}</td><td><span class="code inline-code">${role.role_code}</span></td><td><strong>${role.role_name}</strong></td><td>${role.description || '—'}</td><td>${role.member_count}</td><td><div class="row-actions"><button class="secondary" data-edit-role-master="${role.role_id}">Edit</button><button class="secondary" data-delete-role-master="${role.role_id}">Delete</button></div></td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No team roles defined yet. Add custom roles or use standard templates.</p>'}</section>`;
  const projectTypesPanel = `<section class="panel"><div class="panel-head"><div><h2>Project types (Global)</h2><span class="subtle">Define the project types available when creating or editing any project.</span></div><button class="primary" data-open-project-type>+ Add project type</button></div>${projectTypeList.length ? `<div class="table-wrap"><table class="table"><thead><tr><th>ORDER</th><th>TYPE NAME</th><th>DEFAULT</th><th>ACTIONS</th></tr></thead><tbody>${projectTypeList.map((pt) => `<tr><td>${pt.sort_order}</td><td><strong>${pt.type_name}</strong></td><td>${pt.is_default ? '<span class="badge green">Default</span>' : '—'}</td><td><div class="row-actions">${pt.is_default ? '<span class="subtle">Built-in</span>' : `<button class="secondary" data-edit-project-type="${pt.type_id}">Edit</button><button class="danger" data-delete-project-type="${pt.type_id}">Delete</button>`}</div></td></tr>`).join('')}</tbody></table></div>` : '<p class="empty">No project types defined yet.</p>'}</section>`;
  content.innerHTML = `<section class="panel"><div class="panel-head"><div><h2>Project setup</h2><span class="subtle">Create, edit, cancel, or reactivate your projects. Cancelled projects are hidden from Master Control.</span></div><button class="primary" data-open-project>+ Add project</button></div><div class="table-wrap"><table class="table"><thead><tr><th>PROJECT</th><th>TYPE</th><th>SIZE</th><th>PORTFOLIO</th><th>MAIN PM</th><th>STATUS</th><th>ACTIONS</th></tr></thead><tbody>${allProjects.map((project) => `<tr><td><strong>${project.project_name}</strong><span class="code inline-code">${project.project_code}</span></td><td>${typeBadge(project.project_type)}</td><td>${sizeBadge(project.project_size)}</td><td>${project.portfolio_name || '—'}</td><td>${project.main_pm_name}</td><td>${badge(project.project_status)}</td><td><div class="row-actions">${project.project_id === current.project_id ? '<span class="badge green">Active</span>' : (['cancel', 'cancelled'].includes(String(project.project_status).toLowerCase()) ? '<span class="subtle">Hidden from control</span>' : `<button data-select-project="${project.project_id}" data-go="projects">Select</button>`)}<button class="secondary" data-edit-project="${project.project_id}">Edit</button></div></td></tr>`).join('')}</tbody></table></div></section><section class="panel"><div class="panel-head"><div><h2>Active project info</h2><span class="subtle">${current.project_code} &middot; ${current.project_name}</span></div><div class="row-actions"><button class="secondary" data-edit-project="${current.project_id}">Edit project info</button><button class="secondary" data-go="structure">Set up structure</button></div></div><div class="project-grid"><div><span>Type &amp; Size</span><strong>${current.project_type || 'New'} &middot; ${current.project_size || 'Medium'}</strong></div><div><span>Portfolio</span><strong>${current.portfolio_name || '—'}</strong></div><div><span>Main PM</span><strong>${current.main_pm_name}</strong></div><div><span>Start</span><strong>${current.start_date || '—'}</strong></div><div><span>Target end</span><strong>${current.target_end_date || '—'}</strong></div></div></section>${projectTypesPanel}`;
  content.insertAdjacentHTML('afterbegin', contextBar(current, activeProjects));
  const importButton = document.createElement('button');
  importButton.className = 'secondary';
  importButton.dataset.openTemplateImport = '';
  importButton.textContent = 'Import template';
  content.querySelector('.project-grid')?.closest('.panel')?.querySelector('.row-actions')?.prepend(importButton);
}

async function projectModal(project) {
  const isEdit = Boolean(project);
  const [people, projectTypeList] = await Promise.all([api('/people'), api('/project-types')]);
  const selectedPmId = project?.main_pm_person_id || people.find((p) => p.display_name === project?.main_pm_name)?.person_id || people[0]?.person_id;
  const defaultType = projectTypeList.find((t) => t.is_default)?.type_name || projectTypeList[0]?.type_name || 'New';
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit project setup' : 'Add new project'}</h2>
    <div class="form-grid">
      <label>Project code<input name="projectCode" required value="${project?.project_code || ''}" placeholder="e.g. RRMS-02"></label>
      <label>Project name<input name="projectName" required value="${project?.project_name || ''}" placeholder="e.g. Core System Upgrade"></label>
      <label>Project type<select name="projectType">
        ${projectTypeList.map((pt) => `<option value="${pt.type_name}" ${selected(project?.project_type || defaultType, pt.type_name)}>${pt.type_name}</option>`).join('')}
      </select></label>
      <label>Project size<select name="projectSize">
        ${['Small', 'Medium', 'Large'].map((ps) => `<option value="${ps}" ${selected(project?.project_size || 'Medium', ps)}>${ps}</option>`).join('')}
      </select></label>
      <label>Portfolio<input name="portfolioName" value="${project?.portfolio_name || ''}" placeholder="e.g. Digital Transformation"></label>
      <label>Status<select name="projectStatus">
        ${['Active', 'Draft', 'OnHold', 'Completed', 'Cancelled'].map((st) => `<option value="${st}" ${selected(project?.project_status || 'Active', st)}>${st}</option>`).join('')}
      </select></label>
      <label>Start date<input name="startDate" type="date" value="${project?.start_date || ''}"></label>
      <label>Target end date<input name="targetEndDate" type="date" value="${project?.target_end_date || ''}"></label>
      <label class="full">Main PM<select name="mainPmPersonId">
        ${people.map((p) => `<option value="${p.person_id}" ${selected(selectedPmId, p.person_id)}>${p.display_name} (${p.employee_code})</option>`).join('')}
      </select></label>${isEdit ? '' : `
      <label class="full">Project team members <small>Optional — hold Ctrl/Cmd to select more than one person. They will be available as Owner and Assignee in this project.</small><select name="teamMemberIds" multiple size="${Math.min(Math.max(people.length, 3), 7)}">
        ${people.map((p) => `<option value="${p.person_id}">${p.display_name} (${p.employee_code})</option>`).join('')}
      </select></label>`}
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">${isEdit ? 'Save changes' : 'Create project'}</button>
    </div>`;

  form.onsubmit = async (event) => {
    event.preventDefault();
    const formData = new FormData(form);
    const values = Object.fromEntries(formData);
    if (!isEdit) values.teamMemberIds = formData.getAll('teamMemberIds');
    try {
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
      if (isEdit) {
        await api(`/projects/${project.project_id}`, { method: 'PATCH', body: JSON.stringify(values) });
        modal.close();
        showToast('Project setup updated.');
        navigate(activePage);
      } else {
        const { projectId } = await api('/projects', { method: 'POST', body: JSON.stringify(values) });
        modal.close();
        activeProjectId = projectId;
        localStorage.setItem('lean_active_project_id', projectId);
        tasks = [];
        showToast('Project created.');
        navigate(activePage);
      }
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

async function templateImportModal() {
  modalContent.innerHTML = `<h2 class="form-title">Import project template</h2>
    <p class="subtle">Upload the approved Excel or CSV template (maximum 5 MB). The system checks the file and duplicate work-item codes before anything is changed.</p>
    <label>Template file<input name="templateFile" type="file" accept=".xlsx,.xls,.csv" required></label>
    <div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary" type="submit">Check template</button></div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    const file = form.elements.templateFile.files[0];
    if (!file) return;
    try {
      const response = await fetch('/api/imports/preview', { method: 'POST', body: file, headers: { 'x-import-filename': encodeURIComponent(file.name), ...(activeProjectId ? { 'x-project-id': activeProjectId } : {}) } });
      const preview = await response.json();
      if (!response.ok) throw new Error(preview.message || 'Unable to check template.');
      const errors = preview.errors.length ? `<div class="import-errors"><strong>Fix these items before import</strong><ul>${preview.errors.map((item) => `<li>${item}</li>`).join('')}</ul></div>` : '<p class="import-ok">Template structure is valid.</p>';
      const duplicates = preview.conflicts.length ? `<div class="import-conflicts"><strong>${preview.summary.matchingItems} matching work item(s) found</strong><ul>${preview.conflicts.map((item) => `<li>Row ${item.row}: ${item.taskCode} — ${item.title}</li>`).join('')}</ul></div>` : '<p class="subtle">No matching work-item codes found in the current project.</p>';
      modalContent.innerHTML = `<h2 class="form-title">Review import</h2><p class="subtle"><strong>${preview.fileName}</strong> &middot; ${preview.summary.phases} phases &middot; ${preview.summary.workItems} work items</p>${errors}${duplicates}${preview.canImport ? `<fieldset class="import-mode"><legend>When the template is confirmed</legend><label><input type="radio" name="importMode" value="update" checked> Update matching fields only — retain existing work items not in the file.</label><label><input type="radio" name="importMode" value="replace"> Replace all project structure — archive the current phases, activities, and work items before applying this template.</label></fieldset><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary" type="submit">Confirm import</button></div>` : '<div class="actions"><button class="secondary" value="cancel">Close</button></div>'}`;
      form.onsubmit = async (confirmEvent) => {
        confirmEvent.preventDefault();
        const mode = new FormData(form).get('importMode');
        if (mode === 'replace' && !window.confirm('Replace the active project structure? Existing items will be archived and can be recovered from the database backup.')) return;
        try { const result = await api('/imports/commit', { method: 'POST', body: JSON.stringify({ token: preview.token, mode }) }); modal.close(); tasks = []; showToast(result.message); navigate('projects'); } catch (error) { showToast(error.message); }
      };
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

function suggestTaskCode(allTasks, type, projectCode = 'TASK') {
  const prefix = type === 'MainTask' ? `${projectCode}-MT-` : type === 'Task' ? `${projectCode}-T-` : `${projectCode}-ST-`;
  let maxNum = 0;
  for (const t of allTasks) {
    if (t.task_code && t.task_code.startsWith(prefix)) {
      const num = parseInt(t.task_code.slice(prefix.length), 10);
      if (!isNaN(num) && num > maxNum) maxNum = num;
    }
  }
  return `${prefix}${String(maxNum + 1).padStart(3, '0')}`;
}

function renderOwnerOptions(members, directory = [], selectedId) {
  const memberList = Array.isArray(members) ? members : [];
  const dirList = Array.isArray(directory) ? directory : [];
  const memberIds = new Set(memberList.map((m) => m.person_id));
  let html = memberList.map((p) => `<option value="${p.person_id}" ${selected(selectedId, p.person_id)}>${p.display_name}${p.employee_code ? ` (${p.employee_code})` : ''}</option>`).join('');
  const otherPeople = dirList.filter((p) => p.person_status === 'Active' && !memberIds.has(p.person_id));
  if (otherPeople.length) {
    html += `<optgroup label="Other team members (Auto-add to project)">` +
      otherPeople.map((p) => `<option value="${p.person_id}" ${selected(selectedId, p.person_id)}>${p.display_name}${p.employee_code ? ` (${p.employee_code})` : ''}</option>`).join('') +
      `</optgroup>`;
  }
  return html;
}

async function openTaskModal(context = {}) {
  const [{ current }, wbs, people, allPeople, currentTasks, workstreams] = await Promise.all([
    projectContext(),
    api('/wbs'),
    api('/project-members'),
    api('/people').catch(() => []),
    api('/tasks'),
    api('/workstreams')
  ]);
  const members = people.length ? people : (allPeople || []).filter((p) => p.person_status === 'Active');

  let initialParentId = context.parentTaskId || '';
  let initialParent = initialParentId ? currentTasks.find((t) => t.task_id === initialParentId) : null;
  let initialType = context.taskType || (initialParent ? (initialParent.task_type === 'MainTask' ? 'Task' : 'Subtask') : 'MainTask');
  let initialWbsId = context.wbsItemId || initialParent?.wbs_item_id || wbs[0]?.wbs_item_id || '';
  let initialWorkstream = context.workstream || initialParent?.workstream || '';
  let initialOwnerId = context.ownerPersonId || initialParent?.owner_person_id || members[0]?.person_id || '';
  let initialCode = suggestTaskCode(currentTasks, initialType, current.project_code || 'TASK');
  const fixedType = context.taskType || '';
  const fixedActivityId = context.wbsItemId || '';
  const isMainTaskFlow = fixedType === 'MainTask' && Boolean(fixedActivityId);
  const ownerOptions = renderOwnerOptions(people, allPeople, initialOwnerId);

  const renderParentOptions = (level, selectedWbs) => {
    if (level === 'MainTask') {
      return '<option value="">No parent (Main Task only)</option>';
    }
    const targetParentType = level === 'Task' ? 'MainTask' : 'Task';
    const eligible = currentTasks.filter((t) => t.task_type === targetParentType && (!selectedWbs || t.wbs_item_id === selectedWbs));
    if (!eligible.length) {
      return `<option value="">-- No eligible ${targetParentType} in selected Activity --</option>`;
    }
    return eligible.map((item) => `<option value="${item.task_id}" ${selected(initialParentId, item.task_id)}>${item.task_type} · ${item.task_code} — ${item.task_name}</option>`).join('');
  };

  modalContent.innerHTML = `<h2 class="form-title">${isMainTaskFlow ? 'Add Main Task' : 'Add work item'}</h2>
    ${isMainTaskFlow ? '<p class="subtle">This Main Task will be created directly under the selected Activity.</p>' : ''}
    <div class="form-grid">
      <label>Level<select name="taskType" ${fixedType ? 'disabled' : ''}>
        <option value="MainTask" ${selected(initialType, 'MainTask')}>Main Task</option>
        <option value="Task" ${selected(initialType, 'Task')}>Task</option>
        <option value="Subtask" ${selected(initialType, 'Subtask')}>Subtask</option>
      </select></label>
      <label>Activity<select name="wbsItemId">${wbs.map((item) => `<option value="${item.wbs_item_id}" ${selected(initialWbsId, item.wbs_item_id)}>${item.wbs_code} — ${item.wbs_name}</option>`).join('')}</select></label>
      <label class="full" id="parent-task-field">Parent work item<select name="parentTaskId">${renderParentOptions(initialType, initialWbsId)}</select><small class="subtle">Task requires a Main Task parent; Subtask requires a Task parent in the same activity.</small></label>
      <label>Item code<input name="taskCode" required value="${initialCode}" placeholder="e.g. ${initialCode}"></label>
      <label>Owner<select name="ownerPersonId">${ownerOptions}</select></label>
      <label class="full">Work item name<input name="taskName" required placeholder="Describe the deliverable or task"></label>
      <label>Workstream (Master data)<select name="workstream">
        <option value="">None / General</option>
        ${workstreams.map((ws) => `<option value="${ws.workstream_name}" ${selected(initialWorkstream, ws.workstream_name)}>${ws.workstream_code} — ${ws.workstream_name}</option>`).join('')}
      </select></label>
      <label>RAG<select name="ragStatus"><option>Green</option><option>Amber</option><option>Red</option></select></label>
      <label>Plan start<input name="plannedStartDate" type="date"></label>
      <label>Plan end<input name="plannedDueDate" type="date"></label>
      <label>Weight<input name="weight" type="number" min="0" max="100" value="0"></label>
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">Create work item</button>
    </div>`;

  const typeSelect = form.elements.taskType;
  const wbsSelect = form.elements.wbsItemId;
  const parentSelect = form.elements.parentTaskId;
  const codeInput = form.elements.taskCode;
  const workstreamSelect = form.elements.workstream;

  const updateParentAndCode = () => {
    const curLevel = typeSelect.value;
    const curWbs = wbsSelect.value;
    parentSelect.innerHTML = renderParentOptions(curLevel, curWbs);
    if (curLevel === 'MainTask') {
      parentSelect.disabled = true;
      parentSelect.value = '';
    } else {
      parentSelect.disabled = false;
      const firstOpt = parentSelect.options[0];
      if (firstOpt && firstOpt.value) {
        parentSelect.value = firstOpt.value;
      }
    }
    codeInput.value = suggestTaskCode(currentTasks, curLevel, current.project_code || 'TASK');
  };

  typeSelect.addEventListener('change', updateParentAndCode);
  wbsSelect.addEventListener('change', () => {
    if (typeSelect.value !== 'MainTask') {
      parentSelect.innerHTML = renderParentOptions(typeSelect.value, wbsSelect.value);
    }
  });

  parentSelect.addEventListener('change', () => {
    const chosenParent = currentTasks.find((t) => t.task_id === parentSelect.value);
    if (chosenParent) {
      if (chosenParent.wbs_item_id && wbsSelect.value !== chosenParent.wbs_item_id) {
        wbsSelect.value = chosenParent.wbs_item_id;
      }
      if (chosenParent.workstream && !workstreamSelect.value) {
        workstreamSelect.value = chosenParent.workstream;
      }
    }
  });

  if (initialType === 'MainTask') {
    parentSelect.disabled = true;
  }

  form.onsubmit = async (event) => {
    event.preventDefault();
    const values = Object.fromEntries(new FormData(form));
    values.taskType = fixedType || values.taskType;
    values.wbsItemId = fixedActivityId || values.wbsItemId;
    values.weight = Number(values.weight);
    if (values.taskType === 'MainTask') {
      values.parentTaskId = null;
    }
    try {
      const result = await api('/tasks', { method: 'POST', body: JSON.stringify(values) });
      modal.close();
      tasks = [];
      showToast(result.codeAdjusted ? `Work item created with available code ${result.taskCode}.` : 'Work item created.');
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'tasks';
      navigate(activePage);
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

async function legacyEditTask(task) {
  const [people, allPeople, workstreams] = await Promise.all([
    api('/project-members'),
    api('/people').catch(() => []),
    api('/workstreams')
  ]);
  const hasChildren = tasks.some((t) => t.parent_task_id === task.task_id);
  modalContent.innerHTML = `<h2 class="form-title">Edit work item</h2>
    <div class="form-grid">
      <label class="full">Work item name<input name="taskName" required value="${task.task_name}"></label>
      <label>Owner<select name="ownerPersonId">${renderOwnerOptions(people, allPeople, task.owner_person_id)}</select></label>
      <label>Workstream (Master data)<select name="workstream">
        <option value="">None / General</option>
        ${workstreams.map((ws) => `<option value="${ws.workstream_name}" ${selected(task.workstream, ws.workstream_name)}>${ws.workstream_code} — ${ws.workstream_name}</option>`).join('')}
      </select></label>
      <label>Status<select name="status">${statusOptions(task.status)}</select></label>
      <label>RAG<select name="ragStatus">${ragOptions(task.rag_status)}</select></label>
      <label>Progress (%)<input name="progress" type="number" min="0" max="100" value="${task.progress}">
        ${hasChildren ? '<small class="subtle" style="display:block;margin-top:4px;color:#0369a1">💡 Work item นี้มีรายการย่อย — Progress จะคำนวณ Rollup สรุปจากงานย่อยให้อัตโนมัติ</small>' : ''}
      </label>
      <label>Due date<input name="dueDate" type="date" value="${task.planned_due_date || ''}"></label>
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">Save changes</button>
    </div>`;

  const statusSelect = form.elements.status;
  const progressInput = form.elements.progress;

  statusSelect.addEventListener('change', () => {
    if (statusSelect.value === 'Done') {
      progressInput.value = '100';
    } else if (statusSelect.value === 'NotStarted') {
      progressInput.value = '0';
    } else if (statusSelect.value === 'InProgress' && (progressInput.value === '0' || progressInput.value === '100')) {
      progressInput.value = '50';
    }
  });

  progressInput.addEventListener('input', () => {
    const val = Number(progressInput.value);
    if (val >= 100) {
      statusSelect.value = 'Done';
      progressInput.value = '100';
    } else if (val <= 0) {
      if (statusSelect.value === 'Done') statusSelect.value = 'NotStarted';
    } else if (statusSelect.value === 'Done' || statusSelect.value === 'NotStarted') {
      statusSelect.value = 'InProgress';
    }
  });

  form.onsubmit = async (event) => {
    event.preventDefault();
    const values = new FormData(form);
    try {
      await api(`/tasks/${task.task_id}`, {
        method: 'PATCH',
        body: JSON.stringify({
          task_name: values.get('taskName'),
          owner_person_id: values.get('ownerPersonId'),
          workstream: values.get('workstream')?.trim() || null,
          status: values.get('status'),
          rag_status: values.get('ragStatus'),
          progress: Number(values.get('progress')),
          planned_due_date: values.get('dueDate') || null
        })
      });
      modal.close();
      tasks = [];
      showToast('Work item updated.');
      navigate('tasks');
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

async function editTask(task) {
  if (!task) return;
  const [people, allPeople, workstreams] = await Promise.all([
    api('/project-members'),
    api('/people').catch(() => []),
    api('/workstreams')
  ]);
  const members = people.length ? people : (allPeople || []).filter((p) => p.person_status === 'Active');
  if (!members.length) {
    showToast('Add an active project member before assigning an owner.');
    return;
  }
  modalContent.innerHTML = `<h2 class="form-title">Edit work item structure</h2><p class="subtle">Change the work item definition, ownership, and planned due date here. Record status and progress in Work items.</p><div class="form-grid"><label class="full">Work item name<input name="taskName" required value="${task.task_name}"></label><label>Owner<select name="ownerPersonId">${renderOwnerOptions(people, allPeople, task.owner_person_id)}</select></label><label>Workstream<select name="workstream"><option value="">None / General</option>${workstreams.map((ws) => `<option value="${ws.workstream_name}" ${selected(task.workstream, ws.workstream_name)}>${ws.workstream_code} — ${ws.workstream_name}</option>`).join('')}</select></label><label>Due date<input name="dueDate" type="date" value="${task.planned_due_date || ''}"></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Save structure</button></div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    const values = new FormData(form);
    try {
      const saved = await api(`/tasks/${task.task_id}`, {
        method: 'PATCH',
        body: JSON.stringify({
          task_name: values.get('taskName'),
          owner_person_id: values.get('ownerPersonId'),
          workstream: values.get('workstream')?.trim() || null,
          planned_due_date: values.get('dueDate') || null
        })
      });
      if (saved.owner_person_id !== values.get('ownerPersonId')) {
        throw new Error('Owner was not saved. Please try again.');
      }
      modal.close();
      tasks = [];
      showToast(`Work item structure saved. Owner: ${saved.owner_name}.`);
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'structure';
      navigate(activePage);
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

function workstreamModal(workstream) {
  const isEdit = Boolean(workstream);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit workstream' : 'Add master workstream'}</h2>
    <div class="form-grid">
      <label>Workstream code<input name="workstreamCode" required value="${workstream?.workstream_code || ''}" placeholder="e.g. BE"></label>
      <label>Workstream name<input name="workstreamName" required value="${workstream?.workstream_name || ''}" placeholder="e.g. Backend & API"></label>
      <label>Sort order<input name="sortOrder" type="number" min="0" value="${workstream?.sort_order || ''}"></label>
      <label class="full">Description<textarea name="description" placeholder="Scope and functional boundaries">${workstream?.description || ''}</textarea></label>
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">${isEdit ? 'Save changes' : 'Create workstream'}</button>
    </div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    try {
      await api(isEdit ? `/workstreams/${workstream.workstream_id}` : '/workstreams', {
        method: isEdit ? 'PATCH' : 'POST',
        body: JSON.stringify(Object.fromEntries(new FormData(form)))
      });
      modal.close();
      showToast(isEdit ? 'Workstream updated.' : 'Workstream created.');
      navigate('projects');
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

async function taskNotesModal(task, editingNoteId = null) {
  activeTaskForNotes = task;
  const notes = await api(`/task-notes?taskId=${encodeURIComponent(task.task_id)}`);
  const editingNote = notes.find((note) => note.task_note_id === editingNoteId);
  const formatSize = (bytes) => bytes >= 1024 * 1024 ? `${(bytes / (1024 * 1024)).toFixed(1)} MB` : `${Math.ceil(bytes / 1024)} KB`;
  const history = notes.length ? notes.map((note) => `<article class="task-note-entry"><div class="task-note-meta">${badge(note.note_type)} <strong>${escapeHtml(note.created_by_name)}</strong><span>${new Date(note.updated_at.replace(' ', 'T') + 'Z').toLocaleString()}${note.updated_at !== note.created_at ? ' (edited)' : ''}</span><button class="secondary compact-btn" data-edit-task-note="${note.task_note_id}">Edit</button></div><p>${escapeHtml(note.note_text)}</p>${note.files.length ? `<div class="task-note-files">${note.files.map((file) => `<button class="attachment-link" data-download-task-note-file="${file.task_note_file_id}">📎 ${escapeHtml(file.original_file_name)} <small>${formatSize(file.file_size_bytes)}</small></button>`).join('')}</div>` : ''}</article>`).join('') : '<p class="empty">No notes or updates for this work item yet.</p>';
  modalContent.innerHTML = `<h2 class="form-title">Notes & updates</h2><p class="subtle"><strong>${escapeHtml(task.task_code)}</strong> — ${escapeHtml(task.task_name)}</p><div class="form-grid"><label>Entry type<select name="noteType"><option value="Note" ${selected(editingNote?.note_type || 'Note', 'Note')}>Note</option><option value="Update" ${selected(editingNote?.note_type || 'Note', 'Update')}>Update</option></select></label><label class="full">Note / update<textarea name="noteText" required placeholder="Record the decision, progress, blocker, or next action.">${editingNote ? escapeHtml(editingNote.note_text) : ''}</textarea></label>${editingNote ? '<p class="subtle full">Attachments remain unchanged when editing a note.</p>' : '<label class="full">Attachments <small>Up to 5 MB per file</small><input name="attachments" type="file" multiple></label>'}</div><div class="actions"><button class="secondary" value="cancel">Close</button><button class="primary">${editingNote ? 'Save changes' : 'Save note'}</button></div><section class="task-note-history"><h3>History</h3>${history}</section>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    const data = new FormData(form);
    const files = editingNote ? [] : [...form.elements.attachments.files];
    if (files.some((file) => file.size > 5 * 1024 * 1024)) return showToast('Each attachment must be 5 MB or smaller.');
    try {
      const result = editingNote
        ? await api(`/task-notes/${editingNote.task_note_id}`, { method: 'PATCH', body: JSON.stringify({ noteType: data.get('noteType'), noteText: data.get('noteText') }) })
        : await api('/task-notes', { method: 'POST', body: JSON.stringify({ taskId: task.task_id, noteType: data.get('noteType'), noteText: data.get('noteText') }) });
      for (const file of files) {
        const response = await fetch(`/api/task-notes/${result.taskNoteId}/files`, { method: 'PUT', headers: { ...(activeProjectId ? { 'x-project-id': activeProjectId } : {}), 'x-file-name': encodeURIComponent(file.name), 'x-file-type': file.type || 'application/octet-stream' }, body: file });
        if (!response.ok) { const error = await response.json(); throw new Error(error.message || 'Unable to upload attachment.'); }
      }
      tasks = [];
      showToast(editingNote ? 'Task note updated.' : 'Task note saved.');
      taskNotesModal(task);
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

async function taskHistoryModal(task) {
  if (!task) return;
  const [notes, updates] = await Promise.all([
    api(`/task-notes?taskId=${encodeURIComponent(task.task_id)}`),
    api(`/weekly-updates?taskId=${encodeURIComponent(task.task_id)}`)
  ]);
  const entries = updates.map((item) => ({ ...item, historyType: 'Weekly update', date: item.updated_at || item.created_at,
    attachments: notes.find((note) => note.note_type === 'Update' && note.note_text === item.summary)?.files || []
  })).sort((a, b) => String(b.date).localeCompare(String(a.date)));
  const history = entries.length ? entries.map((item) => {
    return `<article class="task-note-entry"><div class="task-note-meta">${badge('Update')} <strong>${escapeHtml(item.submitted_by_name)}</strong><span>${new Date(String(item.date).replace(' ', 'T') + 'Z').toLocaleString()}${item.updated_at !== item.created_at ? ' (edited)' : ''}</span><button class="secondary compact-btn" data-edit-weekly-update="${item.weekly_update_id}">Edit</button></div><p>${escapeHtml(item.summary || '')}</p>${item.blocker ? `<small class="cell-note">Blocker: ${escapeHtml(item.blocker)}</small>` : ''}${item.next_step ? `<small class="cell-note">Next: ${escapeHtml(item.next_step)}</small>` : ''}${item.attachments.length ? `<div class="task-note-files">${item.attachments.flatMap((file) => `<button class="attachment-link" data-download-task-note-file="${file.task_note_file_id}">📎 ${escapeHtml(file.original_file_name)}</button>`).join('')}</div>` : ''}</article>`;
  }).join('') : '<p class="empty">No updates or notes for this work item yet.</p>';
  modalContent.innerHTML = `<h2 class="form-title">Update &amp; history</h2><p class="subtle"><strong>${escapeHtml(task.task_code)}</strong> — ${escapeHtml(task.task_name)}</p><div class="history-actions"><button class="secondary" data-open-task-update="${task.task_id}">+ Add update</button><button class="secondary" data-open-task-note-create="${task.task_id}">+ Add note</button></div><section class="task-note-history"><h3>History</h3>${history}</section><div class="actions"><button class="secondary" value="cancel">Close</button></div>`;
  modal.showModal();
}

async function downloadTaskNoteFile(fileId) {
  try {
    const response = await fetch(`/api/task-note-files/${fileId}/download`, { headers: activeProjectId ? { 'x-project-id': activeProjectId } : {} });
    if (!response.ok) { const error = await response.json(); throw new Error(error.message || 'Unable to download attachment.'); }
    const blob = await response.blob();
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = '';
    link.click();
    URL.revokeObjectURL(link.href);
  } catch (error) { showToast(error.message); }
}

function unassignedPhaseModal() {
  const activities = [...new Map(tasks.filter((task) => !task.phase_id).map((task) => [task.wbs_item_id, task])).values()];
  if (!activities.length) return showToast('Every activity already belongs to a Phase.');
  modalContent.innerHTML = `<h2 class="form-title">Create Phase from unassigned work</h2><p class="subtle">This will create one Phase and place ${activities.length} unassigned ${activities.length === 1 ? 'Activity' : 'Activities'} under it.</p><div class="form-grid"><label>Phase code<input name="phaseCode" required placeholder="e.g. REQ"></label><label>Phase name<input name="phaseName" required placeholder="e.g. Requirement"></label><label>Order<input name="sortOrder" type="number" min="0"></label><label>Plan start<input name="plannedStartDate" type="date"></label><label>Plan end<input name="plannedDueDate" type="date"></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Create and assign</button></div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    try {
      const phase = await api('/phases', { method: 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) });
      await Promise.all(activities.map((activity) => api(`/wbs/${activity.wbs_item_id}`, { method: 'PATCH', body: JSON.stringify({ phaseId: phase.phaseId }) })));
      modal.close();
      showToast(`Phase created and ${activities.length} Activities assigned.`);
      workBreakdown();
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

function phaseModal(phase) {
  const isEdit = Boolean(phase);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit implementation phase' : 'Add implementation phase'}</h2><div class="form-grid"><label>Phase code<input name="phaseCode" required value="${phase?.phase_code || ''}" placeholder="e.g. DEV"></label><label>Phase name<input name="phaseName" required value="${phase?.phase_name || ''}" placeholder="e.g. Development"></label><label>Order<input name="sortOrder" type="number" min="0" value="${phase?.sort_order || ''}"></label><label>Plan start<input name="plannedStartDate" type="date" value="${phase?.planned_start_date || ''}"></label><label>Plan end<input name="plannedDueDate" type="date" value="${phase?.planned_due_date || ''}"></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Create phase'}</button></div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    try {
      await api(isEdit ? `/phases/${phase.phase_id}` : '/phases', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) });
      modal.close();
      showToast(isEdit ? 'Phase updated.' : 'Phase created.');
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
      navigate(activePage);
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

async function activityModal(activity, defaultPhaseId = null) {
  const [phases] = await Promise.all([api('/phases')]);
  const isEdit = Boolean(activity);
  const selectedPhaseId = activity?.phase_id || defaultPhaseId || '';
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit project activity' : 'Add project activity'}</h2><p class="subtle">Every Activity belongs to an Implementation Phase so the project tree stays connected.</p><div class="form-grid"><label>Phase<select name="phaseId" required>${phases.map((phase) => `<option value="${phase.phase_id}" ${selected(selectedPhaseId, phase.phase_id)}>${phase.phase_code} — ${phase.phase_name}</option>`).join('')}</select></label><label>Activity code<input name="wbsCode" required value="${activity?.wbs_code || ''}" placeholder="e.g. ACT-01"></label><label>Activity name<input name="wbsName" required value="${activity?.wbs_name || ''}" placeholder="e.g. Requirements gathering"></label><label>Order<input name="sortOrder" type="number" min="0" value="${activity?.sort_order || ''}"></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Create activity'}</button></div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    try {
      await api(isEdit ? `/wbs/${activity.wbs_item_id}` : '/wbs', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) });
      modal.close();
      showToast(isEdit ? 'Activity updated.' : 'Activity created.');
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'structure';
      navigate(activePage);
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

async function weeklyModal(item) {
  const isEdit = Boolean(item);
  const workItems = await api('/tasks');
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit weekly update' : 'Add weekly update'}</h2><div class="form-grid"><label class="full">Work item<select name="taskId" ${isEdit ? 'disabled' : ''}>${workItems.map((task) => `<option value="${task.task_id}" ${selected(item?.task_id, task.task_id)}>${task.task_code} — ${task.task_name}</option>`).join('')}</select></label><label>Week start<input name="weekStartDate" type="date" required value="${item?.week_start_date || controlWeek}"></label><label>Status<select name="status">${statusOptions(item?.status || 'InProgress')}</select></label><label>RAG<select name="ragStatus">${ragOptions(item?.rag_status || 'Green')}</select></label><label>Progress (%)<input name="progress" type="number" min="0" max="100" required value="${item?.progress ?? 0}"></label><label class="full">Summary<textarea name="summary" required maxlength="2000">${item?.summary || ''}</textarea></label><label class="full">Blocker<textarea name="blocker" placeholder="Optional">${item?.blocker || ''}</textarea></label><label class="full">Next step<textarea name="nextStep" placeholder="Optional">${item?.next_step || ''}</textarea></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Submit update'}</button></div>`;
  const statusSelect = form.elements.status;
  const progressInput = form.elements.progress;
  if (statusSelect && progressInput) {
    statusSelect.addEventListener('change', () => {
      if (statusSelect.value === 'Done') progressInput.value = '100';
      else if (statusSelect.value === 'NotStarted') progressInput.value = '0';
      else if (statusSelect.value === 'InProgress' && (progressInput.value === '0' || progressInput.value === '100')) progressInput.value = '50';
    });
    progressInput.addEventListener('input', () => {
      const val = Number(progressInput.value);
      if (val >= 100) { statusSelect.value = 'Done'; progressInput.value = '100'; }
      else if (val <= 0 && statusSelect.value === 'Done') statusSelect.value = 'NotStarted';
      else if (val > 0 && val < 100 && (statusSelect.value === 'Done' || statusSelect.value === 'NotStarted')) statusSelect.value = 'InProgress';
    });
  }
  form.onsubmit = async (event) => { event.preventDefault(); const values = Object.fromEntries(new FormData(form)); values.progress = Number(values.progress); values.summary = values.summary.trim(); if (isEdit) delete values.taskId; try { await api(isEdit ? `/weekly-updates/${item.weekly_update_id}` : '/weekly-updates', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(values) }); modal.close(); showToast(isEdit ? 'Weekly update changed.' : 'Weekly update submitted.'); navigate('updates'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

function taskProgressModal(task) {
  if (!task) return;
  modalContent.innerHTML = `<h2 class="form-title">Update work item</h2><p class="subtle"><strong>${task.task_code}</strong> — ${task.task_name}</p><div class="form-grid"><label>Week start<input name="weekStartDate" type="date" required value="${controlWeek}"></label><label>Status<select name="status">${statusOptions(task.status)}</select></label><label>RAG<select name="ragStatus">${ragOptions(task.rag_status || 'Green')}</select></label><label>Progress (%)<input name="progress" type="number" min="0" max="100" required value="${task.progress || 0}"></label><label class="full">What was completed / changed?<textarea name="summary" required maxlength="2000" placeholder="Progress, decision, or deliverable completed"></textarea></label><label class="full">Blocker<textarea name="blocker" placeholder="Optional"></textarea></label><label class="full">Next step<textarea name="nextStep" placeholder="Optional"></textarea></label><label class="full">Attachments <small>Up to 5 MB per file</small><input name="attachments" type="file" multiple></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Save update</button></div>`;
  const statusSelect = form.elements.status; const progressInput = form.elements.progress;
  statusSelect.addEventListener('change', () => { if (statusSelect.value === 'Done') progressInput.value = '100'; else if (statusSelect.value === 'NotStarted') progressInput.value = '0'; });
  form.onsubmit = async (event) => { event.preventDefault(); const data = new FormData(form); const values = Object.fromEntries(data); const files = [...form.elements.attachments.files]; if (files.some((file) => file.size > 5 * 1024 * 1024)) return showToast('Each attachment must be 5 MB or smaller.'); values.taskId = task.task_id; values.progress = Number(values.progress); values.summary = values.summary.trim(); try { const result = await api('/weekly-updates', { method: 'POST', body: JSON.stringify(values) }); if (files.length) { const note = await api('/task-notes', { method: 'POST', body: JSON.stringify({ taskId: task.task_id, noteType: 'Update', noteText: values.summary }) }); for (const file of files) { const response = await fetch(`/api/task-notes/${note.taskNoteId}/files`, { method: 'PUT', headers: { ...(activeProjectId ? { 'x-project-id': activeProjectId } : {}), 'x-file-name': encodeURIComponent(file.name), 'x-file-type': file.type || 'application/octet-stream' }, body: file }); if (!response.ok) throw new Error('Unable to upload attachment.'); } } modal.close(); tasks = []; showToast('Work item update saved.'); navigate('tasks'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

async function weeklyPlanModal(item) {
  const [workItems, people, allPeople] = await Promise.all([
    api('/tasks'),
    api('/project-members'),
    api('/people').catch(() => [])
  ]);
  const isEdit = Boolean(item);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit weekly plan' : 'Add weekly plan'}</h2><p class="subtle">Define a commitment and its expected outcome. Linking a work item is optional.</p><div class="form-grid"><label>Week start<input name="weekStartDate" type="date" required value="${item?.week_start_date || controlWeek}"></label><label>Priority<select name="priority">${['Low', 'Medium', 'High', 'Critical'].map((value) => `<option ${selected(item?.priority || 'Medium', value)}>${value}</option>`).join('')}</select></label><label class="full">Commitment<input name="planTitle" required value="${item?.plan_title || ''}" placeholder="What must be achieved this week?"></label><label class="full">Linked work item (optional)<select name="taskId"><option value="">Project-level commitment</option>${workItems.map((task) => `<option value="${task.task_id}" ${selected(item?.task_id, task.task_id)}>${task.task_code} — ${task.task_name}</option>`).join('')}</select></label><label>Owner<select name="ownerPersonId">${renderOwnerOptions(people, allPeople, item?.owner_person_id)}</select></label><label>Owner role<input name="ownerRole" value="${item?.owner_role || ''}" placeholder="e.g. PM, BA, QA"></label><label>Due date<input name="plannedDueDate" type="date" value="${item?.planned_due_date || ''}"></label><label>Status<select name="status">${['Planned', 'InProgress', 'Done', 'Deferred'].map((value) => `<option value="${value}" ${selected(item?.status || 'Planned', value)}>${value === 'InProgress' ? 'In progress' : value}</option>`).join('')}</select></label><label class="full">Expected outcome<textarea name="targetOutcome" placeholder="What evidence or result will show this is complete?">${item?.target_outcome || ''}</textarea></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Add to weekly plan'}</button></div>`;
  form.onsubmit = async (event) => { event.preventDefault(); const values = Object.fromEntries(new FormData(form)); try { await api(isEdit ? `/weekly-plans/${item.weekly_plan_id}` : '/weekly-plans', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(values) }); modal.close(); showToast(isEdit ? 'Weekly plan updated.' : 'Weekly plan added.'); navigate('updates'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

async function roleUpdateModal(item) {
  const people = await api('/project-members');
  const members = people;
  const isEdit = Boolean(item);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit role update' : 'Add role update'}</h2><p class="subtle">Summarize the role's movement. Task-by-task details stay in Task progress updates.</p><div class="form-grid"><label>Week start<input name="weekStartDate" type="date" required value="${item?.week_start_date || controlWeek}"></label><label>Person<select name="personId">${members.map((person) => `<option value="${person.person_id}" ${selected(item?.person_id, person.person_id)}>${person.display_name}</option>`).join('')}</select></label><label class="full">Role<input name="roleName" required value="${item?.role_name || ''}" placeholder="e.g. Project Manager, Business Analyst"></label><label class="full">Accomplished<textarea name="accomplished" placeholder="What moved or was completed?">${item?.accomplished || ''}</textarea></label><label class="full">Next actions<textarea name="nextActions" placeholder="What will this role do next?">${item?.next_actions || ''}</textarea></label><label class="full">Blocker<textarea name="blocker" placeholder="What is preventing progress?">${item?.blocker || ''}</textarea></label><label class="full">Support needed<textarea name="supportNeeded" placeholder="What decision or help is required?">${item?.support_needed || ''}</textarea></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Submit role update'}</button></div>`;
  form.onsubmit = async (event) => { event.preventDefault(); try { await api(isEdit ? `/role-updates/${item.role_update_id}` : '/role-updates', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) }); modal.close(); showToast(isEdit ? 'Role update changed.' : 'Role update submitted.'); navigate('updates'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

async function raidModal(item) {
  const [people, allPeople, session] = await Promise.all([
    api('/project-members'),
    api('/people').catch(() => []),
    api('/session')
  ]);
  const members = people.length ? people : (allPeople || []).filter((p) => p.person_status === 'Active');
  const selectedOwnerId = item?.owner_person_id || session.personId || members[0]?.person_id;
  const isEdit = Boolean(item);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit RAID item' : 'Add RAID item'}</h2><div class="form-grid"><label>Type<select name="raidType">${['Risk', 'Assumption', 'Issue', 'Dependency'].map((value) => `<option ${selected(item?.raid_type || 'Risk', value)}>${value}</option>`).join('')}</select></label><label>Status<select name="status">${['Open', 'Monitoring', 'Mitigated', 'Closed'].map((value) => `<option ${selected(item?.status || 'Open', value)}>${value}</option>`).join('')}</select></label><label>Owner<select name="ownerPersonId">${renderOwnerOptions(people, allPeople, selectedOwnerId)}</select></label><label>Due date<input type="date" name="dueDate" value="${item?.due_date || ''}"></label><label class="full">Title<input name="title" required value="${item?.title || ''}"></label><label>Probability<input name="probability" type="number" min="1" max="5" value="${item?.probability || 3}"></label><label>Impact<input name="impact" type="number" min="1" max="5" value="${item?.impact || 3}"></label><label class="full">Mitigation plan<textarea name="mitigationPlan">${item?.mitigation_plan || ''}</textarea></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Create item'}</button></div>`;
  form.onsubmit = async (event) => { event.preventDefault(); const values = Object.fromEntries(new FormData(form)); values.probability = Number(values.probability); values.impact = Number(values.impact); try { await api(isEdit ? `/raid/${item.raid_item_id}` : '/raid', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(values) }); modal.close(); showToast(isEdit ? 'RAID item updated.' : 'RAID item created.'); navigate('raid'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

async function personModal(person) {
  const isEdit = Boolean(person);
  const roles = await api('/roles').catch(() => []);
  const defaultRoles = [
    { role_code: 'TeamMember', role_name: 'Team Member' },
    { role_code: 'Owner', role_name: 'Owner' },
    { role_code: 'PM', role_name: 'Project Manager' },
    { role_code: 'BA', role_name: 'Business Analyst' },
    { role_code: 'DEV', role_name: 'Developer' },
    { role_code: 'QA', role_name: 'Quality Assurance' },
    { role_code: 'ProjectAdmin', role_name: 'Project Admin' },
    { role_code: 'DEVLead', role_name: 'DEV Lead' },
    { role_code: 'Reviewer', role_name: 'Reviewer' }
  ];
  const availableRoles = [...(roles.length ? roles : defaultRoles)];
  for (const dr of defaultRoles) {
    if (!availableRoles.some((r) => r.role_code === dr.role_code)) {
      availableRoles.push(dr);
    }
  }
  if (person?.project_role && !availableRoles.some((r) => r.role_code === person.project_role || r.role_name === person.project_role)) {
    availableRoles.push({ role_code: person.project_role, role_name: person.project_role });
  }
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit team member' : 'Add team member'}</h2><div class="form-grid"><label>Employee code<input name="employeeCode" required value="${person?.employee_code || ''}"></label><label>Display name<input name="displayName" required value="${person?.display_name || ''}"></label><label>Email<input name="email" type="email" required value="${person?.email || ''}"></label><label>Department<input name="department" value="${person?.department || ''}"></label><label>Project role<select name="projectRole">${availableRoles.map((r) => `<option value="${r.role_code}" ${selected(person?.project_role || 'TeamMember', r.role_code)}>${r.role_name} (${r.role_code})</option>`).join('')}</select></label><label>Position or title<input name="positionTitle" value="${person?.position_title || ''}"></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">${isEdit ? 'Save changes' : 'Save person'}</button></div>`;
  form.onsubmit = async (event) => { event.preventDefault(); try { await api(isEdit ? `/people/${person.person_id}` : '/people', { method: isEdit ? 'PATCH' : 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) }); modal.close(); showToast(isEdit ? 'Person updated.' : 'Person added.'); navigate('admin'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

async function existingPeopleModal() {
  const [directory, members, roles] = await Promise.all([api('/people'), api('/project-members'), api('/roles').catch(() => [])]);
  const memberIds = new Set(members.map((person) => person.person_id));
  const availablePeople = directory.filter((person) => person.person_status === 'Active' && !memberIds.has(person.person_id));
  const defaultRoles = [
    { role_code: 'TeamMember', role_name: 'Team Member' },
    { role_code: 'Owner', role_name: 'Owner' },
    { role_code: 'PM', role_name: 'Project Manager' },
    { role_code: 'BA', role_name: 'Business Analyst' },
    { role_code: 'DEV', role_name: 'Developer' },
    { role_code: 'QA', role_name: 'Quality Assurance' },
    { role_code: 'ProjectAdmin', role_name: 'Project Admin' },
    { role_code: 'DEVLead', role_name: 'DEV Lead' },
    { role_code: 'Reviewer', role_name: 'Reviewer' }
  ];
  const availableRoles = [...(roles.length ? roles : defaultRoles)];
  for (const dr of defaultRoles) {
    if (!availableRoles.some((r) => r.role_code === dr.role_code)) {
      availableRoles.push(dr);
    }
  }
  modalContent.innerHTML = `<h2 class="form-title">Add existing people to this project</h2><p class="subtle">Select one or more people. They will be available for Owner and Assignee immediately.</p>${availablePeople.length ? `<div class="form-grid"><label class="full">People<select name="personIds" multiple size="${Math.min(10, availablePeople.length)}" required>${availablePeople.map((person) => `<option value="${person.person_id}">${person.display_name} (${person.employee_code})</option>`).join('')}</select></label><label>Project role<select name="projectRole">${availableRoles.map((role) => `<option value="${role.role_code}">${role.role_name} (${role.role_code})</option>`).join('')}</select></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Add selected people</button></div>` : '<p class="empty">All active people are already members of this project.</p>'}`;
  if (availablePeople.length) form.onsubmit = async (event) => { event.preventDefault(); const values = new FormData(form); const projectRole = values.get('projectRole'); try { await Promise.all(values.getAll('personIds').map((personId) => api(`/people/${personId}`, { method: 'PATCH', body: JSON.stringify({ projectRole }) }))); modal.close(); showToast('Selected people added to this project.'); navigate('admin'); } catch (error) { showToast(error.message); } };
  modal.showModal();
}

function roleMasterModal(role) {
  const isEdit = Boolean(role);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit team role' : 'Add team role (Master data)'}</h2>
    <div class="form-grid">
      <label>Role code<input name="roleCode" required value="${role?.role_code || ''}" placeholder="e.g. TECH_LEAD"></label>
      <label>Role name<input name="roleName" required value="${role?.role_name || ''}" placeholder="e.g. Tech Lead"></label>
      <label>Sort order<input name="sortOrder" type="number" min="0" value="${role?.sort_order ?? ''}"></label>
      <label class="full">Description<textarea name="description" placeholder="Role responsibilities and expectations">${role?.description || ''}</textarea></label>
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">${isEdit ? 'Save changes' : 'Create role'}</button>
    </div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    try {
      await api(isEdit ? `/roles/${role.role_id}` : '/roles', {
        method: isEdit ? 'PATCH' : 'POST',
        body: JSON.stringify(Object.fromEntries(new FormData(form)))
      });
      modal.close();
      showToast(isEdit ? 'Team role updated.' : 'Team role created.');
      const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
      navigate(activePage);
    } catch (error) {
      showToast(error.message);
    }
  };
  modal.showModal();
}

async function assignmentModal(assignment) {
  const [people, allPeople, workItems, roles] = await Promise.all([
    api('/project-members'),
    api('/people').catch(() => []),
    api('/tasks'),
    api('/roles').catch(() => [])
  ]);
  const standardAssignRoles = ['Owner', 'DEV', 'Reviewer', 'Contributor', 'Observer', 'PM', 'BA', 'QA'];
  const customRoleCodes = (roles || []).map((r) => r.role_code).filter((c) => !standardAssignRoles.includes(c));
  const allAssignmentRoles = [...standardAssignRoles, ...customRoleCodes];

  if (assignment) {
    modalContent.innerHTML = `<h2 class="form-title">Edit assignment</h2><p class="subtle">You can move this assignment to another work item or team member.</p><div class="form-grid"><label class="full">Work item<select name="taskId">${workItems.map((item) => `<option value="${item.task_id}" ${selected(assignment.task_id, item.task_id)}>${item.task_code} — ${item.task_name}</option>`).join('')}</select></label><label>Team member<select name="personId">${renderOwnerOptions(people, allPeople, assignment.person_id)}</select></label><label>Assignment role<select name="assignmentRole">${allAssignmentRoles.map((value) => `<option ${selected(assignment.assignment_role, value)}>${value}</option>`).join('')}</select></label><label>RACI role<select name="raciRole"><option value="">Not specified</option>${['Responsible', 'Accountable', 'Consulted', 'Informed'].map((value) => `<option value="${value}" ${selected(assignment.raci_role, value)}>${value}</option>`).join('')}</select></label><label>Allocation (%)<input name="allocationPercent" type="number" min="0" max="100" value="${assignment.allocation_percent ?? ''}" placeholder="Optional"></label><label class="checkbox-label"><input name="isPrimary" type="checkbox" ${assignment.is_primary ? 'checked' : ''}> Primary assignment</label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Save changes</button></div>`;
    form.onsubmit = async (event) => { event.preventDefault(); const values = Object.fromEntries(new FormData(form)); values.isPrimary = form.elements.isPrimary.checked; try { await api(`/assignments/${assignment.task_assignment_id}`, { method: 'PATCH', body: JSON.stringify(values) }); modal.close(); showToast('Assignment updated.'); navigate('admin'); } catch (error) { showToast(error.message); } };
  } else {
    modalContent.innerHTML = `<h2 class="form-title">Assign work</h2><div class="form-grid"><label class="full">Work item<select name="taskId">${workItems.map((item) => `<option value="${item.task_id}">${item.task_code} — ${item.task_name}</option>`).join('')}</select></label><label>Team member<select name="personId">${renderOwnerOptions(people, allPeople)}</select></label><label>Assignment role<select name="assignmentRole">${allAssignmentRoles.map((value) => `<option>${value}</option>`).join('')}</select></label></div><div class="actions"><button class="secondary" value="cancel">Cancel</button><button class="primary">Save assignment</button></div>`;
    form.onsubmit = async (event) => { event.preventDefault(); try { await api('/assignments', { method: 'POST', body: JSON.stringify(Object.fromEntries(new FormData(form))) }); modal.close(); showToast('Task assignment saved.'); navigate('admin'); } catch (error) { showToast(error.message); } };
  }
  modal.showModal();
}


async function deleteItem(type, id) {
  const label = type === 'activity' ? 'This will archive the Activity and all work items below it.' : 'This cannot be undone.';
  if (!window.confirm(`Delete this item? ${label}`)) return;
  const paths = { task: `/tasks/${id}`, update: `/weekly-updates/${id}`, plan: `/weekly-plans/${id}`, role: `/role-updates/${id}`, raid: `/raid/${id}`, person: `/people/${id}`, assignment: `/assignments/${id}`, activity: `/wbs/${id}` };
  const destinations = { task: 'tasks', update: 'updates', plan: 'updates', role: 'updates', raid: 'raid', person: 'admin', assignment: 'admin', activity: 'structure' };
  try {
    const result = await api(paths[type], { method: 'DELETE' });
    tasks = [];
    showToast(result?.message || 'Item deleted.');
    const activePage = document.querySelector('.nav.active')?.dataset.page || destinations[type];
    navigate(activePage);
  } catch (error) { showToast(error.message); }
}

async function projectPortal() {
  const sessions = {
    setup: projectSetup,
    builder: structureEditable,
    team: adminEditable
  };
  if (!sessions[portalSession]) portalSession = 'setup';
  await sessions[portalSession]();
  const labels = {
    setup: 'Project setup',
    builder: 'Project Builder',
    team: 'Team & assignments'
  };
  const descriptions = {
    setup: 'Set the project identity, implementation phases, and workstream master data.',
    builder: 'Build and maintain the delivery structure: Phase, Activity, Main task, Task, and Subtask.',
    team: 'Maintain the project team, roles, and work assignments.'
  };
  content.insertAdjacentHTML('afterbegin', `<section class="portal-nav"><div><span class="section-kicker">PROJECT PORTAL SETUP</span><strong>${labels[portalSession]}</strong><small>${descriptions[portalSession]}</small></div><div class="portal-tabs" aria-label="Project Portal setup sessions">${Object.entries(labels).map(([key, label]) => `<button class="${portalSession === key ? 'active' : ''}" data-portal-session="${key}">${label}</button>`).join('')}</div></section>`);
}

async function weeklyPortal() {
  const sessions = { weekly: weeklyUpdatesEditable, attention: pmActions, raid: raidEditable };
  if (!sessions[weeklyPortalSession]) weeklyPortalSession = 'weekly';
  await sessions[weeklyPortalSession]();
  const labels = { weekly: 'Weekly workspace', attention: 'Delivery attention', raid: 'RAID register' };
  const descriptions = {
    weekly: 'Plan this week, record task progress, and capture role-level movement updates.',
    attention: 'Review only the exceptions that need a decision or follow-up.',
    raid: 'Manage project risks, assumptions, issues, and dependencies in one register.'
  };
  content.insertAdjacentHTML('afterbegin', `<section class="portal-nav weekly-portal-nav"><div><span class="section-kicker">WEEKLY PORTAL</span><strong>${labels[weeklyPortalSession]}</strong><small>${descriptions[weeklyPortalSession]}</small></div><div class="portal-tabs" aria-label="Weekly Portal sessions">${Object.entries(labels).map(([key, label]) => `<button class="${weeklyPortalSession === key ? 'active' : ''}" data-weekly-portal-session="${key}">${label}</button>`).join('')}</div></section>`);
}

async function workloadView() {
  const [{ current, projects }, data] = await Promise.all([projectContext(), api('/workload')]);
  const members = data.members || [];
  const today = data.today;

  // Compute overall alert level per person for row highlighting
  const alertClass = (m) => {
    if (m.rag_red > 0 || m.blocked > 0 || m.overdue > 0) return 'workload-row-alert';
    if (m.rag_amber > 0 || m.due_this_week > 0) return 'workload-row-warn';
    return '';
  };

  const ragDot = (red, amber, green) => {
    if (red > 0) return `<span class="rag-dot red"></span>`;
    if (amber > 0) return `<span class="rag-dot amber"></span>`;
    if (green > 0) return `<span class="rag-dot green"></span>`;
    return `<span class="rag-dot gray"></span>`;
  };

  const teamTable = members.length ? `
    <div class="table-wrap">
      <table class="table workload-table">
        <thead><tr>
          <th>MEMBER</th><th>DEPARTMENT / ROLE</th>
          <th>OPEN / ALL</th><th>IN PROGRESS</th><th>BLOCKED</th>
          <th>OVERDUE</th><th>DUE THIS WEEK</th>
          <th>RAG</th><th>AVG PROGRESS</th><th></th>
        </tr></thead>
        <tbody>
          ${members.map((m) => `
            <tr class="${alertClass(m)}">
              <td><strong>${m.display_name}</strong><span class="code">${m.employee_code || ''}</span></td>
              <td>${m.department || '—'}<small class="cell-note">${m.project_role || m.position_title || '—'}</small></td>
              <td><strong>${m.total} / ${m.total_tasks}</strong><small class="cell-note">${m.completed} Done</small></td>
              <td>${m.in_progress}</td>
              <td>${m.blocked > 0 ? `<span class="badge red">${m.blocked}</span>` : '—'}</td>
              <td>${m.overdue > 0 ? `<span class="badge red">${m.overdue} overdue</span>` : '<span class="badge green">On track</span>'}</td>
              <td>${m.due_this_week > 0 ? `<span class="badge amber">${m.due_this_week}</span>` : '—'}</td>
              <td>${ragDot(m.rag_red, m.rag_amber, m.rag_green)}
                  ${m.rag_red > 0 ? `<span class="badge red">${m.rag_red}R</span> ` : ''}
                  ${m.rag_amber > 0 ? `<span class="badge amber">${m.rag_amber}A</span> ` : ''}
                  ${m.rag_green > 0 ? `<span class="badge green">${m.rag_green}G</span>` : ''}</td>
              <td><strong>${m.avg_progress}%</strong><div class="progress compact"><span style="width:${m.avg_progress}%"></span></div></td>
              <td><button type="button" class="secondary compact-btn" data-workload-expand="${m.person_id}" aria-expanded="false" aria-controls="workload-detail-${m.person_id}">Detail</button></td>
            </tr>
            <tr class="workload-detail-row" id="workload-detail-${m.person_id}" hidden>
              <td colspan="10">
                <div class="workload-detail-inner">
                  <div class="workload-detail-header">
                    <span>📋 งานทั้งหมดของ <strong>${m.display_name}</strong> ที่ยังไม่เสร็จ (${m.total} รายการ)</span>
                    <div class="workload-detail-filters">
                      <span class="workload-filter-icon" aria-hidden="true">⌁</span>
                      <label><span>Status</span>
                        <select data-workload-status-filter="${m.person_id}">
                          <option value="">All statuses</option>
                          <option value="InProgress">In progress</option>
                          <option value="Blocked">Blocked</option>
                          <option value="OnHold">On hold</option>
                          <option value="NotStarted">Not started</option>
                        </select>
                      </label>
                      <label><span>RAG</span>
                        <select data-workload-rag-filter="${m.person_id}">
                          <option value="">All RAG</option>
                          <option value="Red">Red</option>
                          <option value="Amber">Amber</option>
                          <option value="Green">Green</option>
                        </select>
                      </label>
                      <label><span>Group by</span>
                        <select data-workload-group-by="${m.person_id}">
                          <option value="">No grouping</option>
                          <option value="activity">WBS / Activity</option>
                        </select>
                      </label>
                      <button type="button" class="workload-filter-reset" data-workload-filter-reset="${m.person_id}">Reset</button>
                      <span class="workload-filter-count" data-workload-filter-count="${m.person_id}">${m.total} shown</span>
                    </div>
                  </div>
                  ${m.tasks.length ? `
                    <div class="table-wrap">
                      <table class="table">
                        <thead><tr>
                          <th>CODE</th><th>TASK NAME</th><th>WBS / ACTIVITY</th><th>TYPE</th><th>STATUS</th>
                          <th>RAG</th><th>PROGRESS</th><th>DUE DATE</th><th>ROLE</th><th>BLOCKER</th>
                        </tr></thead>
                        <tbody>
                          ${m.tasks.map((t, index) => `
                            <tr class="${t.is_overdue ? 'workload-overdue-row' : ''}" data-workload-task-row="${m.person_id}" data-task-status="${t.status}" data-task-rag="${t.rag_status}" data-task-wbs-code="${t.wbs_code || ''}" data-task-wbs-name="${t.wbs_name || ''}" data-task-original-index="${index}">
                              <td><span class="code inline-code">${t.task_code}</span></td>
                              <td>
                                <strong>${t.task_name}</strong>
                                ${t.workstream ? `<small class="cell-note">${t.workstream}</small>` : ''}
                                ${t.latest_next_step ? `<small class="cell-note subtle">→ ${t.latest_next_step}</small>` : ''}
                              </td>
                              <td>
                                <span class="type-pill wbs-pill">WBS</span>
                                <span class="code inline-code">${t.wbs_code || '—'}</span>
                                <small class="cell-note">${t.wbs_name || 'No activity'}</small>
                              </td>
                              <td>${badge(t.task_type)}</td>
                              <td>${badge(t.status)}</td>
                              <td>${badge(t.rag_status)}</td>
                              <td>
                                <strong>${t.progress}%</strong>
                                <div class="progress compact"><span style="width:${t.progress}%"></span></div>
                              </td>
                              <td>${t.planned_due_date
                                ? `<span class="${t.is_overdue ? 'badge red' : t.is_due_this_week ? 'badge amber' : ''}">${t.planned_due_date}${t.is_overdue ? ' ⚠️' : ''}</span>`
                                : '—'}</td>
                              <td>${t.assignment_role || '—'}</td>
                              <td>${t.latest_blocker ? `<span class="workload-blocker">🔴 ${t.latest_blocker}</span>` : '—'}</td>
                            </tr>
                          `).join('')}
                        </tbody>
                      </table>
                    </div>
                    <p class="empty workload-filter-empty" data-workload-filter-empty="${m.person_id}" hidden>No tasks match the selected filters.</p>
                  ` : '<p class="empty">ไม่มีงานที่ค้างอยู่</p>'}
                </div>
              </td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  ` : '<p class="empty">ไม่มีสมาชิกในโปรเจกต์นี้</p>';

  // Summary cards
  const totalOpen = members.reduce((s, m) => s + m.total, 0);
  const totalTasks = members.reduce((s, m) => s + m.total_tasks, 0);
  const totalCompleted = members.reduce((s, m) => s + m.completed, 0);
  const totalOverdue = members.reduce((s, m) => s + m.overdue, 0);
  const totalBlocked = members.reduce((s, m) => s + m.blocked, 0);
  const totalDueThisWeek = members.reduce((s, m) => s + m.due_this_week, 0);
  const totalRed = members.reduce((s, m) => s + m.rag_red, 0);

  content.innerHTML = `
    ${contextBar(current, projects)}
    <section class="control-hero">
      <div>
        <span class="section-kicker">WORKLOAD VIEW</span>
        <h2>Team workload — งานที่ยังไม่เสร็จ</h2>
        <p>สรุป workload ต่อบุคคล แสดงเฉพาะงานที่ยังไม่เสร็จ (status ≠ Done) · วันนี้ ${today}</p>
      </div>
    </section>
    <div class="cards">
      <div class="card">
        <p>งานค้างทั้งหมด</p>
        <div class="metric">${totalOpen}</div>
        <p>${totalCompleted} Done · ${totalTasks} total</p>
        <p>${members.length} คนในทีม</p>
      </div>
      <div class="card">
        <p>Overdue</p>
        <div class="metric" style="${totalOverdue > 0 ? 'color:var(--red)' : ''}">${totalOverdue}</div>
        <p>เลยกำหนดแล้ว</p>
      </div>
      <div class="card">
        <p>Blocked</p>
        <div class="metric" style="${totalBlocked > 0 ? 'color:var(--red)' : ''}">${totalBlocked}</div>
        <p>ติดขัดต้องแก้ไข</p>
      </div>
      <div class="card">
        <p>Due สัปดาห์นี้</p>
        <div class="metric" style="${totalDueThisWeek > 0 ? 'color:var(--amber)' : ''}">${totalDueThisWeek}</div>
        <p>ครบกำหนดสัปดาห์นี้</p>
      </div>
      <div class="card">
        <p>Red RAG</p>
        <div class="metric" style="${totalRed > 0 ? 'color:var(--red)' : ''}">${totalRed}</div>
        <p>งานสัญญาณแดง</p>
      </div>
    </div>
    <section class="panel">
      <div class="panel-head">
        <div>
          <h2>Workload ต่อบุคคล</h2>
          <span class="subtle">คลิก "Detail" เพื่อดูรายการงานของแต่ละคน · แถวสีแดงหมายถึงมีงาน Overdue / Blocked / Red RAG</span>
        </div>
      </div>
      ${teamTable}
    </section>
  `;

}

function escapeHtml(str) {
  if (str == null) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

async function allProjectsWorkloadView() {
  const data = await api('/workload/all-projects?includeDone=true');
  const reportDate = data.reportDate || data.report_date || new Date().toISOString().slice(0, 10);
  const rawTasks = data.taskDetailRecords || [];
  const initialPeople = data.peopleAggregates || [];
  const initialProjects = data.projectAggregates || [];

  let state = {
    search: '',
    department: '',
    project: '',
    status: '',
    rag: '',
    dueState: '',
    relationship: '',
    showMode: 'open',
    includeEmptyProjects: false,
    selectedPersonId: null,
    selectedProjectId: null,
    matrixSort: 'risk',
    matrixSortDir: 'desc',
    detailSelection: null,
    detailGroupBy: 'project'
  };

  const departments = [...new Set(initialPeople.map((p) => p.department).filter(Boolean))].sort();
  const allActiveProjects = [...initialProjects].sort((a, b) => (a.projectCode || a.project_code || '').localeCompare(b.projectCode || b.project_code || ''));

  function render() {
    const filteredTasks = rawTasks.filter((t) => {
      if (state.showMode === 'open' && t.status === 'Done') return false;
      if (state.search) {
        const q = state.search.toLowerCase().trim();
        const matches = (t.personName || t.person_name || '').toLowerCase().includes(q)
          || (t.taskName || t.task_name || '').toLowerCase().includes(q)
          || (t.taskCode || t.task_code || '').toLowerCase().includes(q)
          || (t.projectCode || t.project_code || '').toLowerCase().includes(q)
          || (t.wbsName || t.wbs_name || '').toLowerCase().includes(q)
          || (t.wbsCode || t.wbs_code || '').toLowerCase().includes(q);
        if (!matches) return false;
      }
      if (state.department) {
        const person = initialPeople.find((p) => p.personId === t.personId || p.person_id === t.personId);
        if ((person?.department || '') !== state.department) return false;
      }
      if (state.project && (t.projectId || t.project_id) !== state.project) return false;
      if (state.status && t.status !== state.status) return false;
      if (state.rag && (t.ragStatus || t.rag_status) !== state.rag) return false;
      if (state.dueState === 'overdue' && !t.isOverdue && !t.is_overdue) return false;
      if (state.dueState === 'due_this_week' && !t.isDueThisWeek && !t.is_due_this_week) return false;
      if (state.dueState === 'no_due_date' && (t.plannedDueDate || t.planned_due_date)) return false;
      if (state.relationship === 'owner' && !t.isOwner && !t.is_owner) return false;
      if (state.relationship === 'assignee' && !t.isAssignee && !t.is_assignee) return false;
      if (state.relationship === 'owner_or_assignee' && !(t.isOwner || t.is_owner || t.isAssignee || t.is_assignee)) return false;

      if (state.selectedPersonId && (t.personId || t.person_id) !== state.selectedPersonId) return false;
      if (state.selectedProjectId && (t.projectId || t.project_id) !== state.selectedProjectId) return false;

      return true;
    });

    const totalOpenWork = filteredTasks.filter((t) => t.status !== 'Done').length;
    const totalDoneWork = filteredTasks.filter((t) => t.status === 'Done').length;
    const totalTasksCount = state.showMode === 'all' ? filteredTasks.length : totalOpenWork;
    const totalOverdue = filteredTasks.filter((t) => (t.isOverdue || t.is_overdue)).length;
    const totalBlocked = filteredTasks.filter((t) => t.status === 'Blocked').length;
    const totalDueThisWeek = filteredTasks.filter((t) => (t.isDueThisWeek || t.is_due_this_week)).length;
    const totalRed = filteredTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Red').length;
    const activePeopleIds = new Set(filteredTasks.map((t) => t.personId || t.person_id));
    const activeProjectIds = new Set(filteredTasks.map((t) => t.projectId || t.project_id));

    let basePeople = initialPeople.filter((p) => {
      const pId = p.personId || p.person_id;
      if (state.department && p.department !== state.department) return false;
      if (state.search) {
        const q = state.search.toLowerCase().trim();
        const matches = (p.displayName || p.display_name || '').toLowerCase().includes(q)
          || (p.employeeCode || p.employee_code || '').toLowerCase().includes(q);
        if (!matches && !filteredTasks.some((t) => (t.personId || t.person_id) === pId)) return false;
      }
      return true;
    });

    const peopleWorkload = basePeople.map((p) => {
      const pId = p.personId || p.person_id;
      const pTasks = filteredTasks.filter((t) => (t.personId || t.person_id) === pId);
      const openTasks = pTasks.filter((t) => t.status !== 'Done');
      const count = state.showMode === 'all' ? pTasks.length : openTasks.length;
      const inProgress = pTasks.filter((t) => t.status === 'InProgress').length;
      const notStarted = pTasks.filter((t) => t.status === 'NotStarted').length;
      const blocked = pTasks.filter((t) => t.status === 'Blocked').length;
      const onHold = pTasks.filter((t) => t.status === 'OnHold').length;
      const done = pTasks.filter((t) => t.status === 'Done').length;
      const overdue = pTasks.filter((t) => t.isOverdue || t.is_overdue).length;
      const dueThisWeek = pTasks.filter((t) => t.isDueThisWeek || t.is_due_this_week).length;
      const ragRed = pTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Red').length;
      const ragAmber = pTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Amber').length;
      const ragGreen = pTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Green').length;
      const avgProgress = pTasks.length ? Math.round(pTasks.reduce((s, t) => s + (t.progress || 0), 0) / pTasks.length) : 0;
      const projectsCount = new Set(pTasks.map((t) => t.projectId || t.project_id)).size;

      return {
        ...p,
        personId: pId,
        displayName: p.displayName || p.display_name,
        employeeCode: p.employeeCode || p.employee_code,
        total: count,
        totalOpen: openTasks.length,
        inProgress,
        notStarted,
        blocked,
        onHold,
        done,
        overdue,
        dueThisWeek,
        ragRed,
        ragAmber,
        ragGreen,
        avgProgress,
        projectsCount,
        tasks: pTasks
      };
    });

    const sortedPeople = [...peopleWorkload].sort((a, b) => {
      return (b.blocked - a.blocked)
        || (b.overdue - a.overdue)
        || (b.ragRed - a.ragRed)
        || (b.total - a.total)
        || a.displayName.localeCompare(b.displayName);
    });

    let baseProjects = allActiveProjects.filter((proj) => {
      const projId = proj.projectId || proj.project_id;
      if (state.project && projId !== state.project) return false;
      return true;
    });

    const projectWorkload = baseProjects.map((proj) => {
      const projId = proj.projectId || proj.project_id;
      const projTasks = filteredTasks.filter((t) => (t.projectId || t.project_id) === projId);
      const openTasks = projTasks.filter((t) => t.status !== 'Done');
      const count = state.showMode === 'all' ? projTasks.length : openTasks.length;
      const ragRed = projTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Red').length;
      const ragAmber = projTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Amber').length;
      const ragGreen = projTasks.filter((t) => (t.ragStatus || t.rag_status) === 'Green').length;
      const overdue = projTasks.filter((t) => t.isOverdue || t.is_overdue).length;
      const blocked = projTasks.filter((t) => t.status === 'Blocked').length;
      const peopleWithWork = new Set(projTasks.map((t) => t.personId || t.person_id)).size;
      const avgProgress = projTasks.length ? Math.round(projTasks.reduce((s, t) => s + (t.progress || 0), 0) / projTasks.length) : 0;

      return {
        ...proj,
        projectId: projId,
        projectCode: proj.projectCode || proj.project_code,
        projectName: proj.projectName || proj.project_name,
        portfolioName: proj.portfolioName || proj.portfolio_name,
        total: count,
        totalOpen: openTasks.length,
        ragRed,
        ragAmber,
        ragGreen,
        overdue,
        blocked,
        peopleCount: peopleWithWork,
        avgProgress,
        tasks: projTasks
      };
    });

    const sortedProjects = [...projectWorkload]
      .filter((proj) => state.includeEmptyProjects || proj.total > 0)
      .sort((a, b) => (b.total - a.total) || a.projectCode.localeCompare(b.projectCode));

    const visibleProjects = sortedProjects.length ? sortedProjects : allActiveProjects.map((p) => ({
      ...p,
      projectId: p.projectId || p.project_id,
      projectCode: p.projectCode || p.project_code,
      projectName: p.projectName || p.project_name
    }));

    let matrixPeople = [...peopleWorkload];
    if (state.matrixSort === 'totalOpen') {
      matrixPeople.sort((a, b) => state.matrixSortDir === 'asc' ? a.total - b.total : b.total - a.total);
    } else if (state.matrixSort === 'overdue') {
      matrixPeople.sort((a, b) => state.matrixSortDir === 'asc' ? a.overdue - b.overdue : b.overdue - a.overdue);
    } else if (state.matrixSort === 'blocked') {
      matrixPeople.sort((a, b) => state.matrixSortDir === 'asc' ? a.blocked - b.blocked : b.blocked - a.blocked);
    } else if (state.matrixSort === 'ragRed') {
      matrixPeople.sort((a, b) => state.matrixSortDir === 'asc' ? a.ragRed - b.ragRed : b.ragRed - a.ragRed);
    } else if (state.matrixSort === 'name') {
      matrixPeople.sort((a, b) => state.matrixSortDir === 'asc' ? a.displayName.localeCompare(b.displayName) : b.displayName.localeCompare(a.displayName));
    } else {
      matrixPeople.sort((a, b) => (b.blocked - a.blocked) || (b.overdue - a.overdue) || (b.ragRed - a.ragRed) || (b.total - a.total));
    }

    let drillTasks = filteredTasks;
    let drillTitle = 'All filtered tasks';
    if (state.detailSelection) {
      const { personId, projectId } = state.detailSelection;
      if (personId && projectId) {
        const person = initialPeople.find((p) => (p.personId || p.person_id) === personId);
        const proj = allActiveProjects.find((p) => (p.projectId || p.project_id) === projectId);
        drillTitle = `Tasks for ${person?.displayName || person?.display_name || 'Person'} in [${proj?.projectCode || proj?.project_code || 'Project'}] ${proj?.projectName || proj?.project_name || ''}`;
        drillTasks = filteredTasks.filter((t) => (t.personId || t.person_id) === personId && (t.projectId || t.project_id) === projectId);
      } else if (personId) {
        const person = initialPeople.find((p) => (p.personId || p.person_id) === personId);
        drillTitle = `All cross-project tasks for ${person?.displayName || person?.display_name || 'Person'}`;
        drillTasks = filteredTasks.filter((t) => (t.personId || t.person_id) === personId);
      } else if (projectId) {
        const proj = allActiveProjects.find((p) => (p.projectId || p.project_id) === projectId);
        drillTitle = `All team tasks in [${proj?.projectCode || proj?.project_code || 'Project'}] ${proj?.projectName || proj?.project_name || ''}`;
        drillTasks = filteredTasks.filter((t) => (t.projectId || t.project_id) === projectId);
      }
    }

    const maxPersonTotal = Math.max(1, ...sortedPeople.map((p) => p.total));
    const maxProjectTotal = Math.max(1, ...sortedProjects.map((p) => p.total));

    content.innerHTML = `
      <section class="control-hero all-workload-hero">
        <div>
          <span class="section-kicker">PORTFOLIO WORKLOAD REPORT</span>
          <h2>All Projects Workload — ภาระงานรายบุคคลแบบรวมทุก Project</h2>
          <p>วิเคราะห์และควบคุมภาระงาน ความเสี่ยง และจุดติดขัดของบุคลากรทุกคนจากทุก Active Project · วันที่ ${reportDate}</p>
        </div>
      </section>

      <div class="cards">
        <div class="card">
          <p>ภาระงานเปิดทั้งหมด</p>
          <div class="metric">${totalOpenWork}</div>
          <p>${totalDoneWork} Done · ${filteredTasks.length} รวม</p>
          <p>${activePeopleIds.size} บุคลากร · ${activeProjectIds.size} Projects</p>
        </div>
        <div class="card">
          <p>Overdue (เลยกำหนด)</p>
          <div class="metric" style="${totalOverdue > 0 ? 'color:var(--red)' : ''}">${totalOverdue}</div>
          <p>งานที่เกิน Due date และยังไม่ Done</p>
        </div>
        <div class="card">
          <p>Blocked (ติดขัด)</p>
          <div class="metric" style="${totalBlocked > 0 ? 'color:var(--red)' : ''}">${totalBlocked}</div>
          <p>ต้องแก้ไขหรือปลดล็อกเร่งด่วน</p>
        </div>
        <div class="card">
          <p>Due สัปดาห์นี้</p>
          <div class="metric" style="${totalDueThisWeek > 0 ? 'color:var(--amber)' : ''}">${totalDueThisWeek}</div>
          <p>ครบกำหนดภายในสัปดาห์นี้</p>
        </div>
        <div class="card">
          <p>Red RAG</p>
          <div class="metric" style="${totalRed > 0 ? 'color:var(--red)' : ''}">${totalRed}</div>
          <p>งานสัญญาณความเสี่ยงแดง</p>
        </div>
      </div>

      <section class="all-workload-filter-card">
        <div class="all-workload-filter-grid">
          <label>
            <span>Search Person</span>
            <input type="text" id="all-workload-search" placeholder="Filter by name, code..." value="${escapeHtml(state.search)}">
          </label>
          <label>
            <span>Department</span>
            <select id="all-workload-dept">
              <option value="">All departments</option>
              ${departments.map((d) => `<option value="${escapeHtml(d)}" ${d === state.department ? 'selected' : ''}>${escapeHtml(d)}</option>`).join('')}
            </select>
          </label>
          <label>
            <span>Project</span>
            <select id="all-workload-proj">
              <option value="">All active projects</option>
              ${allActiveProjects.map((p) => {
                const pId = p.projectId || p.project_id;
                const pCode = p.projectCode || p.project_code;
                const pName = p.projectName || p.project_name;
                return `<option value="${pId}" ${pId === state.project ? 'selected' : ''}>[${pCode}] ${escapeHtml(pName)}</option>`;
              }).join('')}
            </select>
          </label>
          <label>
            <span>Status</span>
            <select id="all-workload-status">
              <option value="">All statuses</option>
              <option value="InProgress" ${state.status === 'InProgress' ? 'selected' : ''}>In progress</option>
              <option value="Blocked" ${state.status === 'Blocked' ? 'selected' : ''}>Blocked</option>
              <option value="OnHold" ${state.status === 'OnHold' ? 'selected' : ''}>On hold</option>
              <option value="NotStarted" ${state.status === 'NotStarted' ? 'selected' : ''}>Not started</option>
              <option value="Done" ${state.status === 'Done' ? 'selected' : ''}>Done</option>
            </select>
          </label>
          <label>
            <span>RAG</span>
            <select id="all-workload-rag">
              <option value="">All RAG</option>
              <option value="Red" ${state.rag === 'Red' ? 'selected' : ''}>Red</option>
              <option value="Amber" ${state.rag === 'Amber' ? 'selected' : ''}>Amber</option>
              <option value="Green" ${state.rag === 'Green' ? 'selected' : ''}>Green</option>
            </select>
          </label>
          <label>
            <span>Due State</span>
            <select id="all-workload-due">
              <option value="">All due states</option>
              <option value="overdue" ${state.dueState === 'overdue' ? 'selected' : ''}>Overdue</option>
              <option value="due_this_week" ${state.dueState === 'due_this_week' ? 'selected' : ''}>Due this week</option>
              <option value="no_due_date" ${state.dueState === 'no_due_date' ? 'selected' : ''}>No due date</option>
            </select>
          </label>
          <label>
            <span>Assignment Relationship</span>
            <select id="all-workload-rel">
              <option value="">Owner or assignee</option>
              <option value="owner" ${state.relationship === 'owner' ? 'selected' : ''}>Owner</option>
              <option value="assignee" ${state.relationship === 'assignee' ? 'selected' : ''}>Assignee</option>
            </select>
          </label>
        </div>

        <div class="all-workload-filter-bottom">
          <div class="all-workload-filter-toggles">
            <label>
              <input type="radio" name="showMode" value="open" ${state.showMode === 'open' ? 'checked' : ''}>
              <span>Open work only</span>
            </label>
            <label>
              <input type="radio" name="showMode" value="all" ${state.showMode === 'all' ? 'checked' : ''}>
              <span>Include Done</span>
            </label>
            <label>
              <input type="checkbox" id="all-workload-empty-proj" ${state.includeEmptyProjects ? 'checked' : ''}>
              <span>Include projects with no open work</span>
            </label>
          </div>
          <div class="all-workload-filter-actions">
            <span class="all-workload-filter-stats">
              ${filteredTasks.length} tasks shown · ${activePeopleIds.size} people · ${activeProjectIds.size} projects
            </span>
            ${state.selectedPersonId ? `<button type="button" class="secondary compact-btn" id="all-workload-clear-person">✕ Clear Person Selection</button>` : ''}
            ${state.selectedProjectId ? `<button type="button" class="secondary compact-btn" id="all-workload-clear-proj">✕ Clear Project Selection</button>` : ''}
            <button type="button" class="secondary compact-btn" id="all-workload-reset">Reset</button>
          </div>
        </div>
      </section>

      <div class="all-workload-charts-grid">
        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <h3>ส่วนที่ 1: Workload by Person</h3>
              <p>เรียงตามความเสี่ยง (Blocked → Overdue → Red RAG → Total) · คลิกที่แถบเพื่อกรอง</p>
            </div>
            <span class="badge gray">${sortedPeople.length} บุคลากร</span>
          </div>

          <div class="chart-legend">
            <span class="chart-legend-item"><span class="rag-dot" style="background:#215f45"></span> In progress</span>
            <span class="chart-legend-item"><span class="rag-dot" style="background:#a2b0a5"></span> Not started</span>
            <span class="chart-legend-item"><span class="rag-dot" style="background:#d9544d"></span> Blocked</span>
            <span class="chart-legend-item"><span class="rag-dot" style="background:#e3a329"></span> On hold</span>
            ${state.showMode === 'all' ? '<span class="chart-legend-item"><span class="rag-dot" style="background:#7ab38d"></span> Done</span>' : ''}
          </div>

          <div class="chart-bars-list">
            ${sortedPeople.length ? sortedPeople.map((p) => {
              const isSelected = state.selectedPersonId === p.personId;
              const barPercent = Math.max(3, Math.round((p.total / maxPersonTotal) * 100));
              const segInProg = p.total ? Math.round((p.inProgress / p.total) * 100) : 0;
              const segNotStarted = p.total ? Math.round((p.notStarted / p.total) * 100) : 0;
              const segBlocked = p.total ? Math.round((p.blocked / p.total) * 100) : 0;
              const segOnHold = p.total ? Math.round((p.onHold / p.total) * 100) : 0;
              const segDone = p.total && state.showMode === 'all' ? Math.round((p.done / p.total) * 100) : 0;

              return `
                <button type="button" class="workload-bar-item ${isSelected ? 'active' : ''}" data-person-bar="${p.personId}" aria-pressed="${isSelected}">
                  <div class="workload-bar-item-header">
                    <div>
                      <strong>${escapeHtml(p.displayName)}</strong>
                      <small class="cell-note">${escapeHtml(p.department || '—')} ${p.employeeCode ? `· ${p.employeeCode}` : ''}</small>
                    </div>
                    <div>
                      <strong>${p.total}</strong> <small class="cell-note">tasks (${p.projectsCount} proj)</small>
                    </div>
                  </div>
                  <div class="workload-bar-track" style="width: ${barPercent}%" title="Total: ${p.total}">
                    ${segBlocked > 0 ? `<div class="workload-bar-segment blocked" style="width:${segBlocked}%" title="Blocked: ${p.blocked}"></div>` : ''}
                    ${segInProg > 0 ? `<div class="workload-bar-segment in-progress" style="width:${segInProg}%" title="In progress: ${p.inProgress}"></div>` : ''}
                    ${segOnHold > 0 ? `<div class="workload-bar-segment on-hold" style="width:${segOnHold}%" title="On hold: ${p.onHold}"></div>` : ''}
                    ${segNotStarted > 0 ? `<div class="workload-bar-segment not-started" style="width:${segNotStarted}%" title="Not started: ${p.notStarted}"></div>` : ''}
                    ${segDone > 0 ? `<div class="workload-bar-segment done" style="width:${segDone}%" title="Done: ${p.done}"></div>` : ''}
                  </div>
                  <div class="workload-bar-badges">
                    ${p.blocked > 0 ? `<span class="badge red">🚫 ${p.blocked} Blocked</span>` : ''}
                    ${p.overdue > 0 ? `<span class="badge red">⚠️ ${p.overdue} Overdue</span>` : ''}
                    ${p.ragRed > 0 ? `<span class="badge red">🔴 ${p.ragRed} Red RAG</span>` : ''}
                    ${p.ragAmber > 0 ? `<span class="badge amber">🟡 ${p.ragAmber} Amber</span>` : ''}
                    ${p.ragGreen > 0 ? `<span class="badge green">🟢 ${p.ragGreen} Green</span>` : ''}
                    <span class="cell-note subtle">Avg: ${p.avgProgress}%</span>
                  </div>
                </button>
              `;
            }).join('') : '<p class="empty">No people match filters.</p>'}
          </div>
        </div>

        <div class="chart-card">
          <div class="chart-card-header">
            <div>
              <h3>ส่วนที่ 2: Workload by Project</h3>
              <p>เรียงตามภาระงานมากไปน้อย · แบ่งตาม RAG · คลิกที่แถบเพื่อกรอง</p>
            </div>
            <span class="badge gray">${sortedProjects.length} Projects</span>
          </div>

          <div class="chart-legend">
            <span class="chart-legend-item"><span class="rag-dot red"></span> Red</span>
            <span class="chart-legend-item"><span class="rag-dot amber"></span> Amber</span>
            <span class="chart-legend-item"><span class="rag-dot green"></span> Green</span>
          </div>

          <div class="chart-bars-list">
            ${sortedProjects.length ? sortedProjects.map((proj) => {
              const isSelected = state.selectedProjectId === proj.projectId;
              const barPercent = Math.max(3, Math.round((proj.total / maxProjectTotal) * 100));
              const segRed = proj.total ? Math.round((proj.ragRed / proj.total) * 100) : 0;
              const segAmber = proj.total ? Math.round((proj.ragAmber / proj.total) * 100) : 0;
              const segGreen = proj.total ? Math.round((proj.ragGreen / proj.total) * 100) : 0;

              return `
                <button type="button" class="workload-bar-item ${isSelected ? 'active' : ''}" data-project-bar="${proj.projectId}" aria-pressed="${isSelected}">
                  <div class="workload-bar-item-header">
                    <div>
                      <strong>[${proj.projectCode}]</strong> ${escapeHtml(proj.projectName)}
                      <small class="cell-note">${proj.portfolioName || 'Portfolio'}</small>
                    </div>
                    <div>
                      <strong>${proj.total}</strong> <small class="cell-note">tasks</small>
                    </div>
                  </div>
                  <div class="workload-bar-track" style="width: ${barPercent}%" title="Total: ${proj.total}">
                    ${segRed > 0 ? `<div class="workload-bar-segment rag-red" style="width:${segRed}%" title="Red: ${proj.ragRed}"></div>` : ''}
                    ${segAmber > 0 ? `<div class="workload-bar-segment rag-amber" style="width:${segAmber}%" title="Amber: ${proj.ragAmber}"></div>` : ''}
                    ${segGreen > 0 ? `<div class="workload-bar-segment rag-green" style="width:${segGreen}%" title="Green: ${proj.ragGreen}"></div>` : ''}
                  </div>
                  <div class="workload-bar-badges">
                    <span class="badge gray">👥 ${proj.peopleCount} people</span>
                    ${proj.overdue > 0 ? `<span class="badge red">⚠️ ${proj.overdue} Overdue</span>` : ''}
                    ${proj.blocked > 0 ? `<span class="badge red">🚫 ${proj.blocked} Blocked</span>` : ''}
                    <span class="cell-note subtle">Avg: ${proj.avgProgress}%</span>
                  </div>
                </button>
              `;
            }).join('') : '<p class="empty">No projects match filters.</p>'}
          </div>
        </div>
      </div>

      <section class="panel">
        <div class="panel-head">
          <div>
            <h2>ส่วนที่ 3: Person × Project Matrix</h2>
            <span class="subtle">คลิกช่องตารางเพื่อ Drill-down รายละเอียดตาม Person → Project → WBS/Activity → Work items</span>
          </div>
          <div class="drilldown-controls">
            <label>Sort Matrix
              <select id="matrix-sort-select">
                <option value="risk" ${state.matrixSort === 'risk' ? 'selected' : ''}>Risk Priority (Blocked/Overdue/RAG)</option>
                <option value="totalOpen" ${state.matrixSort === 'totalOpen' ? 'selected' : ''}>Total Open</option>
                <option value="overdue" ${state.matrixSort === 'overdue' ? 'selected' : ''}>Overdue</option>
                <option value="blocked" ${state.matrixSort === 'blocked' ? 'selected' : ''}>Blocked</option>
                <option value="ragRed" ${state.matrixSort === 'ragRed' ? 'selected' : ''}>Red RAG</option>
                <option value="name" ${state.matrixSort === 'name' ? 'selected' : ''}>Person Name</option>
              </select>
            </label>
          </div>
        </div>

        <div class="all-projects-matrix-wrap">
          <table class="matrix-table">
            <thead>
              <tr>
                <th style="min-width: 170px;">
                  <button type="button" class="sort-btn" data-matrix-sort="name">PERSON / ROLE ↕</button>
                </th>
                ${visibleProjects.map((proj) => `
                  <th class="num-col" title="${escapeHtml(proj.projectName)}">
                    [${proj.projectCode}]
                  </th>
                `).join('')}
                <th class="num-col"><button type="button" class="sort-btn" data-matrix-sort="totalOpen">TOTAL OPEN ↕</button></th>
                <th class="num-col">IN PROG</th>
                <th class="num-col"><button type="button" class="sort-btn" data-matrix-sort="blocked">BLOCKED ↕</button></th>
                <th class="num-col"><button type="button" class="sort-btn" data-matrix-sort="overdue">OVERDUE ↕</button></th>
                <th class="num-col"><button type="button" class="sort-btn" data-matrix-sort="ragRed">RED RAG ↕</button></th>
                <th class="num-col" style="min-width: 100px;">AVG PROGRESS</th>
                <th>ACTION</th>
              </tr>
            </thead>
            <tbody>
              ${matrixPeople.length ? matrixPeople.map((p) => {
                const isSelected = state.selectedPersonId === p.personId;
                return `
                  <tr class="${isSelected ? 'selected-person' : ''}">
                    <td>
                      <strong>${escapeHtml(p.displayName)}</strong>
                      <small class="cell-note">${escapeHtml(p.department || '—')} ${p.employeeCode ? `· ${p.employeeCode}` : ''}</small>
                    </td>
                    ${visibleProjects.map((proj) => {
                      const cellTasks = filteredTasks.filter((t) => (t.personId || t.person_id) === p.personId && (t.projectId || t.project_id) === proj.projectId);
                      const openCount = cellTasks.filter((t) => state.showMode === 'all' || t.status !== 'Done').length;
                      const hasOverdue = cellTasks.some((t) => t.isOverdue || t.is_overdue);
                      const hasBlocked = cellTasks.some((t) => t.status === 'Blocked');
                      const hasRed = cellTasks.some((t) => (t.ragStatus || t.rag_status) === 'Red');

                      if (openCount === 0) {
                        return '<td class="num-col cell-note subtle">—</td>';
                      }
                      const riskClass = (hasOverdue || hasBlocked || hasRed) ? 'has-risk' : '';
                      const warningText = hasBlocked ? '🚫' : hasOverdue ? '⚠️' : hasRed ? '🔴' : '';

                      return `
                        <td class="num-col">
                          <button type="button" class="matrix-cell-btn ${riskClass}" data-matrix-cell="${p.personId}:${proj.projectId}" title="Drilldown ${escapeHtml(p.displayName)} in ${proj.projectCode}">
                            ${openCount} ${warningText}
                          </button>
                        </td>
                      `;
                    }).join('')}
                    <td class="num-col"><strong>${p.total}</strong></td>
                    <td class="num-col">${p.inProgress}</td>
                    <td class="num-col">${p.blocked > 0 ? `<span class="badge red">${p.blocked}</span>` : '—'}</td>
                    <td class="num-col">${p.overdue > 0 ? `<span class="badge red">${p.overdue}</span>` : '—'}</td>
                    <td class="num-col">${p.ragRed > 0 ? `<span class="badge red">${p.ragRed}</span>` : '—'}</td>
                    <td class="num-col">
                      <strong>${p.avgProgress}%</strong>
                      <div class="progress compact"><span style="width:${p.avgProgress}%"></span></div>
                    </td>
                    <td>
                      <button type="button" class="secondary compact-btn" data-matrix-view-person="${p.personId}">Detail</button>
                    </td>
                  </tr>
                `;
              }).join('') : '<tr><td colspan="15" class="empty">No people matching current filters.</td></tr>'}
            </tbody>
            <tfoot>
              <tr class="matrix-total-row">
                <td>TOTAL</td>
                ${visibleProjects.map((proj) => {
                  const projTasks = filteredTasks.filter((t) => (t.projectId || t.project_id) === proj.projectId);
                  const projColTotal = projTasks.filter((t) => state.showMode === 'all' || t.status !== 'Done').length;
                  return `<td class="num-col"><strong>${projColTotal}</strong></td>`;
                }).join('')}
                <td class="num-col"><strong>${totalTasksCount}</strong></td>
                <td class="num-col"><strong>${filteredTasks.filter((t) => t.status === 'InProgress').length}</strong></td>
                <td class="num-col"><strong>${totalBlocked}</strong></td>
                <td class="num-col"><strong>${totalOverdue}</strong></td>
                <td class="num-col"><strong>${totalRed}</strong></td>
                <td class="num-col">
                  <strong>${filteredTasks.length ? Math.round(filteredTasks.reduce((s, t) => s + (t.progress || 0), 0) / filteredTasks.length) : 0}%</strong>
                </td>
                <td></td>
              </tr>
            </tfoot>
          </table>
        </div>
      </section>

      <section class="drilldown-panel" id="all-workload-drilldown">
        <div class="drilldown-header">
          <div class="drilldown-breadcrumb">
            <strong>📋 ${drillTitle}</strong>
            <span class="subtle"> (${drillTasks.length} work items)</span>
          </div>
          <div class="drilldown-controls">
            <label>
              <span>Group by</span>
              <select id="drilldown-group-by">
                <option value="project" ${state.detailGroupBy === 'project' ? 'selected' : ''}>Project</option>
                <option value="activity" ${state.detailGroupBy === 'activity' ? 'selected' : ''}>WBS / Activity</option>
                <option value="none" ${state.detailGroupBy === 'none' ? 'selected' : ''}>No grouping</option>
              </select>
            </label>
            ${state.detailSelection ? `<button type="button" class="secondary compact-btn" id="drilldown-clear-selection">View All Filtered Items</button>` : ''}
          </div>
        </div>

        ${drillTasks.length ? renderDrillTable(drillTasks, state.detailGroupBy) : '<p class="empty">No tasks found matching this selection.</p>'}
      </section>
    `;

    bindEvents();
  }

  function renderDrillTable(tasks, groupBy) {
    if (groupBy === 'project') {
      const groups = new Map();
      tasks.forEach((t) => {
        const key = t.projectId || t.project_id || 'other';
        const code = t.projectCode || t.project_code || '—';
        const name = t.projectName || t.project_name || 'Other';
        if (!groups.has(key)) groups.set(key, { code, name, items: [] });
        groups.get(key).items.push(t);
      });
      const groupEntries = [...groups.values()].sort((a, b) => a.code.localeCompare(b.code));

      return `
        <div class="table-wrap">
          <table class="table">
            <thead>
              <tr>
                <th>CODE</th><th>TASK NAME</th><th>WBS / ACTIVITY</th><th>ASSIGNEE / ROLE</th><th>TYPE</th>
                <th>STATUS</th><th>RAG</th><th>PROGRESS</th><th>DUE DATE</th><th>BLOCKER / NEXT STEP</th>
              </tr>
            </thead>
            <tbody>
              ${groupEntries.map((g) => `
                <tr class="drilldown-group-header">
                  <td colspan="10">
                    <span>PROJECT</span>
                    <strong>[${g.code}] ${escapeHtml(g.name)} (${g.items.length} work items)</strong>
                  </td>
                </tr>
                ${g.items.map(renderTaskRow).join('')}
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    }

    if (groupBy === 'activity') {
      const groups = new Map();
      tasks.forEach((t) => {
        const pCode = t.projectCode || t.project_code || '—';
        const wCode = t.wbsCode || t.wbs_code || '—';
        const wName = t.wbsName || t.wbs_name || 'No activity';
        const key = `${pCode}\u0000${wCode}\u0000${wName}`;
        if (!groups.has(key)) groups.set(key, { projCode: pCode, code: wCode, name: wName, items: [] });
        groups.get(key).items.push(t);
      });
      const groupEntries = [...groups.values()].sort((a, b) => (a.projCode.localeCompare(b.projCode) || a.code.localeCompare(b.code)));

      return `
        <div class="table-wrap">
          <table class="table">
            <thead>
              <tr>
                <th>CODE</th><th>TASK NAME</th><th>PROJECT</th><th>ASSIGNEE / ROLE</th><th>TYPE</th>
                <th>STATUS</th><th>RAG</th><th>PROGRESS</th><th>DUE DATE</th><th>BLOCKER / NEXT STEP</th>
              </tr>
            </thead>
            <tbody>
              ${groupEntries.map((g) => `
                <tr class="drilldown-group-header">
                  <td colspan="10">
                    <span>WBS / ACTIVITY · [${g.projCode}]</span>
                    <strong>${g.code} — ${escapeHtml(g.name)} (${g.items.length} work items)</strong>
                  </td>
                </tr>
                ${g.items.map(renderTaskRow).join('')}
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    }

    return `
      <div class="table-wrap">
        <table class="table">
          <thead>
            <tr>
              <th>CODE</th><th>TASK NAME</th><th>PROJECT</th><th>WBS / ACTIVITY</th><th>ASSIGNEE / ROLE</th>
              <th>TYPE</th><th>STATUS</th><th>RAG</th><th>PROGRESS</th><th>DUE DATE</th><th>BLOCKER / NEXT STEP</th>
            </tr>
          </thead>
          <tbody>
            ${tasks.map(renderTaskRow).join('')}
          </tbody>
        </table>
      </div>
    `;
  }

  function renderTaskRow(t) {
    const isOwner = Boolean(t.isOwner || t.is_owner);
    const isAssignee = Boolean(t.isAssignee || t.is_assignee);
    const relationshipBadge = (isOwner && isAssignee)
      ? '<span class="badge green">Owner & Assignee</span>'
      : isOwner
      ? '<span class="badge blue">Owner</span>'
      : '<span class="badge gray">Assignee</span>';

    const rag = t.ragStatus || t.rag_status || 'Green';
    const isOverdue = Boolean(t.isOverdue || t.is_overdue);
    const isDueThisWeek = Boolean(t.isDueThisWeek || t.is_due_this_week);
    const dueDate = t.plannedDueDate || t.planned_due_date;
    const blocker = t.latestBlocker || t.latest_blocker;
    const nextStep = t.latestNextStep || t.latest_next_step;
    const taskCode = t.taskCode || t.task_code;
    const taskName = t.taskName || t.task_name;
    const projectCode = t.projectCode || t.project_code;
    const projectName = t.projectName || t.project_name;
    const wbsCode = t.wbsCode || t.wbs_code;
    const wbsName = t.wbsName || t.wbs_name;
    const personName = t.personName || t.person_name;
    const assignmentRole = t.assignmentRole || t.assignment_role;
    const taskType = t.taskType || t.task_type;

    return `
      <tr class="${isOverdue ? 'workload-overdue-row' : ''}">
        <td><span class="code inline-code">${taskCode}</span></td>
        <td>
          <strong>${escapeHtml(taskName)}</strong>
          ${t.workstream ? `<small class="cell-note">${escapeHtml(t.workstream)}</small>` : ''}
        </td>
        <td>
          <span class="type-pill">[${projectCode}]</span>
          <small class="cell-note">${escapeHtml(projectName)}</small>
        </td>
        <td>
          <span class="type-pill wbs-pill">WBS</span>
          <span class="code inline-code">${wbsCode || '—'}</span>
          <small class="cell-note">${escapeHtml(wbsName || 'No activity')}</small>
        </td>
        <td>
          <strong>${escapeHtml(personName)}</strong>
          <small class="cell-note">${assignmentRole || 'TeamMember'} · ${relationshipBadge}</small>
        </td>
        <td>${badge(taskType)}</td>
        <td>${badge(t.status)}</td>
        <td>
          <span class="rag-dot ${rag.toLowerCase()}"></span>
          ${badge(rag)}
        </td>
        <td>
          <strong>${t.progress}%</strong>
          <div class="progress compact"><span style="width:${t.progress}%"></span></div>
        </td>
        <td>
          ${dueDate ? `
            <span class="${isOverdue ? 'badge red' : isDueThisWeek ? 'badge amber' : ''}">
              ${dueDate} ${isOverdue ? '⚠️' : ''}
            </span>
          ` : '—'}
        </td>
        <td>
          ${blocker ? `<span class="workload-blocker">🔴 ${escapeHtml(blocker)}</span>` : ''}
          ${nextStep ? `<small class="cell-note subtle">→ ${escapeHtml(nextStep)}</small>` : ''}
          ${!blocker && !nextStep ? '—' : ''}
        </td>
      </tr>
    `;
  }

  function bindEvents() {
    const searchInput = content.querySelector('#all-workload-search');
    searchInput?.addEventListener('input', (e) => {
      state.search = e.target.value;
      render();
    });

    content.querySelector('#all-workload-dept')?.addEventListener('change', (e) => {
      state.department = e.target.value;
      render();
    });
    content.querySelector('#all-workload-proj')?.addEventListener('change', (e) => {
      state.project = e.target.value;
      render();
    });
    content.querySelector('#all-workload-status')?.addEventListener('change', (e) => {
      state.status = e.target.value;
      render();
    });
    content.querySelector('#all-workload-rag')?.addEventListener('change', (e) => {
      state.rag = e.target.value;
      render();
    });
    content.querySelector('#all-workload-due')?.addEventListener('change', (e) => {
      state.dueState = e.target.value;
      render();
    });
    content.querySelector('#all-workload-rel')?.addEventListener('change', (e) => {
      state.relationship = e.target.value;
      render();
    });

    content.querySelectorAll('input[name="showMode"]').forEach((radio) => {
      radio.addEventListener('change', (e) => {
        state.showMode = e.target.value;
        render();
      });
    });

    content.querySelector('#all-workload-empty-proj')?.addEventListener('change', (e) => {
      state.includeEmptyProjects = e.target.checked;
      render();
    });

    content.querySelector('#all-workload-reset')?.addEventListener('click', () => {
      state.search = '';
      state.department = '';
      state.project = '';
      state.status = '';
      state.rag = '';
      state.dueState = '';
      state.relationship = '';
      state.showMode = 'open';
      state.includeEmptyProjects = false;
      state.selectedPersonId = null;
      state.selectedProjectId = null;
      state.detailSelection = null;
      state.matrixSort = 'risk';
      render();
    });

    content.querySelector('#all-workload-clear-person')?.addEventListener('click', () => {
      state.selectedPersonId = null;
      if (state.detailSelection?.personId) state.detailSelection = null;
      render();
    });
    content.querySelector('#all-workload-clear-proj')?.addEventListener('click', () => {
      state.selectedProjectId = null;
      if (state.detailSelection?.projectId) state.detailSelection = null;
      render();
    });

    content.querySelectorAll('[data-person-bar]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const pId = btn.dataset.personBar;
        state.selectedPersonId = state.selectedPersonId === pId ? null : pId;
        render();
      });
    });

    content.querySelectorAll('[data-project-bar]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const projId = btn.dataset.projectBar;
        state.selectedProjectId = state.selectedProjectId === projId ? null : projId;
        render();
      });
    });

    content.querySelector('#matrix-sort-select')?.addEventListener('change', (e) => {
      state.matrixSort = e.target.value;
      render();
    });
    content.querySelectorAll('[data-matrix-sort]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const col = btn.dataset.matrixSort;
        if (state.matrixSort === col) {
          state.matrixSortDir = state.matrixSortDir === 'asc' ? 'desc' : 'asc';
        } else {
          state.matrixSort = col;
          state.matrixSortDir = col === 'name' ? 'asc' : 'desc';
        }
        render();
      });
    });

    content.querySelectorAll('[data-matrix-cell]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const [personId, projectId] = btn.dataset.matrixCell.split(':');
        state.detailSelection = { personId, projectId };
        render();
        document.getElementById('all-workload-drilldown')?.scrollIntoView({ behavior: 'smooth' });
      });
    });

    content.querySelectorAll('[data-matrix-view-person]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const personId = btn.dataset.matrixViewPerson;
        state.detailSelection = { personId, projectId: null };
        render();
        document.getElementById('all-workload-drilldown')?.scrollIntoView({ behavior: 'smooth' });
      });
    });

    content.querySelector('#drilldown-group-by')?.addEventListener('change', (e) => {
      state.detailGroupBy = e.target.value;
      render();
    });

    content.querySelector('#drilldown-clear-selection')?.addEventListener('click', () => {
      state.detailSelection = null;
      render();
    });
  }

  render();
}

async function projectControlPortal() {
  const sessions = {
    portfolio,
    workload: workloadView,
    'all-workload': allProjectsWorkloadView
  };
  if (!sessions[controlPortalSession]) controlPortalSession = 'portfolio';
  await sessions[controlPortalSession]();
  const labels = {
    portfolio: 'Portfolio / Projects',
    workload: 'Project Workload',
    'all-workload': 'All Projects Workload'
  };
  const descriptions = {
    portfolio: 'Compare project progress, health, and delivery status across the portfolio.',
    workload: 'Review open work, capacity, status, and delivery pressure for the selected project.',
    'all-workload': 'Analyze aggregated team capacity, cross-project workload distribution, and delivery risk across all active projects.'
  };
  content.insertAdjacentHTML('afterbegin', `<section class="portal-nav control-portal-nav"><div><span class="section-kicker">PROJECT PORTAL</span><strong>${labels[controlPortalSession]}</strong><small>${descriptions[controlPortalSession]}</small></div><div class="portal-tabs" aria-label="Project Portal views">${Object.entries(labels).map(([key, label]) => `<button class="${controlPortalSession === key ? 'active' : ''}" data-control-portal-session="${key}">${label}</button>`).join('')}</div></section>`);
}

const pages = { dashboard: overview, 'project-control': projectControlPortal, tasks: workBreakdown, updates: weeklyUpdatesEditable, actions: pmActions, raid: raidEditable, portal: projectPortal, 'weekly-portal': weeklyPortal, audit };
const pageTitles = { dashboard: 'Master control', 'project-control': 'Project portal', tasks: 'Work items', updates: 'Weekly workspace', actions: 'Delivery attention', raid: 'RAID register', portal: 'Project portal setup', 'weekly-portal': 'Weekly Portal', audit: 'Activity log' };

async function navigate(page) {
  if (page === 'portfolio') { controlPortalSession = 'portfolio'; page = 'project-control'; }
  if (page === 'workload') { controlPortalSession = 'workload'; page = 'project-control'; }
  if (page === 'all-workload' || page === 'all-projects-workload') { controlPortalSession = 'all-workload'; page = 'project-control'; }
  if (page === 'projects') { portalSession = 'setup'; page = 'portal'; }
  if (page === 'structure') { portalSession = 'builder'; page = 'portal'; }
  if (page === 'admin') { portalSession = 'team'; page = 'portal'; }
  if (page === 'updates') { weeklyPortalSession = 'weekly'; page = 'weekly-portal'; }
  if (page === 'actions') { weeklyPortalSession = 'attention'; page = 'weekly-portal'; }
  if (page === 'raid') { weeklyPortalSession = 'raid'; page = 'weekly-portal'; }
  localStorage.setItem('lean_control_portal_session', controlPortalSession);
  localStorage.setItem('lean_portal_session', portalSession);
  localStorage.setItem('lean_weekly_portal_session', weeklyPortalSession);
  document.querySelectorAll('.nav').forEach((nav) => nav.classList.toggle('active', nav.dataset.page === page));
  title.textContent = pageTitles[page];
  quickAction.style.display = ['dashboard', 'updates', 'project-control', 'portal', 'weekly-portal'].includes(page) ? 'none' : '';
  try {
    await pages[page]();
  } catch (error) {
    showToast(error.message);
    content.innerHTML = `<section class="panel"><h2>Unable to load page</h2><p class="subtle">${error.message}</p></section>`;
  }
}

function applyWorkloadTaskFilters(personId) {
  const detailRow = document.getElementById(`workload-detail-${personId}`);
  if (!detailRow) return;
  const status = detailRow.querySelector(`[data-workload-status-filter="${personId}"]`)?.value || '';
  const rag = detailRow.querySelector(`[data-workload-rag-filter="${personId}"]`)?.value || '';
  const rows = [...detailRow.querySelectorAll(`[data-workload-task-row="${personId}"]`)];
  const groupBy = detailRow.querySelector(`[data-workload-group-by="${personId}"]`)?.value || '';
  const tbody = detailRow.querySelector('tbody');

  // Rebuild the table order from the original task order whenever grouping changes.
  // This keeps Status and RAG filters independent from the presentation grouping.
  tbody?.querySelectorAll('[data-workload-group-header]').forEach((header) => header.remove());
  const originalOrder = (left, right) => Number(left.dataset.taskOriginalIndex) - Number(right.dataset.taskOriginalIndex);
  if (tbody && groupBy === 'activity') {
    const groups = new Map();
    rows.forEach((row) => {
      const code = row.dataset.taskWbsCode || '—';
      const name = row.dataset.taskWbsName || 'No activity';
      const key = `${code}\u0000${name}`;
      if (!groups.has(key)) groups.set(key, { code, name, rows: [] });
      groups.get(key).rows.push(row);
    });
    [...groups.values()]
      .sort((left, right) => left.code.localeCompare(right.code, undefined, { numeric: true }))
      .forEach((group) => {
        const header = document.createElement('tr');
        header.className = 'workload-group-header';
        header.dataset.workloadGroupHeader = personId;
        const cell = document.createElement('td');
        cell.colSpan = 10;
        const label = document.createElement('span');
        label.textContent = 'WBS / ACTIVITY';
        const title = document.createElement('strong');
        title.textContent = `${group.code} — ${group.name}`;
        cell.append(label, title);
        header.append(cell);
        tbody.append(header, ...group.rows.sort(originalOrder));
      });
  } else if (tbody) {
    rows.sort(originalOrder).forEach((row) => tbody.append(row));
  }

  let visibleCount = 0;
  rows.forEach((row) => {
    const visible = (!status || row.dataset.taskStatus === status) && (!rag || row.dataset.taskRag === rag);
    row.hidden = !visible;
    if (visible) visibleCount += 1;
  });
  detailRow.querySelectorAll(`[data-workload-group-header="${personId}"]`).forEach((header) => {
    let sibling = header.nextElementSibling;
    let hasVisibleTask = false;
    while (sibling && !sibling.dataset.workloadGroupHeader) {
      if (!sibling.hidden) hasVisibleTask = true;
      sibling = sibling.nextElementSibling;
    }
    header.hidden = !hasVisibleTask;
  });
  const count = detailRow.querySelector(`[data-workload-filter-count="${personId}"]`);
  if (count) count.textContent = `${visibleCount} of ${rows.length} shown`;
  const empty = detailRow.querySelector(`[data-workload-filter-empty="${personId}"]`);
  if (empty) empty.hidden = visibleCount !== 0;
}

modal.addEventListener('click', (event) => { if (event.target.closest('[data-close-modal], .secondary[value="cancel"]')) { event.preventDefault(); modal.close(); } });
document.addEventListener('change', (event) => {
  const workloadFilter = event.target.closest('[data-workload-status-filter], [data-workload-rag-filter], [data-workload-group-by]');
  if (workloadFilter) {
    applyWorkloadTaskFilters(workloadFilter.dataset.workloadStatusFilter || workloadFilter.dataset.workloadRagFilter || workloadFilter.dataset.workloadGroupBy);
    return;
  }
  const weekSelector = event.target.closest('[data-control-week]');
  if (weekSelector) {
    controlWeek = weekSelector.value || mondayOf();
    localStorage.setItem('lean_control_week', controlWeek);
    navigate(document.querySelector('.nav.active')?.dataset.page || 'dashboard');
    return;
  }
  const projectSelector = event.target.closest('[data-project-context]');
  if (projectSelector) {
    activeProjectId = projectSelector.value;
    localStorage.setItem('lean_active_project_id', activeProjectId);
    tasks = [];
    showToast('Project context changed.');
    const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
    navigate(activePage);
    return;
  }
  const groupSelector = event.target.closest('[data-task-group-by]');
  if (groupSelector) {
    currentTaskGrouping = groupSelector.value;
    localStorage.setItem('lean_task_grouping', currentTaskGrouping);
    workBreakdown();
  }
});
document.addEventListener('click', (event) => {
  const historyButton = event.target.closest('[data-open-task-history]');
  if (historyButton) {
    const task = tasks.find((item) => item.task_id === historyButton.dataset.openTaskHistory);
    if (task) taskHistoryModal(task);
    return;
  }
  if (event.target.closest('[data-create-phase-from-unassigned]')) unassignedPhaseModal();
});

document.addEventListener('click', (event) => {
  const resetButton = event.target.closest('[data-workload-filter-reset]');
  if (resetButton) {
    const personId = resetButton.dataset.workloadFilterReset;
    const detailRow = document.getElementById(`workload-detail-${personId}`);
    detailRow?.querySelectorAll('[data-workload-status-filter], [data-workload-rag-filter], [data-workload-group-by]').forEach((select) => { select.value = ''; });
    applyWorkloadTaskFilters(personId);
    return;
  }
  const button = event.target.closest('[data-workload-expand]');
  if (!button) return;
  const detailRow = document.getElementById(button.getAttribute('aria-controls'));
  if (!detailRow) return;
  const willOpen = detailRow.hidden;
  detailRow.hidden = !willOpen;
  button.setAttribute('aria-expanded', String(willOpen));
  button.textContent = willOpen ? 'Hide' : 'Detail';
});

document.addEventListener('click', (event) => {
  const noteButton = event.target.closest('[data-open-task-notes]');
  if (noteButton) {
    const task = tasks.find((item) => item.task_id === noteButton.dataset.openTaskNotes);
    if (task) taskNotesModal(task);
    return;
  }
  const downloadButton = event.target.closest('[data-download-task-note-file]');
  if (downloadButton) downloadTaskNoteFile(downloadButton.dataset.downloadTaskNoteFile);
  const editNoteButton = event.target.closest('[data-edit-task-note]');
  if (editNoteButton) {
    if (activeTaskForNotes) taskNotesModal(activeTaskForNotes, editNoteButton.dataset.editTaskNote);
  }
});

document.addEventListener('click', async (event) => {
  const target = event.target.closest('[data-go], .nav, [data-control-portal-session], [data-portal-session], [data-weekly-portal-session], [data-select-project], [data-open-project], [data-edit-project], [data-open-template-import], [data-open-activity], [data-open-task], [data-update-task], [data-open-task-update], [data-open-task-note-create], [data-edit-weekly-update], [data-add-task-child], [data-add-subtask-child], [data-add-task-to-wbs], [data-add-activity-to-phase], [data-open-update], [data-open-weekly-plan], [data-open-role-update], [data-open-raid], [data-open-person], [data-open-existing-person], [data-open-assignment], [data-edit-task], [data-edit-activity], [data-edit-update], [data-edit-plan], [data-edit-role], [data-edit-raid], [data-edit-person], [data-edit-assignment], [data-delete-task], [data-delete-activity], [data-delete-update], [data-delete-plan], [data-delete-role], [data-delete-raid], [data-delete-person], [data-delete-assignment], [data-group-toggle], [data-parent-toggle]');
  if (!target) return;
  if (target.dataset.parentToggle) {
    const parentId = target.dataset.parentToggle;
    if (collapsedParentTasks.has(parentId)) collapsedParentTasks.delete(parentId);
    else collapsedParentTasks.add(parentId);
    workBreakdown();
    return;
  }
  if (target.dataset.groupToggle) {
    if (event.target.closest('button:not(.group-toggle-btn), select, input, a, .row-actions')) return;
    const key = target.dataset.groupToggle;
    if (collapsedTaskGroups.has(key)) collapsedTaskGroups.delete(key);
    else collapsedTaskGroups.add(key);
    workBreakdown();
    return;
  }
  const selectedProject = target.dataset.selectProject;
  if (selectedProject) { activeProjectId = selectedProject; localStorage.setItem('lean_active_project_id', activeProjectId); tasks = []; }
  if (target.dataset.controlPortalSession) { controlPortalSession = target.dataset.controlPortalSession; localStorage.setItem('lean_control_portal_session', controlPortalSession); navigate('project-control'); return; }
  if (target.dataset.portalSession) { portalSession = target.dataset.portalSession; localStorage.setItem('lean_portal_session', portalSession); navigate('portal'); return; }
  if (target.dataset.weeklyPortalSession) { weeklyPortalSession = target.dataset.weeklyPortalSession; localStorage.setItem('lean_weekly_portal_session', weeklyPortalSession); navigate('weekly-portal'); return; }
  if (target.dataset.go || target.classList.contains('nav')) { navigate(target.dataset.go || target.dataset.page); return; }
  if (target.matches('[data-open-project]')) return projectModal();
  if (target.matches('[data-open-template-import]')) return templateImportModal();
  if (target.dataset.editProject) {
    const all = await api('/projects');
    const proj = all.find((p) => p.project_id === target.dataset.editProject) || (await api('/project'));
    return projectModal(proj);
  }
  if (target.dataset.addTaskChild) return openTaskModal({ parentTaskId: target.dataset.addTaskChild, taskType: 'Task' });
  if (target.dataset.addSubtaskChild) return openTaskModal({ parentTaskId: target.dataset.addSubtaskChild, taskType: 'Subtask' });
  if (target.dataset.addTaskToWbs) return openTaskModal({ wbsItemId: target.dataset.addTaskToWbs, taskType: 'MainTask' });
  if (target.dataset.addActivityToPhase) return activityModal(null, target.dataset.addActivityToPhase);
  if (target.dataset.updateTask) return taskProgressModal(tasks.find((task) => task.task_id === target.dataset.updateTask));
  if (target.dataset.openTaskUpdate) return taskProgressModal(tasks.find((task) => task.task_id === target.dataset.openTaskUpdate));
  if (target.dataset.openTaskNoteCreate) return taskNotesModal(tasks.find((task) => task.task_id === target.dataset.openTaskNoteCreate));
  if (target.matches('[data-open-activity]')) return activityModal();
  if (target.matches('[data-open-task]')) return openTaskModal();
  if (target.matches('[data-open-update]')) return weeklyModal();
  if (target.matches('[data-open-weekly-plan]')) return weeklyPlanModal();
  if (target.matches('[data-open-role-update]')) return roleUpdateModal();
  if (target.matches('[data-open-raid]')) return raidModal();
  if (target.matches('[data-open-person]')) return personModal();
  if (target.matches('[data-open-existing-person]')) return existingPeopleModal();
  if (target.matches('[data-open-assignment]')) return assignmentModal();
  const edit = ['task', 'activity', 'update', 'weeklyUpdate', 'plan', 'role', 'raid', 'person', 'assignment'].find((type) => target.dataset[`edit${type[0].toUpperCase()}${type.slice(1)}`] !== undefined);
  if (edit) {
    const id = target.dataset[`edit${edit[0].toUpperCase()}${edit.slice(1)}`];
    if (edit === 'weeklyUpdate') return api('/weekly-updates').then((items) => weeklyModal(items.find((item) => item.weekly_update_id === id)));
    if (edit === 'activity') return api('/wbs').then((items) => activityModal(items.find((item) => item.wbs_item_id === id)));
    const collections = { task: tasks, update: weeklyItems, plan: weeklyPlans, role: roleUpdates, raid: raidItems, person: peopleItems, assignment: assignmentItems };
    const idKey = {
      task: 'task_id',
      update: 'weekly_update_id',
      plan: 'weekly_plan_id',
      role: 'role_update_id',
      raid: 'raid_item_id',
      person: 'person_id',
      assignment: 'task_assignment_id'
    }[edit];
    let targetItem = (collections[edit] || []).find((item) => item[idKey] === id);
    if (!targetItem && edit === 'task') {
      const freshTasks = await api('/tasks');
      tasks = freshTasks;
      targetItem = freshTasks.find((item) => item.task_id === id);
    }
    return ({ task: editTask, update: weeklyModal, plan: weeklyPlanModal, role: roleUpdateModal, raid: raidModal, person: personModal, assignment: assignmentModal })[edit](targetItem);
  }
  const type = ['task', 'activity', 'update', 'plan', 'role', 'raid', 'person', 'assignment'].find((item) => target.dataset[`delete${item[0].toUpperCase()}${item.slice(1)}`] !== undefined);
  if (type) deleteItem(type, target.dataset[`delete${type[0].toUpperCase()}${type.slice(1)}`]);
});

document.addEventListener('click', async (event) => {
  const target = event.target.closest('[data-open-phase], [data-seed-phases], [data-edit-phase], [data-delete-phase]');
  if (!target) return;
  if (target.matches('[data-open-phase]')) return phaseModal();
  if (target.matches('[data-seed-phases]')) {
    try { await api('/phases/standard', { method: 'POST', body: '{}' }); showToast('Standard implementation phases are ready.'); navigate('projects'); } catch (error) { showToast(error.message); }
    return;
  }
  const id = target.dataset.editPhase || target.dataset.deletePhase;
  const phase = (await api('/phases')).find((item) => item.phase_id === id);
  if (target.dataset.editPhase) return phaseModal(phase);
  if (!window.confirm(`Delete phase “${phase?.phase_name}”? Activities must be moved first.`)) return;
  try {
    const result = await api(`/phases/${id}`, { method: 'DELETE' });
    showToast(result?.message || 'Phase deleted.');
    const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
    navigate(activePage);
  } catch (error) { showToast(error.message); }
});

document.addEventListener('click', async (event) => {
  const target = event.target.closest('[data-open-workstream], [data-seed-workstreams], [data-edit-workstream], [data-delete-workstream]');
  if (!target) return;
  if (target.matches('[data-open-workstream]')) return workstreamModal();
  if (target.matches('[data-seed-workstreams]')) {
    try { await api('/workstreams/standard', { method: 'POST', body: '{}' }); showToast('Standard workstreams are ready.'); navigate('projects'); } catch (error) { showToast(error.message); }
    return;
  }
  const id = target.dataset.editWorkstream || target.dataset.deleteWorkstream;
  const workstream = (await api('/workstreams')).find((item) => item.workstream_id === id);
  if (target.dataset.editWorkstream) return workstreamModal(workstream);
  if (!window.confirm(`Delete workstream “${workstream?.workstream_name}”?`)) return;
  try { await api(`/workstreams/${id}`, { method: 'DELETE' }); showToast('Workstream deleted.'); navigate('projects'); } catch (error) { showToast(error.message); }
});

document.addEventListener('click', async (event) => {
  const target = event.target.closest('[data-open-role-master], [data-seed-roles], [data-edit-role-master], [data-delete-role-master]');
  if (!target) return;
  const activePage = document.querySelector('.nav.active')?.dataset.page || 'projects';
  if (target.matches('[data-open-role-master]')) return roleMasterModal();
  if (target.matches('[data-seed-roles]')) {
    try { await api('/roles/standard', { method: 'POST', body: '{}' }); showToast('Standard team roles are ready.'); navigate(activePage); } catch (error) { showToast(error.message); }
    return;
  }
  const id = target.dataset.editRoleMaster || target.dataset.deleteRoleMaster;
  const role = (await api('/roles')).find((item) => item.role_id === id);
  if (target.dataset.editRoleMaster) return roleMasterModal(role);
  if (!window.confirm(`Delete role “${role?.role_name}”? Team members assigned to this role must be reassigned first.`)) return;
  try { await api(`/roles/${id}`, { method: 'DELETE' }); showToast('Team role deleted.'); navigate(activePage); } catch (error) { showToast(error.message); }
});

async function projectTypeModal(projectType) {
  const isEdit = Boolean(projectType);
  modalContent.innerHTML = `<h2 class="form-title">${isEdit ? 'Edit project type' : 'Add project type'}</h2>
    <div class="form-grid">
      <label class="full">Type name<input name="typeName" required value="${projectType?.type_name || ''}" placeholder="e.g. Maintenance, Enhancement"></label>
      <label>Sort order<input name="sortOrder" type="number" min="1" value="${projectType?.sort_order || ''}"></label>
    </div>
    <div class="actions">
      <button class="secondary" value="cancel">Cancel</button>
      <button class="primary">${isEdit ? 'Save changes' : 'Add type'}</button>
    </div>`;
  form.onsubmit = async (event) => {
    event.preventDefault();
    const values = Object.fromEntries(new FormData(form));
    try {
      if (isEdit) {
        await api(`/project-types/${projectType.type_id}`, { method: 'PATCH', body: JSON.stringify(values) });
        showToast('Project type updated.');
      } else {
        await api('/project-types', { method: 'POST', body: JSON.stringify(values) });
        showToast('Project type added.');
      }
      modal.close();
      navigate('projects');
    } catch (error) { showToast(error.message); }
  };
  modal.showModal();
}

document.addEventListener('click', async (event) => {
  const target = event.target.closest('[data-open-project-type], [data-edit-project-type], [data-delete-project-type]');
  if (!target) return;
  if (target.matches('[data-open-project-type]')) return projectTypeModal();
  const id = target.dataset.editProjectType || target.dataset.deleteProjectType;
  const typeList = await api('/project-types');
  const pt = typeList.find((item) => item.type_id === id);
  if (target.dataset.editProjectType) return projectTypeModal(pt);
  if (!window.confirm(`Delete project type "${pt?.type_name}"?`)) return;
  try { await api(`/project-types/${id}`, { method: 'DELETE' }); showToast('Project type deleted.'); navigate('projects'); } catch (error) { showToast(error.message); }
});


document.addEventListener('click', (event) => {
  const toggle = event.target.closest('[data-tree-toggle]');
  if (!toggle) return;
  const key = toggle.dataset.treeToggle;
  if (collapsedTreeNodes.has(key)) collapsedTreeNodes.delete(key);
  else collapsedTreeNodes.add(key);
  navigate('structure');
});

quickAction.addEventListener('click', () => weeklyModal());
async function initialize() {
  try {
    const session = await api('/session');
    document.querySelector('.demo-user strong').textContent = session.displayName;
    document.querySelector('.demo-user small').textContent = `${session.roles.join(', ') || 'No role'} · local demo identity`;
    await navigate('dashboard');
  } catch (error) {
    content.innerHTML = `<section class="panel"><h2>Unable to start local session</h2><p class="subtle">${error.message}</p></section>`;
  }
}

initialize();
