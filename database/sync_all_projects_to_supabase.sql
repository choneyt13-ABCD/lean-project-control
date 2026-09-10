-- =============================================================================
-- Lean Project Control: Supplemental Projects (e-Doc, CSI, Loca)
-- =============================================================================

-- 1. People
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', '005430', 'Anusara', 'Anusara.Sun@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'Business Analyst', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', '009986', 'Apiwat', 'apiwat.sut@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'Business Analyst', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('9b16c1a5-b13d-4457-9b03-473f66d65809', '009183', 'Chanyawan', 'Chanyawan.sit@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', '', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '013955', 'Chonthawat ', 'chonthawat.tan@mahidol.ac.th', 'ฝ่ายสารสนเทศ', 'Project manager', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('e755fbfb-cf55-4ab9-b17f-382dadf72913', '006204', 'Kanokwan', 'kanokwan.sua@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'Business Analyst', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('054c6fc2-baf5-479a-a7f8-56676abc5bf5', '001999', 'Phailin', 'phailin.som@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', '', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', '005423', 'Sakonan', 'Sakonan.hun@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'หัวหน้างานสารสนเทศเพื่อการบริหาร', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;

-- 2. Projects
INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
VALUES ('6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'EDOC-2026', 'ระบบสารบรรณอิเล็กทรอนิกส์ ระยะที่ 2', 'Digital Transformation', 'New', 'Large', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Active', 'Green', '2025-09-08', '2026-10-31')
ON CONFLICT (project_id) DO UPDATE SET
  project_code = EXCLUDED.project_code,
  project_name = EXCLUDED.project_name,
  portfolio_name = EXCLUDED.portfolio_name,
  project_type = EXCLUDED.project_type,
  project_size = EXCLUDED.project_size,
  main_pm_person_id = EXCLUDED.main_pm_person_id,
  project_status = EXCLUDED.project_status,
  rag_status = EXCLUDED.rag_status,
  start_date = EXCLUDED.start_date,
  target_end_date = EXCLUDED.target_end_date;
INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
VALUES ('07c794f6-c60a-4547-9412-5c5fca8b9214', 'Loca-2026', 'ระบบจัดการข้อมูลสถานที่', 'Physical Location', 'New', 'Medium', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Active', 'Green', '2025-11-01', '2026-12-31')
ON CONFLICT (project_id) DO UPDATE SET
  project_code = EXCLUDED.project_code,
  project_name = EXCLUDED.project_name,
  portfolio_name = EXCLUDED.portfolio_name,
  project_type = EXCLUDED.project_type,
  project_size = EXCLUDED.project_size,
  main_pm_person_id = EXCLUDED.main_pm_person_id,
  project_status = EXCLUDED.project_status,
  rag_status = EXCLUDED.rag_status,
  start_date = EXCLUDED.start_date,
  target_end_date = EXCLUDED.target_end_date;
INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
VALUES ('ca8b768a-7194-4b7c-bf7c-67fead04c378', 'CSI-2026', 'ระบบการบริหารจัดการงานบริการ', 'Service Management ', 'Feasibilities', 'Large', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Active', 'Green', '2026-07-01', '2026-09-30')
ON CONFLICT (project_id) DO UPDATE SET
  project_code = EXCLUDED.project_code,
  project_name = EXCLUDED.project_name,
  portfolio_name = EXCLUDED.portfolio_name,
  project_type = EXCLUDED.project_type,
  project_size = EXCLUDED.project_size,
  main_pm_person_id = EXCLUDED.main_pm_person_id,
  project_status = EXCLUDED.project_status,
  rag_status = EXCLUDED.rag_status,
  start_date = EXCLUDED.start_date,
  target_end_date = EXCLUDED.target_end_date;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-4fb0-460d-af51-3f4e891d0cbf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-c60a-4547-9412-5c5fca8b9214', '07c794f6-c60a-4547-9412-5c5fca8b9214', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-7194-4b7c-bf7c-67fead04c378', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT DO NOTHING;

-- 3. Project Members
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('a1d920b7-e71c-4b32-9c27-540358d21e69', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '20000000-0000-0000-0000-000000000001', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('4ae4a564-5533-441e-8e8f-1086a4b214eb', '07c794f6-c60a-4547-9412-5c5fca8b9214', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', true, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('aa6fb637-389b-4e80-8872-d1d126ac8228', '07c794f6-c60a-4547-9412-5c5fca8b9214', '20000000-0000-0000-0000-000000000001', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('483c84f2-c300-4b20-9033-3821e38ab1c1', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', true, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('28b70ee0-a150-4a85-aad2-974b9a5c754a', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', true, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('e7b4c08a-92bf-4d86-9362-1048b2aa6f20', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', '20000000-0000-0000-0000-000000000001', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;

-- 4. Project Phases
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('fabfd84a-51b7-4e8f-8d1f-a15553a80f94', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'e-Doc Phase2', 'สารบรรณอิเล็กทรอนิกส์ ระยะที่ 2', 8, '2026-01-01', '2027-04-30')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('e299d54d-79c1-415c-bd69-4ef700f8a028', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'Phase  CSI01', 'Feasibility', 1, '2026-07-01', '2026-10-31')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;

-- 5. WBS Items
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('1c4321b2-49b1-48be-be24-7e13bb6473c4', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-01', 'ระบบสารบรรณอิเล็กทรอนิกส์(Requirement)', 1)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('bf410ad9-40f4-46f2-905c-09de75fd34fe', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-02', 'Project Team', 2)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('1e5e1de5-46ed-40e0-9c83-1f8a312f44e5', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', NULL, 'EDOC-03', 'Go-live', 3)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('2e3ded9d-d5ea-4857-99a1-b9b75019aa94', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-04', 'เอกสารคุณภาพ (Requirement)', 4)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('a62c04de-3a6a-44bf-a3b2-36114f9c19e0', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-05', 'กระบวนการงานพัสดุ(Requirement)', 5)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('0dc5e401-3abf-4f6d-a981-66a763abd5b4', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', NULL, 'EDOC-06', 'Backend', 6)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('fab4d18d-3954-4061-90a5-6e7d6b5a36b2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-07', 'อนุมัติหลักการ', 7)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('55aff57e-f36a-44b0-b3d6-0a47ef9519ff', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', NULL, 'EDOC-08', 'Digital Signature', 8)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('472a5fbd-481c-4747-adf0-744be6892895', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fabfd84a-51b7-4e8f-8d1f-a15553a80f94', 'EDOC-09', 'Imported backlog (parent reference unavailable)', 9)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'e299d54d-79c1-415c-bd69-4ef700f8a028', 'CSI-001', 'Phase preparation', 1)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;

-- 6. Tasks
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('96f5cf85-376c-444e-a759-8448fc507863', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-006', 'MainTask', 'Reports', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('df997935-6b13-4253-8bd4-ba6f7ea65bba', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-007', 'MainTask', 'Change Requests', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-009', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('9f929c0e-310b-45b2-bbe1-49ea0ad995f8', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-012', 'MainTask', 'Team Member', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('29669b5a-3374-449d-ad55-d3462dae9fa9', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-013', 'MainTask', 'คณะทำงาน', NULL, '20000000-0000-0000-0000-000000000001', '2025-12-16', '2025-12-16', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('e8f89389-cb9d-4357-934d-42704a412e37', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-015', 'MainTask', 'Digital Signature', NULL, '20000000-0000-0000-0000-000000000001', '2026-05-03', '2026-06-29', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('34690ad2-44fd-4049-b71f-e18ef6c39b61', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-019', 'MainTask', 'APIs', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('3a37d06b-edfd-422f-917a-4a7dd6ac436b', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-020', 'MainTask', 'ระบบจัดเก็บเอกสาร', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('258fa107-9965-4654-a519-12e88b6985ec', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-021', 'MainTask', 'Web Portal', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('0f13f76f-0693-40e1-a5da-b3447c196972', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-022', 'MainTask', 'การเชื่อมต่อข้อมูลกับ SAP', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('f19c4d74-95a6-40cc-a8cd-e0e1bbe87492', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-026', 'MainTask', 'Kickoff Project', NULL, '20000000-0000-0000-0000-000000000001', '2026-01-29', '2026-01-29', NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('9ded7d86-63f1-4c03-b58b-20aacc6f7462', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', NULL, 'EDOC-030', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1d702d6f-c69b-4f3a-86cc-8e855f0f9c02', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-034', 'MainTask', 'Mu-sis', NULL, '20000000-0000-0000-0000-000000000001', '2026-01-06', '2026-01-06', NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('fe2d5601-4bc0-45f1-80d8-5af28dc29a23', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-036', 'MainTask', 'Reports', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('c64c8721-08d1-49c4-a803-a4fb784b69fe', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-037', 'MainTask', 'ISO 9001:2015', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('35e8a389-5624-46c3-9ce3-3f6c55582319', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-038', 'MainTask', 'ISO อื่นๆ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('fb337921-de65-4b7f-a18b-e6c0d31bd9db', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-041', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('2e44ed6f-040d-44a8-b8c2-a313318710d2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-042', 'MainTask', 'SIT', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('3e3e04bf-67d0-406e-9054-d14605184f6a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-043', 'MainTask', 'UAT', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('89db308d-ac51-4d47-ada0-25ef1f9ac464', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-044', 'MainTask', 'Golive', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-30', '2026-08-30', NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1c50c07b-bf80-4157-9507-f40a4d3c215e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-045', 'MainTask', 'Business Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('9b78890c-9db7-4777-83bf-f6a3781a28c8', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-048', 'MainTask', 'SIT', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('8930374f-3985-4919-ad0d-ca37d86b0fcb', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-049', 'MainTask', 'UAT', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('336eba7d-cf3d-4a1b-8dbc-41688e1e445d', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-050', 'MainTask', 'Go-live', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-31', '2026-09-29', NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('b091875c-cc19-4448-8987-22830f884933', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-051', 'MainTask', 'Development', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('2eefb7b7-5cb6-4e14-b492-ef571fb7e930', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-052', 'MainTask', 'Trainging', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-16', '2026-08-20', NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('8a583e20-0540-472d-9c46-747bb0f5b7f7', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-053', 'MainTask', 'Development (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('f618fae0-e089-481f-807b-c9f6d03ffa38', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-054', 'MainTask', 'SIT (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('17f7dfbd-0a91-4940-a566-2b3f75e9114f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-055', 'MainTask', 'UAT (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('82175c67-96ab-4b23-a966-de6b488f2673', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-056', 'MainTask', 'Trainging (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('b5ac7868-998d-4f5b-8390-90207b82bb62', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-057', 'MainTask', 'Go-live (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('24511c2c-0c51-4da1-bb33-674e441a334e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-059', 'MainTask', 'สารบรรณ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a9c9b521-c8c4-4ee2-b2d7-d79956753525', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-060', 'MainTask', 'พัสดุ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('65b5815d-94ea-4267-b733-fa77d84543ba', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-061', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a9bae895-091c-497e-9e00-a85a563bc323', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-062', 'MainTask', 'Development', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('8f4b124b-eebd-4439-a078-7ee7c9c8d8a7', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-063', 'MainTask', 'Test', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('d41fbeec-472a-4be2-a5c4-456645f58e72', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-064', 'MainTask', 'Go-live', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('815c0891-5506-42c6-870f-bb40c668bb4f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-065', 'MainTask', 'Requirement (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('3c993e37-aa63-4153-8105-e2ab2bcf436a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-066', 'MainTask', 'Development (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1c293771-498d-4791-ad2b-de2f9543388e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-067', 'MainTask', 'Test (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('506babe8-664f-46f1-aade-461d52576c01', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-068', 'MainTask', 'Go-live (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('4cd41491-00ed-4f26-bfce-d5db503f4f1c', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-004', 'Task', 'Change request', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1568bc81-f71f-40b7-80b1-e5df2c7dcc6e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-010', 'Task', 'Bug Fixing', NULL, '20000000-0000-0000-0000-000000000001', '2025-09-07', '2025-09-07', NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('7610f115-66bf-4dd9-a1df-708708e2e047', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-014', 'Task', 'Report', NULL, '20000000-0000-0000-0000-000000000001', NULL, '2026-08-31', NULL, NULL, 'InProgress', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('f813c2eb-ac7f-4b25-a4a5-9fef01d7eae3', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-016', 'Task', 'PDF editor', NULL, '20000000-0000-0000-0000-000000000001', NULL, '2026-05-01', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('196ebf9b-d00d-4a1a-8d51-15a12890da75', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-017', 'Task', 'กระบวนการส่งหนังสือ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('0a5107a7-0dc4-4a24-bf62-624638bac90c', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-018', 'Task', 'กระบวนการรับหนังสือ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Amber', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('7958b609-243c-4f61-bdff-2e1c75afdba2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'e8f89389-cb9d-4357-934d-42704a412e37', 'EDOC-023', 'Task', 'Preparation', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1e5b694a-bf42-4b6c-afd5-b943cf9db3ee', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'e8f89389-cb9d-4357-934d-42704a412e37', 'EDOC-024', 'Task', 'Implement', NULL, '20000000-0000-0000-0000-000000000001', '2026-04-30', '2026-06-29', NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('68ac22d8-ce11-47c0-969e-9c0b69b104a1', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-025', 'Task', 'UI', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('714b5ec7-90d2-41de-b324-4403068ea8b6', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '34690ad2-44fd-4049-b71f-e18ef6c39b61', 'EDOC-027', 'Task', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a5eb9ec1-30e0-485e-8b7b-b8c4752aad91', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '34690ad2-44fd-4049-b71f-e18ef6c39b61', 'EDOC-028', 'Task', 'Test', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('4a817790-89ab-4ecf-9eca-0fbbb29bb220', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', 'EDOC-031', 'Task', 'Prototype', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('3f6d866b-fa4f-4fc2-962e-c79a9d8b71dc', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', 'EDOC-032', 'Task', 'System Design', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('323509d4-d793-493b-995b-a08acd3bd8bf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-033', 'Task', 'Implement  เลขหนังสือใหม่ (หน่วยงานใหม่)', NULL, '20000000-0000-0000-0000-000000000001', '2026-01-04', '2026-03-30', NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a99c5772-c479-411a-9394-386ae808b276', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', 'EDOC-035', 'Task', 'Stakeholder หลัก', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('8a9a232e-5d0f-4bf0-a873-b2b0660ea10b', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', '35e8a389-5624-46c3-9ce3-3f6c55582319', 'EDOC-039', 'Task', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a2373c35-92fe-4494-9b79-bec59a38c06a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', 'EDOC-040', 'Task', 'Stakeholder 13 หน่วยงาน', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('1647e64d-b7fe-46c0-b4b2-eccb84e9f95f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '1c50c07b-bf80-4157-9507-f40a4d3c215e', 'EDOC-046', 'Task', 'BRD review', NULL, '20000000-0000-0000-0000-000000000001', '2026-06-30', '2026-06-30', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('a0d41adf-4440-42ce-8648-5864080a842f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '1c50c07b-bf80-4157-9507-f40a4d3c215e', 'EDOC-047', 'Task', 'BRD Approve', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-02', '2026-08-02', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('d0cd2591-b24a-4c10-b2e4-f429dd39b2bd', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', NULL, 'CSI-2026-MT-001', 'MainTask', 'R&D Study', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-01', '2026-07-12', NULL, NULL, 'InProgress', 'Red', 100, 88, false, NULL)
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('03eb40fa-1c9a-44f4-842f-1ad58fc00386', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', 'd0cd2591-b24a-4c10-b2e4-f429dd39b2bd', 'CSI-2026-T-001', 'Task', 'R&D Study', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-01', '2026-07-12', NULL, NULL, 'Done', 'Green', 100, 100, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('2083120d-ff9e-46ca-b209-1641972e4bec', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', 'd0cd2591-b24a-4c10-b2e4-f429dd39b2bd', 'CSI-2026-T-002', 'Task', 'เตรียมข้อมูลเสนอผู้บริหาร', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-01', '2026-10-31', NULL, NULL, 'InProgress', 'Red', 80, 72, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('59dc165e-8a28-4d0b-8322-95a7521dd698', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', '2083120d-ff9e-46ca-b209-1641972e4bec', 'CSI-2026-ST-001', 'Subtask', 'Overall', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-01', '2026-08-14', NULL, NULL, 'Done', 'Green', 100, 100, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('c4d7664a-419e-447d-8909-63b690122eff', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', '2083120d-ff9e-46ca-b209-1641972e4bec', 'CSI-2026-ST-002', 'Subtask', 'Change management', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-01', '2026-09-30', NULL, NULL, 'InProgress', 'Red', 50, 50, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('776997f1-488f-4fff-9554-deb64d107ef4', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', '2083120d-ff9e-46ca-b209-1641972e4bec', 'CSI-2026-ST-003', 'Subtask', 'Multisite architechture', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-14', '2026-09-30', NULL, NULL, 'Done', 'Red', 100, 100, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('6b2d5035-665e-4bfe-aaff-b8a89bfa4dcc', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', '2083120d-ff9e-46ca-b209-1641972e4bec', 'CSI-2026-ST-004', 'Subtask', 'Problem management', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-14', '2026-09-30', NULL, NULL, 'InProgress', 'Green', 100, 50, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('386ae5c0-d09f-451a-95a8-29ce369274a1', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', 'c81c47d3-e844-49f4-b2a4-a2dd4546a3f7', '2083120d-ff9e-46ca-b209-1641972e4bec', 'CSI-2026-ST-005', 'Subtask', 'Vendor management (ITSM)', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-14', '2026-09-30', NULL, NULL, 'InProgress', 'Green', 100, 50, false, 'Governance & PMO')
ON CONFLICT (task_id) DO UPDATE SET
  task_code = EXCLUDED.task_code,
  task_name = EXCLUDED.task_name,
  description = EXCLUDED.description,
  parent_task_id = EXCLUDED.parent_task_id,
  wbs_item_id = EXCLUDED.wbs_item_id,
  task_type = EXCLUDED.task_type,
  owner_person_id = EXCLUDED.owner_person_id,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date,
  actual_start_date = EXCLUDED.actual_start_date,
  actual_end_date = EXCLUDED.actual_end_date,
  status = EXCLUDED.status,
  rag_status = EXCLUDED.rag_status,
  weight = EXCLUDED.weight,
  progress = EXCLUDED.progress,
  evidence_required = EXCLUDED.evidence_required,
  workstream = EXCLUDED.workstream;

-- 7. Task Assignments
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('24d3cf2f-369e-4fd6-885d-309ce1bef4fc', '96f5cf85-376c-444e-a759-8448fc507863', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a5aaeb8b-3248-4cbb-969a-dec566485441', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('faba317f-44ef-4bef-9d07-18ea836f143e', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('3dd9532c-a306-4f20-83a4-39a94329f748', '9f929c0e-310b-45b2-bbe1-49ea0ad995f8', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('03ea9c21-15aa-4ea4-b756-976cf05a51fc', '29669b5a-3374-449d-ad55-d3462dae9fa9', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('bb2bc3dd-2d9c-4b49-95dd-97ac88682aac', 'e8f89389-cb9d-4357-934d-42704a412e37', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('fcc76578-4bc1-4953-b475-0db58f55323b', '34690ad2-44fd-4049-b71f-e18ef6c39b61', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d45dd3cc-aa1d-43ba-ab9d-76a79cba4d55', '3a37d06b-edfd-422f-917a-4a7dd6ac436b', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a9749db0-4967-4035-9302-9f25b5ce457f', '258fa107-9965-4654-a519-12e88b6985ec', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f78bfc11-3477-4574-a8c3-0f76f807d1b7', '0f13f76f-0693-40e1-a5da-b3447c196972', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('73acb3c7-cc83-4dd7-8c0a-f4ac23f9176f', 'f19c4d74-95a6-40cc-a8cd-e0e1bbe87492', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('21076457-e56b-4c36-8230-2ac9b0158dc5', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f37de77b-8c35-40a1-b7d1-4568d0e71736', '1d702d6f-c69b-4f3a-86cc-8e855f0f9c02', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('bb2a844b-1ecc-4e46-ac40-9d1c20d01b1a', 'fe2d5601-4bc0-45f1-80d8-5af28dc29a23', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('dd783359-de0a-4833-9a94-e0406eada479', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b7de24d9-caf0-47b4-a56c-bb0a8f041712', '35e8a389-5624-46c3-9ce3-3f6c55582319', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b23f8fe1-5530-49e7-a57e-86e2bb81cf8a', 'fb337921-de65-4b7f-a18b-e6c0d31bd9db', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c92dbd8d-68c1-49fb-bd34-2cce84d4a4c1', '2e44ed6f-040d-44a8-b8c2-a313318710d2', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('6bbac299-180b-489c-a988-ead6f380770c', '3e3e04bf-67d0-406e-9054-d14605184f6a', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e3eefee7-a080-4ed7-ae0c-94c40fa6c01f', '89db308d-ac51-4d47-ada0-25ef1f9ac464', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f4498f6a-1555-45eb-a6eb-37a0836b02c9', '1c50c07b-bf80-4157-9507-f40a4d3c215e', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a04059a0-d109-4587-83f0-22588dc9c3a1', '9b78890c-9db7-4777-83bf-f6a3781a28c8', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('3a96a906-d436-4727-8dea-057011307f32', '8930374f-3985-4919-ad0d-ca37d86b0fcb', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c1a3c7df-4d7f-4f42-afc2-b96354813b64', '336eba7d-cf3d-4a1b-8dbc-41688e1e445d', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ae400e63-c1dd-4743-912d-3d7ff161c920', 'b091875c-cc19-4448-8987-22830f884933', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('4cab4471-4de1-45a4-84e1-df38ad4ad854', '2eefb7b7-5cb6-4e14-b492-ef571fb7e930', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c9de9434-c3bc-41a7-a38b-28cca1142eb2', '8a583e20-0540-472d-9c46-747bb0f5b7f7', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('211798c9-05d2-4d1c-90d6-35cdda3caef9', 'f618fae0-e089-481f-807b-c9f6d03ffa38', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b6cafdd6-d973-441b-8423-102416a65fd5', '17f7dfbd-0a91-4940-a566-2b3f75e9114f', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('1daa33a9-8f26-4498-a116-ce4e35fd9ae2', '82175c67-96ab-4b23-a966-de6b488f2673', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('66208938-8567-4b8c-88d0-130ecb4b4fc9', 'b5ac7868-998d-4f5b-8390-90207b82bb62', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a7337178-959b-46a7-b4fd-6473cbc0bea3', '24511c2c-0c51-4da1-bb33-674e441a334e', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('7655ba5a-5c53-4b66-94b3-5e3b7760730b', 'a9c9b521-c8c4-4ee2-b2d7-d79956753525', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('af86f891-6b5e-48ec-97d0-32ebfbe4e8c0', '65b5815d-94ea-4267-b733-fa77d84543ba', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a0768103-5b6e-4a66-b630-7fb13c5084ae', 'a9bae895-091c-497e-9e00-a85a563bc323', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('eabb6743-5184-4da6-8ebc-67b9a5bd4c55', '8f4b124b-eebd-4439-a078-7ee7c9c8d8a7', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('128a6f95-0c78-4119-b09a-1873b588cd31', 'd41fbeec-472a-4be2-a5c4-456645f58e72', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d578eab0-e444-49b1-b792-3943888357c9', '815c0891-5506-42c6-870f-bb40c668bb4f', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e5c72f51-7ea5-4dcb-9410-426c557fde68', '3c993e37-aa63-4153-8105-e2ab2bcf436a', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('2ae7a13f-8338-4d54-9245-ec49ea2c9328', '1c293771-498d-4791-ad2b-de2f9543388e', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('50d28387-af87-461e-b328-472cffdaee16', '506babe8-664f-46f1-aade-461d52576c01', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('fe60c549-f45d-4d13-bf7e-43dbd33f9995', '4cd41491-00ed-4f26-bfce-d5db503f4f1c', '20000000-0000-0000-0000-000000000001', 'BA', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('7110634c-1cf9-405f-9351-104d034c30d8', '1568bc81-f71f-40b7-80b1-e5df2c7dcc6e', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('52d5ea7b-428e-4a0c-8c86-91499ba06b73', '7610f115-66bf-4dd9-a1df-708708e2e047', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('dc69ed46-80d2-427a-a3a3-7f4954162486', 'f813c2eb-ac7f-4b25-a4a5-9fef01d7eae3', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('1e07bef5-c514-4170-88c9-ea528dc13111', '196ebf9b-d00d-4a1a-8d51-15a12890da75', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('37902040-6e5e-469c-b443-f0b2d531f1d4', '0a5107a7-0dc4-4a24-bf62-624638bac90c', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('20651f3f-568b-4148-a54f-b4ebb1d4ac01', '7958b609-243c-4f61-bdff-2e1c75afdba2', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b7975abe-2b6e-40b9-a7d7-dbd9ac33ad9a', '1e5b694a-bf42-4b6c-afd5-b943cf9db3ee', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('68a46c93-7bc4-4ba0-bcb6-ea0089debc01', '68ac22d8-ce11-47c0-969e-9c0b69b104a1', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('07d24bd0-1258-4129-b609-e33671845820', '714b5ec7-90d2-41de-b324-4403068ea8b6', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a7dbd08a-2ae6-49c3-8b1d-5761304c091b', 'a5eb9ec1-30e0-485e-8b7b-b8c4752aad91', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f06a179a-188b-4f20-b0f7-a8ac7bdee195', '4a817790-89ab-4ecf-9eca-0fbbb29bb220', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('75f981c8-f984-49d8-992e-047d4cd71034', '3f6d866b-fa4f-4fc2-962e-c79a9d8b71dc', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('55646a82-e3b4-48fa-9a61-af739aa8bdec', '323509d4-d793-493b-995b-a08acd3bd8bf', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a07678cc-b92c-4432-bcc2-15b5d4f14668', 'a99c5772-c479-411a-9394-386ae808b276', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('97841061-0559-4981-ad53-95741c4bce33', '8a9a232e-5d0f-4bf0-a873-b2b0660ea10b', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ce4b58a7-dcb5-488d-b6b4-970e44f643d3', 'a2373c35-92fe-4494-9b79-bec59a38c06a', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('63b0c5f5-c954-4e39-97a4-b9a2a8de243d', '1647e64d-b7fe-46c0-b4b2-eccb84e9f95f', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b6c00669-1065-4c5c-b140-e2ffc63d376d', 'a0d41adf-4440-42ce-8648-5864080a842f', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('1fc0c520-72a7-4177-bf40-a44ed83ef06f', 'd0cd2591-b24a-4c10-b2e4-f429dd39b2bd', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('59bdc505-027f-4294-99ef-7f54fc7bcc53', '03eb40fa-1c9a-44f4-842f-1ad58fc00386', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b5898867-dda6-4de3-9fcc-2c420f36224b', '2083120d-ff9e-46ca-b209-1641972e4bec', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f1acc409-ea16-43a8-a557-57b70c9b0b78', '59dc165e-8a28-4d0b-8322-95a7521dd698', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f93e5952-8f5d-4d83-baea-71ba836c352f', 'c4d7664a-419e-447d-8909-63b690122eff', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('dbfb1b8a-6ee2-4fcd-9385-29ba63460132', '776997f1-488f-4fff-9554-deb64d107ef4', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ed178d66-54b4-48bb-bfa3-243e25c7e2a3', '6b2d5035-665e-4bfe-aaff-b8a89bfa4dcc', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ab9176cf-9987-4226-989f-b62ce5709a07', '386ae5c0-d09f-451a-95a8-29ce369274a1', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;