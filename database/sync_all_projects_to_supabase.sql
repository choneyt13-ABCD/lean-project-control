-- =============================================================================
-- Lean Project Control: Full Data Sync (e-Doc, CSI, Loca, RRMS-2026, DTP)
-- Safe to execute in both PostgreSQL (Supabase) and SQLite
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
VALUES ('72d468b8-f025-4209-a189-3b1ccb47b67d', 'Blue001', 'Bluesea Vendor', 'arunee@blueseas.co.th', 'Bluesea', 'Bluesea', 'Active')
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
VALUES ('20000000-0000-0000-0000-000000000002', '022651', 'Jirateep', 'Jirateep.kot@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'Business Analyst', 'Active')
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
VALUES ('20000000-0000-0000-0000-000000000001', 'DEMO-RRMS-PM', 'RRMS Demo PM', 'rrms.demo.pm@example.invalid', 'Demo Office', 'Project Manager', 'Active')
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
INSERT INTO people (person_id, employee_code, display_name, email, department, position_title, person_status)
VALUES ('318cc4ab-cea3-473e-bc4c-26e01a5609e0', '008487', 'Teeraporn', 'Teeraporn.kam@mahidol.ac.th', 'งานสารสนเทศเพื่อการบริหาร', 'Business Analyst', 'Active')
ON CONFLICT (person_id) DO UPDATE SET
  employee_code = EXCLUDED.employee_code,
  display_name = EXCLUDED.display_name,
  email = EXCLUDED.email,
  department = EXCLUDED.department,
  position_title = EXCLUDED.position_title;

-- 2. Projects
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
INSERT INTO projects (project_id, project_code, project_name, portfolio_name, project_type, project_size, main_pm_person_id, project_status, rag_status, start_date, target_end_date)
VALUES ('30000000-0000-0000-0000-000000000002', 'DTP', 'Digital Transformation Pilot', 'Lean Project Control Pilot', 'New', 'Medium', '20000000-0000-0000-0000-000000000001', 'Cancelled', 'Green', '2026-08-01', '2026-11-30')
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
VALUES ('30000000-0000-0000-0000-000000000001', 'RRMS-2026', 'ระบบบริหารจัดการวิจัยโรงพยาบาลรามาธิบดี', 'Rama Research', 'New', 'Large', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Active', 'Green', '2026-01-01', '2027-06-30')
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
VALUES ('99990000-7194-4b7c-bf7c-67fead04c378', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-7194-4b7c-bf7c-67fead04c378', 'ca8b768a-7194-4b7c-bf7c-67fead04c378', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-4fb0-460d-af51-3f4e891d0cbf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-4fb0-460d-af51-3f4e891d0cbf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-c60a-4547-9412-5c5fca8b9214', '07c794f6-c60a-4547-9412-5c5fca8b9214', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-c60a-4547-9412-5c5fca8b9214', '07c794f6-c60a-4547-9412-5c5fca8b9214', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99990000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm)
VALUES ('99980000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', false)
ON CONFLICT (project_member_id) DO NOTHING;

-- 3. Project Members
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('31000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('31000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000002', 'Stakeholder', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('31000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', 'PM', true, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('fa245b5d-e556-4eb0-b5ac-2e57656909dc', '30000000-0000-0000-0000-000000000001', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'PM', true, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('a1d920b7-e71c-4b32-9c27-540358d21e69', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '20000000-0000-0000-0000-000000000001', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('cf9426f5-090f-429c-9815-c1aec2680484', '30000000-0000-0000-0000-000000000001', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('b4080e7d-9bf8-49ad-84bd-31ab4f4fc4b8', '30000000-0000-0000-0000-000000000001', '054c6fc2-baf5-479a-a7f8-56676abc5bf5', 'PM', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('709d3c0d-66c0-4bff-89c5-7cc2a573cf49', '30000000-0000-0000-0000-000000000001', 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', 'PM', false, NULL, NULL)
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
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('44baa0e9-351c-4299-91e4-111a04840e36', '30000000-0000-0000-0000-000000000001', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('15eeb7f9-6211-4b63-b8ce-306a6d323ddc', '30000000-0000-0000-0000-000000000001', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('61c1af64-ab17-4b9f-b74d-e50794a1bdc9', '30000000-0000-0000-0000-000000000001', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('16f29e5c-82da-4c3b-b1e3-ef5728ddcedf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('1cdc197f-401a-4858-aa5b-42de62826ab7', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('6f1588c5-80b9-4063-aa29-83868861dad2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('60fc73d0-5184-4a00-ad46-6d1b29cd68b2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '20000000-0000-0000-0000-000000000002', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('5a91b411-69e2-4d85-86a9-16fb01cfc6e9', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('7d2101d3-6a7f-4b0b-a3f5-955dcf7ae160', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '054c6fc2-baf5-479a-a7f8-56676abc5bf5', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('6bbc9f3e-ddf5-4aed-ade9-d00a87a607cf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', 'TeamMember', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('b49c508a-da57-4b10-a8c2-74579020e0f6', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '72d468b8-f025-4209-a189-3b1ccb47b67d', 'DEVLead', false, NULL, NULL)
ON CONFLICT (project_member_id) DO NOTHING;
INSERT INTO project_members (project_member_id, project_id, person_id, project_role, is_main_pm, active_from, active_to)
VALUES ('634c869a-b04b-42af-ac3e-0123be7c4d92', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '318cc4ab-cea3-473e-bc4c-26e01a5609e0', 'TeamMember', false, NULL, NULL)
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
VALUES ('7ba16b63-8729-46ed-845e-f25264deb3d6', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-01', 'เตรียมความพร้อมและกำกับโครงการ', 1, '2026-01-01', '2026-01-15')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('9bb1dfd2-5dc3-4ad1-b095-6f7eff45806a', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-03', 'ก่อนรับทุน (Pre-Award)', 3, '2026-06-01', '2026-08-18')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('7adb5163-b5c0-434f-988b-3b054d6e0393', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-04', 'ใบรับรอง (Pre-Award)', 4, '2026-03-01', '2026-03-31')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('150ab373-9949-4675-b655-91e6f3f5f27e', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-05', 'หลังรับทุน (Post-Award)', 5, '2026-07-01', '2026-08-30')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('2ff1c929-19cf-4ec2-abe9-c188f4e0121b', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-06', 'การเชื่อมต่อระบบ', 6, '2026-12-02', '2027-02-09')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('bd772ef0-f259-4fc3-b1e3-2f7aa2d32c6f', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-07', 'กระดานรายงานและรายงาน', 7, NULL, NULL)
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('43a5cfbb-602e-40ce-99c4-0f24828d78e6', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-08', 'ทดสอบและนำระบบขึ้นใช้งาน', 8, '2027-03-03', '2027-04-13')
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('f3fcf761-aca7-4b2c-8303-b1e01d72f981', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-09', 'ปิดโครงการ', 9, NULL, NULL)
ON CONFLICT (phase_id) DO UPDATE SET
  phase_code = EXCLUDED.phase_code,
  phase_name = EXCLUDED.phase_name,
  sort_order = EXCLUDED.sort_order,
  planned_start_date = EXCLUDED.planned_start_date,
  planned_due_date = EXCLUDED.planned_due_date;
INSERT INTO project_phases (phase_id, project_id, phase_code, phase_name, sort_order, planned_start_date, planned_due_date)
VALUES ('d36009cb-067a-4bdf-b7de-0fff7a012627', '30000000-0000-0000-0000-000000000001', 'RRMS-PH-02', 'Profile', 2, '2026-05-01', '2026-12-31')
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
VALUES ('40000000-0000-0000-0000-000000000101', '30000000-0000-0000-0000-000000000002', NULL, 'DTP-01', 'Discovery', 1)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('40000000-0000-0000-0000-000000000102', '30000000-0000-0000-0000-000000000002', NULL, 'DTP-02', 'Pilot Delivery', 2)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
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
VALUES ('f018f7a2-3e58-42b5-856c-d5a1cf737887', '30000000-0000-0000-0000-000000000001', '7ba16b63-8729-46ed-845e-f25264deb3d6', 'RRMS-PH-01', 'เตรียมความพร้อมและกำกับโครงการ', 1)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('b20b3356-3ed0-43d6-a02f-eefce0b55096', '30000000-0000-0000-0000-000000000001', '9bb1dfd2-5dc3-4ad1-b095-6f7eff45806a', 'RRMS-PH-02', 'ก่อนรับทุน (Pre-Award)', 2)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('d40ec81e-b9d4-4706-890a-08f7f376aaed', '30000000-0000-0000-0000-000000000001', '7adb5163-b5c0-434f-988b-3b054d6e0393', 'RRMS-PH-03', 'ใบรับรอง (Pre-Award)', 3)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('ade45e8a-7025-45cc-952b-e72bddae8861', '30000000-0000-0000-0000-000000000001', '150ab373-9949-4675-b655-91e6f3f5f27e', 'RRMS-PH-04', 'หลังรับทุน (Post-Award)', 4)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('1276cd87-e4d0-4b70-a905-d8d251d083f3', '30000000-0000-0000-0000-000000000001', '2ff1c929-19cf-4ec2-abe9-c188f4e0121b', 'RRMS-PH-05', 'การเชื่อมต่อระบบ', 5)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('af4cf164-7cf9-40f4-8733-4f54b714f9be', '30000000-0000-0000-0000-000000000001', 'bd772ef0-f259-4fc3-b1e3-2f7aa2d32c6f', 'RRMS-PH-06', 'กระดานรายงานและรายงาน', 6)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('37327a1e-c513-491d-8eb2-f45541933bd7', '30000000-0000-0000-0000-000000000001', '43a5cfbb-602e-40ce-99c4-0f24828d78e6', 'RRMS-PH-07', 'ทดสอบและนำระบบขึ้นใช้งาน', 7)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('97304e21-1f01-42d5-b4c7-8b118cb4e09c', '30000000-0000-0000-0000-000000000001', 'f3fcf761-aca7-4b2c-8303-b1e01d72f981', 'RRMS-PH-08', 'ปิดโครงการ', 8)
ON CONFLICT (wbs_item_id) DO UPDATE SET
  wbs_code = EXCLUDED.wbs_code,
  wbs_name = EXCLUDED.wbs_name,
  phase_id = EXCLUDED.phase_id,
  sort_order = EXCLUDED.sort_order;
INSERT INTO wbs_items (wbs_item_id, project_id, phase_id, wbs_code, wbs_name, sort_order)
VALUES ('b98be34d-8455-4c63-abfa-528153f45887', '30000000-0000-0000-0000-000000000001', 'd36009cb-067a-4bdf-b7de-0fff7a012627', 'MAS-01', 'การบริหารจัดการข้อมูลนักวิจัย', 1)
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

-- 6. Tasks (All Work Items)
INSERT INTO tasks (task_id, project_id, wbs_item_id, parent_task_id, task_code, task_type, task_name, description, owner_person_id, planned_start_date, planned_due_date, actual_start_date, actual_end_date, status, rag_status, weight, progress, evidence_required, workstream)
VALUES ('50000000-0000-0000-0000-000000000101', '30000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000101', NULL, 'DTP-MT-001', 'MainTask', 'Assess current operating model', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-01', '2026-11-30', NULL, NULL, 'Done', 'Green', 33.33, 100, false, NULL)
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
VALUES ('50000000-0000-0000-0000-000000000102', '30000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000102', NULL, 'DTP-MT-002', 'MainTask', 'Deliver transformation pilot', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-01', '2026-11-30', NULL, NULL, 'InProgress', 'Green', 33.33, 45, false, NULL)
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
VALUES ('50000000-0000-0000-0000-000000000103', '30000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000102', '50000000-0000-0000-0000-000000000102', 'DTP-T-001', 'Task', 'Configure pilot workflow', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-01', '2026-11-30', NULL, NULL, 'InProgress', 'Amber', 33.33, 35, false, NULL)
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
VALUES ('96f5cf85-376c-444e-a759-8448fc507863', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-006', 'MainTask', 'Reports', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('df997935-6b13-4253-8bd4-ba6f7ea65bba', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-007', 'MainTask', 'Change Requests', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-009', 'MainTask', 'Requirement', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('9f929c0e-310b-45b2-bbe1-49ea0ad995f8', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-012', 'MainTask', 'Team Member', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('29669b5a-3374-449d-ad55-d3462dae9fa9', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-013', 'MainTask', 'คณะทำงาน', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2025-12-16', '2025-12-16', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('e8f89389-cb9d-4357-934d-42704a412e37', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-015', 'MainTask', 'Digital Signature', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-05-03', '2026-06-29', NULL, NULL, 'InProgress', 'Amber', 1, 75, false, NULL)
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
VALUES ('34690ad2-44fd-4049-b71f-e18ef6c39b61', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-019', 'MainTask', 'APIs', NULL, '318cc4ab-cea3-473e-bc4c-26e01a5609e0', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('3a37d06b-edfd-422f-917a-4a7dd6ac436b', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-020', 'MainTask', 'ระบบจัดเก็บเอกสาร', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('258fa107-9965-4654-a519-12e88b6985ec', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-021', 'MainTask', 'Web Portal', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('0f13f76f-0693-40e1-a5da-b3447c196972', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-022', 'MainTask', 'การเชื่อมต่อข้อมูลกับ SAP', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
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
VALUES ('f19c4d74-95a6-40cc-a8cd-e0e1bbe87492', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'bf410ad9-40f4-46f2-905c-09de75fd34fe', NULL, 'EDOC-026', 'MainTask', 'Kickoff Project', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-01-29', '2026-01-29', NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('9ded7d86-63f1-4c03-b58b-20aacc6f7462', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', NULL, 'EDOC-030', 'MainTask', 'Requirement', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('1d702d6f-c69b-4f3a-86cc-8e855f0f9c02', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-034', 'MainTask', 'Mu-sis', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-01-06', '2026-01-06', NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('fe2d5601-4bc0-45f1-80d8-5af28dc29a23', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-036', 'MainTask', 'Reports', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
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
VALUES ('c64c8721-08d1-49c4-a803-a4fb784b69fe', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-037', 'MainTask', 'ISO 9001:2015', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'InProgress', 'Amber', 1, 25, false, NULL)
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
VALUES ('35e8a389-5624-46c3-9ce3-3f6c55582319', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-038', 'MainTask', 'ISO อื่นๆ', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('fb337921-de65-4b7f-a18b-e6c0d31bd9db', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-041', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('2e44ed6f-040d-44a8-b8c2-a313318710d2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-042', 'MainTask', 'SIT', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('3e3e04bf-67d0-406e-9054-d14605184f6a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-043', 'MainTask', 'UAT', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('89db308d-ac51-4d47-ada0-25ef1f9ac464', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', NULL, 'EDOC-044', 'MainTask', 'Golive', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-30', '2026-08-30', NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('1c50c07b-bf80-4157-9507-f40a4d3c215e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-045', 'MainTask', 'Business Requirement', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('9b78890c-9db7-4777-83bf-f6a3781a28c8', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-048', 'MainTask', 'SIT', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 90, false, NULL)
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
VALUES ('8930374f-3985-4919-ad0d-ca37d86b0fcb', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-049', 'MainTask', 'UAT', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('336eba7d-cf3d-4a1b-8dbc-41688e1e445d', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-050', 'MainTask', 'Go-live', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-31', '2026-09-29', NULL, NULL, 'InProgress', 'Green', 1, 20, false, NULL)
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
VALUES ('2eefb7b7-5cb6-4e14-b492-ef571fb7e930', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', NULL, 'EDOC-052', 'MainTask', 'Trainging', NULL, '20000000-0000-0000-0000-000000000001', '2026-08-16', '2026-08-20', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('8a583e20-0540-472d-9c46-747bb0f5b7f7', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-053', 'MainTask', 'Development (1)', NULL, '72d468b8-f025-4209-a189-3b1ccb47b67d', NULL, NULL, NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
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
VALUES ('f618fae0-e089-481f-807b-c9f6d03ffa38', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-054', 'MainTask', 'SIT (1)', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('17f7dfbd-0a91-4940-a566-2b3f75e9114f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-055', 'MainTask', 'UAT (1)', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('82175c67-96ab-4b23-a966-de6b488f2673', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-056', 'MainTask', 'Trainging (1)', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('b5ac7868-998d-4f5b-8390-90207b82bb62', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', NULL, 'EDOC-057', 'MainTask', 'Go-live (1)', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('24511c2c-0c51-4da1-bb33-674e441a334e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-059', 'MainTask', 'สารบรรณ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('a9c9b521-c8c4-4ee2-b2d7-d79956753525', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-060', 'MainTask', 'พัสดุ', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('65b5815d-94ea-4267-b733-fa77d84543ba', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-061', 'MainTask', 'Requirement', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('a9bae895-091c-497e-9e00-a85a563bc323', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-062', 'MainTask', 'Development', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('8f4b124b-eebd-4439-a078-7ee7c9c8d8a7', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-063', 'MainTask', 'Test', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('d41fbeec-472a-4be2-a5c4-456645f58e72', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-064', 'MainTask', 'Go-live', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('815c0891-5506-42c6-870f-bb40c668bb4f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-065', 'MainTask', 'Requirement (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('3c993e37-aa63-4153-8105-e2ab2bcf436a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-066', 'MainTask', 'Development (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('1c293771-498d-4791-ad2b-de2f9543388e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-067', 'MainTask', 'Test (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('506babe8-664f-46f1-aade-461d52576c01', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '472a5fbd-481c-4747-adf0-744be6892895', NULL, 'EDOC-068', 'MainTask', 'Go-live (1)', NULL, '20000000-0000-0000-0000-000000000001', NULL, NULL, NULL, NULL, 'Cancelled', 'Green', 1, 0, false, NULL)
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
VALUES ('4cd41491-00ed-4f26-bfce-d5db503f4f1c', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-004', 'Task', 'Change request', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
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
VALUES ('1568bc81-f71f-40b7-80b1-e5df2c7dcc6e', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-010', 'Task', 'Bug Fixing', NULL, '20000000-0000-0000-0000-000000000002', '2025-09-07', '2025-09-07', NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
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
VALUES ('7610f115-66bf-4dd9-a1df-708708e2e047', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-014', 'Task', 'Report', NULL, '20000000-0000-0000-0000-000000000002', NULL, '2026-08-31', NULL, NULL, 'InProgress', 'Green', 1, 100, false, NULL)
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
VALUES ('f813c2eb-ac7f-4b25-a4a5-9fef01d7eae3', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-016', 'Task', 'PDF editor', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, '2026-05-01', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('196ebf9b-d00d-4a1a-8d51-15a12890da75', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-017', 'Task', 'กระบวนการส่งหนังสือ', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('0a5107a7-0dc4-4a24-bf62-624638bac90c', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-018', 'Task', 'กระบวนการรับหนังสือ', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('7958b609-243c-4f61-bdff-2e1c75afdba2', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'e8f89389-cb9d-4357-934d-42704a412e37', 'EDOC-023', 'Task', 'Preparation', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', NULL, NULL, NULL, NULL, 'Done', 'Amber', 1, 100, false, NULL)
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
VALUES ('1e5b694a-bf42-4b6c-afd5-b943cf9db3ee', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'e8f89389-cb9d-4357-934d-42704a412e37', 'EDOC-024', 'Task', 'Implement', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-04-30', '2026-06-29', NULL, NULL, 'InProgress', 'Amber', 1, 0, false, NULL)
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
VALUES ('68ac22d8-ce11-47c0-969e-9c0b69b104a1', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', 'EDOC-025', 'Task', 'UI', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('714b5ec7-90d2-41de-b324-4403068ea8b6', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '34690ad2-44fd-4049-b71f-e18ef6c39b61', 'EDOC-027', 'Task', 'Requirement', NULL, '318cc4ab-cea3-473e-bc4c-26e01a5609e0', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('a5eb9ec1-30e0-485e-8b7b-b8c4752aad91', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '34690ad2-44fd-4049-b71f-e18ef6c39b61', 'EDOC-028', 'Task', 'Test', NULL, '318cc4ab-cea3-473e-bc4c-26e01a5609e0', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('4a817790-89ab-4ecf-9eca-0fbbb29bb220', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', 'EDOC-031', 'Task', 'Prototype', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('3f6d866b-fa4f-4fc2-962e-c79a9d8b71dc', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'fab4d18d-3954-4061-90a5-6e7d6b5a36b2', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', 'EDOC-032', 'Task', 'System Design', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 0, false, NULL)
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
VALUES ('323509d4-d793-493b-995b-a08acd3bd8bf', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', 'EDOC-033', 'Task', 'Implement  เลขหนังสือใหม่ (หน่วยงานใหม่)', NULL, '20000000-0000-0000-0000-000000000002', '2026-01-04', '2026-03-30', NULL, NULL, 'InProgress', 'Green', 1, 0, false, NULL)
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
VALUES ('a99c5772-c479-411a-9394-386ae808b276', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', 'EDOC-035', 'Task', 'Stakeholder หลัก', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('8a9a232e-5d0f-4bf0-a873-b2b0660ea10b', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '2e3ded9d-d5ea-4857-99a1-b9b75019aa94', '35e8a389-5624-46c3-9ce3-3f6c55582319', 'EDOC-039', 'Task', 'Requirement', NULL, '20000000-0000-0000-0000-000000000002', NULL, NULL, NULL, NULL, 'NotStarted', 'Green', 1, 100, false, NULL)
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
VALUES ('a2373c35-92fe-4494-9b79-bec59a38c06a', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', 'a62c04de-3a6a-44bf-a3b2-36114f9c19e0', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', 'EDOC-040', 'Task', 'Stakeholder 11 หน่วยงาน', NULL, '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', NULL, NULL, NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('1647e64d-b7fe-46c0-b4b2-eccb84e9f95f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '1c50c07b-bf80-4157-9507-f40a4d3c215e', 'EDOC-046', 'Task', 'BRD review', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-06-30', '2026-06-30', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('a0d41adf-4440-42ce-8648-5864080a842f', '6d4495b9-4fb0-460d-af51-3f4e891d0cbf', '1c4321b2-49b1-48be-be24-7e13bb6473c4', '1c50c07b-bf80-4157-9507-f40a4d3c215e', 'EDOC-047', 'Task', 'BRD Approve', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-08-02', '2026-08-02', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('8c37f1c0-1b90-41af-aedc-9d0d60e5fba4', '30000000-0000-0000-0000-000000000001', 'f018f7a2-3e58-42b5-856c-d5a1cf737887', NULL, 'RRMS-GOV-01', 'MainTask', 'เปิดโครงการ ยืนยันขอบเขต และรูปแบบกำกับโครงการ', NULL, 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', '2026-01-01', '2026-01-15', NULL, NULL, 'Done', 'Red', 2.86, 100, true, NULL)
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
VALUES ('6814f572-73e7-4be6-9798-39e9e0125832', '30000000-0000-0000-0000-000000000001', 'f018f7a2-3e58-42b5-856c-d5a1cf737887', '8c37f1c0-1b90-41af-aedc-9d0d60e5fba4', 'RRMS-GOV-02', 'Task', 'ระบุผู้มีส่วนได้ส่วนเสียและจัดทำ RACI แยกตามสายงาน', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-01-01', '2026-01-30', NULL, NULL, 'Done', 'Amber', 2.86, 100, false, NULL)
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
VALUES ('63aebcc3-7667-4e14-bcef-7292201a161b', '30000000-0000-0000-0000-000000000001', 'f018f7a2-3e58-42b5-856c-d5a1cf737887', '8c37f1c0-1b90-41af-aedc-9d0d60e5fba4', 'RRMS-GOV-03', 'Task', 'จัดทำสถาปัตยกรรมระบบและภาพรวมการเชื่อมต่อ', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-01-01', '2026-02-28', NULL, NULL, 'Done', 'Amber', 2.86, 100, false, NULL)
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
VALUES ('54e57d1c-4b41-4464-b9eb-ba52f85dd30b', '30000000-0000-0000-0000-000000000001', 'f018f7a2-3e58-42b5-856c-d5a1cf737887', '8c37f1c0-1b90-41af-aedc-9d0d60e5fba4', 'RRMS-GOV-04', 'Task', 'กำหนดธรรมาภิบาลข้อมูล, PDPA และ มาตรฐานความปลอดภัยตั้งต้น', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-15', '2026-08-11', NULL, NULL, 'Done', 'Red', 2.86, 100, true, NULL)
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
VALUES ('e5d87859-71cd-4243-9ed1-5958a3d1d831', '30000000-0000-0000-0000-000000000001', 'b20b3356-3ed0-43d6-a02f-eefce0b55096', NULL, 'RRMS-PA-01', 'MainTask', 'กระบวนการทำงาน การอนุมัติทุนวิจัยภายใน', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-06-01', '2026-08-18', NULL, NULL, 'InProgress', 'Red', 2.86, 10, false, NULL)
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
VALUES ('35647624-c352-41bf-8bf3-9d77384909a0', '30000000-0000-0000-0000-000000000001', 'b20b3356-3ed0-43d6-a02f-eefce0b55096', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', 'RRMS-PA-02', 'Task', 'แบบฟอร์มขอทุนวิจัยภายใน', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-06-20', '2026-08-30', NULL, NULL, 'InProgress', 'Green', 2.86, 30, false, NULL)
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
VALUES ('7c160ff1-758e-48df-8212-29393f8a1342', '30000000-0000-0000-0000-000000000001', 'b20b3356-3ed0-43d6-a02f-eefce0b55096', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', 'RRMS-PA-03', 'Task', 'Dashboard, Report', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', NULL, NULL, NULL, NULL, 'OnHold', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('6df10e9d-85aa-4791-9508-1f590ece3154', '30000000-0000-0000-0000-000000000001', 'b20b3356-3ed0-43d6-a02f-eefce0b55096', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', 'RRMS-PA-04', 'Task', 'MU-Rex (เชื่อมต่อทุน Mu-Rex และ NRIIS)', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-10-01', '2026-11-03', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('18f04947-d40b-4ae9-8435-505d1c0f5a2e', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', NULL, 'RRMS-CP-01', 'MainTask', 'คณะกรรมการจริยธรรมการวิจัย - เก็บความต้องการและวิเคราะห์ วิเคราะห์ช่องว่างกระบวนการทำงาน', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-03-01', '2026-03-31', NULL, NULL, 'Done', 'Red', 2.86, 100, false, NULL)
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
VALUES ('d8147fcc-aa02-428f-af71-b97f3cc52ddf', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', 'RRMS-CP-02', 'Task', 'จริยธรรมการวิจัย (Ethic)', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-09-09', '2026-10-20', NULL, NULL, 'Done', 'Amber', 2.86, 100, false, 'Frontend & UI/UX')
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
VALUES ('ee841e19-ee1b-45d4-99c6-6cb4df7b0ff4', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', 'RRMS-CP-03', 'Task', 'เชื่อมต่อระบบและออก ใบรับรอง จริยธรรม(EC,Biosafty, Biobank)', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-10-07', '2026-11-17', NULL, NULL, 'Done', 'Red', 2.86, 100, true, NULL)
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
VALUES ('3caa01b1-6df5-41e2-8c14-e7c6bb9a1ee7', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', 'RRMS-CP-05', 'Task', 'คำขอแก้ไขระหว่าง หลังรับทุน', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-10-21', '2026-12-01', NULL, NULL, 'Done', 'Red', 2.86, 100, true, NULL)
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
VALUES ('f75a329f-592a-4518-af72-6820389be7cc', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', 'RRMS-CP-06', 'Task', 'ความปลอดภัยทางชีวภาพ - แบบฟอร์มและ กระบวนการทำงาน อนุมัติ (Biosafty)', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-09-16', '2026-11-10', NULL, NULL, 'Done', 'Amber', 2.86, 100, false, NULL)
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
VALUES ('a0f6cb9e-a2c7-4f0f-a70a-112269f36eb2', '30000000-0000-0000-0000-000000000001', 'd40ec81e-b9d4-4706-890a-08f7f376aaed', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', 'RRMS-CP-07', 'Task', 'คลังชีววัตถุ - แบบฟอร์มและ กระบวนการทำงาน อนุมัติ (Biobank)', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-09-23', '2026-11-17', NULL, NULL, 'Done', 'Amber', 2.86, 100, false, NULL)
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
VALUES ('a4542fbf-5213-4086-871b-961550b9b6cd', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', NULL, 'RRMS-LAB-01', 'MainTask', 'ระบบจองห้อง Lab', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2026-07-01', '2026-08-30', NULL, NULL, 'InProgress', 'Amber', 2.86, 50, false, NULL)
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
VALUES ('dbd96ba5-4577-47ad-82a2-87de227ab2b0', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', 'a4542fbf-5213-4086-871b-961550b9b6cd', 'RRMS-LAB-02', 'Task', 'ระบบจองเครื่องมือและตารางใช้งาน', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-07-01', '2026-08-30', NULL, NULL, 'InProgress', 'Amber', 2.86, 50, false, NULL)
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
VALUES ('39a0c9ab-9bf8-4f0b-98aa-e7f6d6e7504f', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', NULL, 'RRMS-FND-01', 'MainTask', 'บริหาร หมุดหมาย ของทุนวิจัย (Milestone)', NULL, '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', '2026-08-01', '2026-10-31', NULL, NULL, 'InProgress', 'Red', 2.86, 27, true, NULL)
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
VALUES ('b6159eda-97e1-4540-8547-2e9572829dd7', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', '39a0c9ab-9bf8-4f0b-98aa-e7f6d6e7504f', 'RRMS-FND-02', 'Task', 'บริหารการเงินและรายงานการเงิน', NULL, '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', '2026-06-01', '2026-10-31', NULL, NULL, 'InProgress', 'Red', 2.86, 50, true, NULL)
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
VALUES ('1823f309-97cc-4439-8691-5a97f747f34d', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', '39a0c9ab-9bf8-4f0b-98aa-e7f6d6e7504f', 'RRMS-FND-03', 'Task', 'รายงานผลการดำเนินงานและรายงานเงิน', NULL, '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', '2026-06-01', '2026-10-31', NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('c56f2a8b-b534-42f9-bff0-181e2db5ab73', '30000000-0000-0000-0000-000000000001', 'ade45e8a-7025-45cc-952b-e72bddae8861', '39a0c9ab-9bf8-4f0b-98aa-e7f6d6e7504f', 'RRMS-FND-04', 'Task', 'Amentment', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-12-02', '2027-01-26', NULL, NULL, 'InProgress', 'Red', 2.86, 30, true, NULL)
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
VALUES ('4c00b9ab-6939-4cea-ae63-40e552df3336', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', NULL, 'RRMS-HIS-01', 'MainTask', 'ซิงก์ข้อมูลผู้ป่วย/อาสาสมัคร ผ่าน HL7/FHIR', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-12-02', '2027-02-09', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('30536a8f-b7d1-45c2-9a01-3cc2b94195ad', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', '4c00b9ab-6939-4cea-ae63-40e552df3336', 'RRMS-HIS-02', 'Task', 'การคิดค่าใช้จ่ายงานวิจัยทางคลินิก', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', '2027-01-06', '2027-02-23', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('4a981057-da90-4415-9f2b-9980da4228bf', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', '30536a8f-b7d1-45c2-9a01-3cc2b94195ad', 'RRMS-HIS-03', 'Subtask', 'ช่องทางกลางบริการเชื่อมต่อ และ ติดตามระบบ สำหรับ HIS', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2027-01-20', '2027-03-09', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('4fe1ae2c-bbdd-43ec-b5b2-39993d186bc5', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', NULL, 'RRMS-SAP-01', 'MainTask', 'เชื่อมต่อ SAP FI/CO บริการเชื่อมต่อ', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', '2026-06-01', '2026-10-31', NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, true, NULL)
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
VALUES ('94011671-fc5c-4907-b422-c9ddb3efb52b', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', '4fe1ae2c-bbdd-43ec-b5b2-39993d186bc5', 'RRMS-SAP-02', 'Task', 'เชื่อมต่อ SAP AP บริการเชื่อมต่อ', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', '2026-06-01', '2026-10-31', NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, true, NULL)
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
VALUES ('ab3ee3f0-ab22-4f22-b9b3-4aceb25f0ab5', '30000000-0000-0000-0000-000000000001', '1276cd87-e4d0-4b70-a905-d8d251d083f3', '94011671-fc5c-4907-b422-c9ddb3efb52b', 'RRMS-SAP-03', 'Subtask', 'เชื่อมต่อ SAP HR บริการเชื่อมต่อ', NULL, 'e755fbfb-cf55-4ab9-b17f-382dadf72913', '2026-06-01', '2026-10-31', NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('a95c3e3b-3af0-46e7-b2d3-d5cbe8323f71', '30000000-0000-0000-0000-000000000001', 'af4cf164-7cf9-40f4-8733-4f54b714f9be', NULL, 'RRMS-BI-01', 'MainTask', 'กำหนด บัญชีตัวชี้วัด และ คลังข้อมูลย่อย', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', NULL, NULL, NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('151150cd-99c7-416a-8504-fcf57ba5f250', '30000000-0000-0000-0000-000000000001', 'af4cf164-7cf9-40f4-8733-4f54b714f9be', 'a95c3e3b-3af0-46e7-b2d3-d5cbe8323f71', 'RRMS-BI-02', 'Task', 'กระดานรายงานผู้บริหารและ ปฏิบัติการ กระดานรายงาน', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', NULL, NULL, NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('5940e068-a49f-4f8f-a9e1-767bfdb16f18', '30000000-0000-0000-0000-000000000001', 'af4cf164-7cf9-40f4-8733-4f54b714f9be', 'a95c3e3b-3af0-46e7-b2d3-d5cbe8323f71', 'RRMS-BI-03', 'Task', 'ชุดรายงานมาตรฐานและ ส่งออก', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', NULL, NULL, NULL, NULL, 'NotStarted', 'Amber', 2.86, 0, false, NULL)
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
VALUES ('71a88e24-7aae-4b8e-9155-b73e916010e3', '30000000-0000-0000-0000-000000000001', '37327a1e-c513-491d-8eb2-f45541933bd7', NULL, 'RRMS-QA-01', 'MainTask', 'SIT แบบ สิ้นสุด-to-สิ้นสุด', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2027-03-03', '2027-04-13', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('7f12917d-e08e-403e-98e3-ea6eee92885f', '30000000-0000-0000-0000-000000000001', '37327a1e-c513-491d-8eb2-f45541933bd7', '71a88e24-7aae-4b8e-9155-b73e916010e3', 'RRMS-QA-02', 'Task', 'การทดสอบรับรองโดยผู้ใช้, ฝึกอบรม และคู่มือผู้ใช้', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2027-04-14', '2027-05-11', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('ad437960-e4e1-48d5-9732-a31aae5d6fbe', '30000000-0000-0000-0000-000000000001', '37327a1e-c513-491d-8eb2-f45541933bd7', '71a88e24-7aae-4b8e-9155-b73e916010e3', 'RRMS-QA-03', 'Task', 'การย้ายข้อมูล และ การเปลี่ยนผ่านขึ้นระบบ แผน', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2027-04-21', '2027-05-18', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('0e29412c-cd07-48d3-ba59-bbd96681bdd5', '30000000-0000-0000-0000-000000000001', '37327a1e-c513-491d-8eb2-f45541933bd7', '71a88e24-7aae-4b8e-9155-b73e916010e3', 'RRMS-QA-04', 'Task', 'เปิดใช้งานจริง, ดูแลเข้มหลังเปิดใช้งาน และ ติดตามระบบ', NULL, '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', '2027-05-19', '2027-06-08', NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('4430ab28-d0fb-41df-8645-73133c7bb428', '30000000-0000-0000-0000-000000000001', '97304e21-1f01-42d5-b4c7-8b118cb4e09c', NULL, 'RRMS-CL-01', 'MainTask', 'รับมอบ ผลผลิตโครงการ', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', NULL, NULL, NULL, NULL, 'NotStarted', 'Red', 2.86, 0, false, NULL)
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
VALUES ('c07649a6-763d-4e48-823f-06b312ba6ae2', '30000000-0000-0000-0000-000000000001', '97304e21-1f01-42d5-b4c7-8b118cb4e09c', '4430ab28-d0fb-41df-8645-73133c7bb428', 'RRMS-CL-02', 'Task', 'ปิดบัญชีการเงิน และสรุปงบประมาณโครงการ', NULL, '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', NULL, NULL, NULL, NULL, 'NotStarted', 'Red', 2.86, 0, true, NULL)
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
VALUES ('86bd2dcd-07f1-4c50-9bd0-42367e9639a7', '30000000-0000-0000-0000-000000000001', 'b98be34d-8455-4c63-abfa-528153f45887', NULL, 'RRMS-MT-004', 'MainTask', 'การจัดการข้อมูลนักวิจัย', NULL, '9b16c1a5-b13d-4457-9b03-473f66d65809', '2026-07-01', '2026-09-30', NULL, NULL, 'Done', 'Green', 1, 100, false, NULL)
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
VALUES ('f71c16bb-8961-4fc5-b808-12f4dee08fca', '30000000-0000-0000-0000-000000000001', 'b98be34d-8455-4c63-abfa-528153f45887', NULL, 'RRMS-MT-005', 'MainTask', 'การเข้าระบบสำหรับบุคคลภายนอก', NULL, 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', '2026-07-01', '2026-12-31', NULL, NULL, 'OnHold', 'Green', 1, 20, false, NULL)
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
VALUES ('9330c5a9-58c4-46f8-9166-f7a65f253ac3', '50000000-0000-0000-0000-000000000101', '20000000-0000-0000-0000-000000000001', 'Contributor', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('5ee83dd7-e9a9-41e4-9b8c-d903deed8ef5', '50000000-0000-0000-0000-000000000102', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('623d1a0d-9ef3-46e9-9845-095a74afb55a', '50000000-0000-0000-0000-000000000103', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ae400e63-c1dd-4743-912d-3d7ff161c920', 'b091875c-cc19-4448-8987-22830f884933', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('4cab4471-4de1-45a4-84e1-df38ad4ad854', '2eefb7b7-5cb6-4e14-b492-ef571fb7e930', '20000000-0000-0000-0000-000000000001', 'Owner', 'Accountable', true)
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
VALUES ('fe60c549-f45d-4d13-bf7e-43dbd33f9995', '4cd41491-00ed-4f26-bfce-d5db503f4f1c', '20000000-0000-0000-0000-000000000001', 'Contributor', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('1f40f718-e5fb-402b-b0f2-930db60068ad', '6814f572-73e7-4be6-9798-39e9e0125832', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b1c9facc-5257-4702-9715-2d929559319b', '63aebcc3-7667-4e14-bcef-7292201a161b', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('0cedadc8-10f9-47e2-ad50-8c2b9b840666', '54e57d1c-4b41-4464-b9eb-ba52f85dd30b', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a7d5e7f6-5241-4a90-85b4-6ffc4e9a834f', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('4896cbe3-8084-47b7-9766-b94a6844e619', '18f04947-d40b-4ae9-8435-505d1c0f5a2e', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d88ee26c-37a9-4a49-b961-1a73b08b5033', 'ee841e19-ee1b-45d4-99c6-6cb4df7b0ff4', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('699c9c94-8a32-4cc2-a110-401e527c6229', '3caa01b1-6df5-41e2-8c14-e7c6bb9a1ee7', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('6a60b0b5-ef88-4c92-82d4-62d2627c69a4', 'f75a329f-592a-4518-af72-6820389be7cc', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('469d661e-4368-410a-8660-821b6b7339c5', 'a4542fbf-5213-4086-871b-961550b9b6cd', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a90b4b68-3eed-45de-a666-96f0aca394c7', '39a0c9ab-9bf8-4f0b-98aa-e7f6d6e7504f', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('10c01efb-023e-4333-823c-1d131389c5c0', 'b6159eda-97e1-4540-8547-2e9572829dd7', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('6b47c08e-1198-4b7a-9f17-34d0565e2d87', '1823f309-97cc-4439-8691-5a97f747f34d', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('fe6a6389-42ab-43e5-9502-b7314009b6a1', 'c56f2a8b-b534-42f9-bff0-181e2db5ab73', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e11a7a23-ea48-4836-826d-6e47ce8a6a9f', '4c00b9ab-6939-4cea-ae63-40e552df3336', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('a42e089a-d675-4484-ae5c-920962986aa7', '4fe1ae2c-bbdd-43ec-b5b2-39993d186bc5', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e2170d44-cd04-44b2-b8fd-126f942297be', '94011671-fc5c-4907-b422-c9ddb3efb52b', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e6ab08ff-a37c-4159-9fa2-370b1f88f325', 'ab3ee3f0-ab22-4f22-b9b3-4aceb25f0ab5', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('350995a6-924d-4e82-9582-d0aea2f9999c', 'a95c3e3b-3af0-46e7-b2d3-d5cbe8323f71', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c7e7179e-0caf-442b-a80e-3a74af217b52', '71a88e24-7aae-4b8e-9155-b73e916010e3', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('aae3cca1-a722-4c3c-b83e-67c0fdb345d8', '7f12917d-e08e-403e-98e3-ea6eee92885f', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('0a548b0c-566d-4f15-a9ae-c54dd0daa8cf', 'ad437960-e4e1-48d5-9732-a31aae5d6fbe', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('11146d67-2b1c-4914-baa8-2b386d1c3bb0', '0e29412c-cd07-48d3-ba59-bbd96681bdd5', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('09828c41-8f46-49a3-938b-968cec951072', '4430ab28-d0fb-41df-8645-73133c7bb428', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9410ae21-d419-4175-bd1c-bdc1b68eabf1', '35647624-c352-41bf-8bf3-9d77384909a0', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f721737d-5606-4f89-8ba2-32b6f6a4587b', '7c160ff1-758e-48df-8212-29393f8a1342', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c7b9e182-931b-4720-94f6-1022683da750', '6df10e9d-85aa-4791-9508-1f590ece3154', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('632c7641-18bc-4315-9118-1b7bda09061c', '8c37f1c0-1b90-41af-aedc-9d0d60e5fba4', 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('7a6115c5-ae73-42b0-9ab8-7e7bf5d533b6', '86bd2dcd-07f1-4c50-9bd0-42367e9639a7', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('1e09b50c-6df3-4ded-8027-781783a9e779', 'f71c16bb-8961-4fc5-b808-12f4dee08fca', 'ce4f9d8e-0f9d-4db3-9a75-61cf3cfcdd50', 'Owner', 'Accountable', true)
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
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('7d2e8a5d-1227-4928-97a0-e954b647fd23', 'd8147fcc-aa02-428f-af71-b97f3cc52ddf', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('39df4b1e-00fe-426e-bdad-e42f334f3609', 'a0f6cb9e-a2c7-4f0f-a70a-112269f36eb2', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d10dae8c-6d5d-45da-857e-9e4d794826af', 'dbd96ba5-4577-47ad-82a2-87de227ab2b0', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('29b6e639-a394-486f-852d-73e5dfd48222', '30536a8f-b7d1-45c2-9a01-3cc2b94195ad', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9a98ea72-a0fd-4b8f-b93f-8759f7a79e33', '4a981057-da90-4415-9f2b-9980da4228bf', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('6e447824-88ed-4667-9833-57aa12b3e8c1', '151150cd-99c7-416a-8504-fcf57ba5f250', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('8bcd1701-3dc1-428f-bd8a-b54fe8b27d33', '5940e068-a49f-4f8f-a9e1-767bfdb16f18', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('5b7c019a-e9bb-4950-8aec-c2306511e020', 'c07649a6-763d-4e48-823f-06b312ba6ae2', '84ef2811-dd6c-4349-ac7c-6ea87f15b0b6', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9a63fe6e-f782-40db-b9f8-dacdf31d9aab', '4cd41491-00ed-4f26-bfce-d5db503f4f1c', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('8be9ea5d-15a8-422b-8e64-885d798733d1', '96f5cf85-376c-444e-a759-8448fc507863', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('2bd3decb-dd86-4226-b00d-a9013beaa6a3', 'df997935-6b13-4253-8bd4-ba6f7ea65bba', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('8dbf738b-8f0f-4bd6-95c9-8f7c71ca44a2', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9a4ce2e7-c48f-4c89-aa85-a011c3060cda', '1568bc81-f71f-40b7-80b1-e5df2c7dcc6e', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('4c9a02c3-9872-4f2e-a706-7afb5dd8d23e', '9f929c0e-310b-45b2-bbe1-49ea0ad995f8', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e7107c4b-caa2-4ece-b19e-0835701209d2', '29669b5a-3374-449d-ad55-d3462dae9fa9', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('bc59e8ef-e8ee-4b17-8d5f-0a272554fe65', '7610f115-66bf-4dd9-a1df-708708e2e047', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9e8ede6a-9ff3-4cf4-bde9-728908d01bd4', 'e8f89389-cb9d-4357-934d-42704a412e37', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ec503225-0d75-4ae2-aa93-ff211f9e63c8', 'f813c2eb-ac7f-4b25-a4a5-9fef01d7eae3', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('35c3fe9d-4dc0-48c8-a57b-4a93208c3fc2', '196ebf9b-d00d-4a1a-8d51-15a12890da75', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('96dcc1bc-0f27-44a5-afeb-f1c67cd71f5f', '0a5107a7-0dc4-4a24-bf62-624638bac90c', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d362f100-5962-4806-a5cf-334a27acb507', '34690ad2-44fd-4049-b71f-e18ef6c39b61', '318cc4ab-cea3-473e-bc4c-26e01a5609e0', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('0cc98068-3efd-407b-826c-f1c2b3fb3017', '3a37d06b-edfd-422f-917a-4a7dd6ac436b', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('e2485800-c38f-459e-8c62-fd06c42d08bd', '258fa107-9965-4654-a519-12e88b6985ec', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('59a58a39-a31b-4ed1-82a6-7e81150d0cdb', '0f13f76f-0693-40e1-a5da-b3447c196972', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b2e81983-6c88-40ce-a24f-12e6e0db1ca0', '7958b609-243c-4f61-bdff-2e1c75afdba2', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('95de3e87-fc89-4a26-b352-6f5efb570a01', '1e5b694a-bf42-4b6c-afd5-b943cf9db3ee', '9b16c1a5-b13d-4457-9b03-473f66d65809', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('8a9b1f27-6347-4e55-afb7-d0dee1180387', '68ac22d8-ce11-47c0-969e-9c0b69b104a1', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('3021a281-06c0-44db-96b2-d6a6c1b5881b', 'f19c4d74-95a6-40cc-a8cd-e0e1bbe87492', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('71e4ee89-611b-4bc1-bee3-23c6b10445b8', '714b5ec7-90d2-41de-b324-4403068ea8b6', '318cc4ab-cea3-473e-bc4c-26e01a5609e0', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('5ac1de17-0214-4a32-9a10-27da0626ca61', 'a5eb9ec1-30e0-485e-8b7b-b8c4752aad91', '318cc4ab-cea3-473e-bc4c-26e01a5609e0', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b78e8658-8a61-4d3d-bfc4-047e7fe0d200', '9ded7d86-63f1-4c03-b58b-20aacc6f7462', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b287c526-4aa9-42b6-9762-4d45f6cfcbbb', '4a817790-89ab-4ecf-9eca-0fbbb29bb220', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('78dbf04e-e12e-4a1a-b7d6-da8323314b38', '3f6d866b-fa4f-4fc2-962e-c79a9d8b71dc', 'e755fbfb-cf55-4ab9-b17f-382dadf72913', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('f3bb4f3f-41a5-42a6-a178-dbdf0adac5ff', '323509d4-d793-493b-995b-a08acd3bd8bf', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('4b520b76-a6e5-4d68-bfdd-c04aea81ec12', '1d702d6f-c69b-4f3a-86cc-8e855f0f9c02', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('2bbe0249-b694-4c09-9ae8-cccc5608362a', 'a99c5772-c479-411a-9394-386ae808b276', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('d9eab283-baff-4484-a280-e322c350a581', 'fe2d5601-4bc0-45f1-80d8-5af28dc29a23', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('72667efb-adb0-403e-9d97-170f2d7fe071', 'c64c8721-08d1-49c4-a803-a4fb784b69fe', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('352d9655-31d7-4fef-b895-784ff46cf137', '35e8a389-5624-46c3-9ce3-3f6c55582319', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('5af9bdf1-981e-43fb-8e00-df1c0945f84b', '8a9a232e-5d0f-4bf0-a873-b2b0660ea10b', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('276454f4-c418-44e0-9304-2f24741715ef', 'a2373c35-92fe-4494-9b79-bec59a38c06a', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('b076fe0b-fee0-412e-97c4-936b1ab82674', 'fb337921-de65-4b7f-a18b-e6c0d31bd9db', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9a914d2c-949f-44a0-b0c4-8082f558adc6', '2e44ed6f-040d-44a8-b8c2-a313318710d2', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('ca5c3d03-8f80-4875-a7d6-5d9756ea41e7', '3e3e04bf-67d0-406e-9054-d14605184f6a', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('cd347d7a-4abb-44f5-bd41-127d15112260', '89db308d-ac51-4d47-ada0-25ef1f9ac464', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('74ef739a-8db5-47cf-8a91-0fb109baf686', '1c50c07b-bf80-4157-9507-f40a4d3c215e', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('6064a501-fc03-473f-8ad8-fe2e4b19418c', '1647e64d-b7fe-46c0-b4b2-eccb84e9f95f', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('0f17c24d-1797-4bed-8085-cb5dda4045a6', 'a0d41adf-4440-42ce-8648-5864080a842f', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9d7c3a91-a365-42f1-aba0-f3a889a365c1', '9b78890c-9db7-4777-83bf-f6a3781a28c8', '20000000-0000-0000-0000-000000000002', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('c5f99882-49d8-4dbd-ba62-6eba3311afa5', '8930374f-3985-4919-ad0d-ca37d86b0fcb', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('183369f2-103c-4b2c-8351-70ec46db662a', '336eba7d-cf3d-4a1b-8dbc-41688e1e445d', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('fc1c9a93-a3f4-4685-9d45-f2ae59d1b271', '8a583e20-0540-472d-9c46-747bb0f5b7f7', '72d468b8-f025-4209-a189-3b1ccb47b67d', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('44cabc11-99ac-4d69-beb0-0ae056340cbf', 'f618fae0-e089-481f-807b-c9f6d03ffa38', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('cc14c52c-33f2-47c7-ab99-3b60018a42d5', '17f7dfbd-0a91-4940-a566-2b3f75e9114f', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('9970d6ae-0688-45f4-b501-ba50da3ba379', '82175c67-96ab-4b23-a966-de6b488f2673', '2d0a827b-6cc7-4611-9a5f-e0ffa54a84bc', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;
INSERT INTO task_assignments (task_assignment_id, task_id, person_id, assignment_role, raci_role, is_primary)
VALUES ('cdb66038-1a26-4567-bca6-7f31c72076e4', 'b5ac7868-998d-4f5b-8390-90207b82bb62', '685a6439-7f6f-4fb1-8e8d-bf1ab6ec69af', 'Owner', 'Accountable', true)
ON CONFLICT (task_assignment_id) DO NOTHING;

-- 8. Weekly Updates
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('05552896-0297-4dc0-bf88-a0accf9c7dee', '03eb40fa-1c9a-44f4-842f-1ad58fc00386', '2026-08-31', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('fb49234b-2722-4746-8731-6cd629874412', '59dc165e-8a28-4d0b-8322-95a7521dd698', '2026-08-31', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('b1fbbd52-1d11-4636-b5f9-3b0f8656bd1a', 'c4d7664a-419e-447d-8909-63b690122eff', '2026-08-31', 50, 'InProgress', 'Red', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('b681cb52-76f4-4da3-bb16-db17f2086b72', '776997f1-488f-4fff-9554-deb64d107ef4', '2026-08-31', 100, 'Done', 'Red', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('047ad789-a0ac-4ad2-883c-e4c19a96aac0', '6b2d5035-665e-4bfe-aaff-b8a89bfa4dcc', '2026-08-31', 50, 'InProgress', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('5e75ad20-431c-4dfd-8459-9160882a6cc3', '386ae5c0-d09f-451a-95a8-29ce369274a1', '2026-08-31', 50, 'InProgress', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('0c7a4480-95c5-475d-ac4b-e85412e75ac4', '86bd2dcd-07f1-4c50-9bd0-42367e9639a7', '2026-08-31', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('aa85f895-4d58-4c0a-8469-bfc6f108a73c', 'f71c16bb-8961-4fc5-b808-12f4dee08fca', '2026-08-31', 20, 'OnHold', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('f8285fc2-55e5-43e0-8f58-36c4a640508d', '7c160ff1-758e-48df-8212-29393f8a1342', '2026-08-31', 0, 'OnHold', 'Amber', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('8edd79ac-d16b-4cad-972f-5042d996d5e3', 'c56f2a8b-b534-42f9-bff0-181e2db5ab73', '2026-08-31', 30, 'InProgress', 'Red', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('a0fd5c23-ed1f-4cf5-8669-2af62b7448a8', '0a5107a7-0dc4-4a24-bf62-624638bac90c', '2026-09-07', 100, 'Done', 'Amber', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('effe761d-1f00-4bd4-895d-777c66409896', '506babe8-664f-46f1-aade-461d52576c01', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('c106c661-5bd7-4d2f-abd9-032d88160a12', '1c293771-498d-4791-ad2b-de2f9543388e', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('3c8be012-32ea-4a08-bc2d-76d332722430', '3c993e37-aa63-4153-8105-e2ab2bcf436a', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('4dc990b7-d141-4471-a55d-9be0e330cfb4', '815c0891-5506-42c6-870f-bb40c668bb4f', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('eab73c33-637f-4785-939a-d67c8adac648', 'd41fbeec-472a-4be2-a5c4-456645f58e72', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('234c4fc0-6a56-49d4-9479-6d70946c54f5', '8f4b124b-eebd-4439-a078-7ee7c9c8d8a7', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('357c95e1-a1d6-49ff-86e4-f1af3919fca8', 'a9bae895-091c-497e-9e00-a85a563bc323', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('6fa0a896-0410-4ba1-8256-6227e2b1228f', '65b5815d-94ea-4267-b733-fa77d84543ba', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('6dce52db-ae3d-47a1-a465-568841e938b5', 'a9c9b521-c8c4-4ee2-b2d7-d79956753525', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('ecfb46a0-2851-43ca-b3e4-cce34e9b965e', '24511c2c-0c51-4da1-bb33-674e441a334e', '2026-09-07', 0, 'Cancelled', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('bb7d95eb-d7dd-46c7-b666-59dd717f11e7', 'a2373c35-92fe-4494-9b79-bec59a38c06a', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('19481145-283a-4bb7-b7f0-a9ed6ab0aeea', 'a99c5772-c479-411a-9394-386ae808b276', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('b3a4fa82-fcc7-4974-97b1-21fdaefd3d37', '3ed2f8b0-e5e1-49de-8936-fd7bb2d63b93', '2026-09-07', 80, 'InProgress', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('2bf7d307-be10-4432-9531-1565daea534d', '2eefb7b7-5cb6-4e14-b492-ef571fb7e930', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('b588075d-20b4-43dd-b451-e7ad177c8f0d', '336eba7d-cf3d-4a1b-8dbc-41688e1e445d', '2026-09-07', 20, 'InProgress', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('3792facf-22ae-4161-ace0-a40b2280f22c', '8930374f-3985-4919-ad0d-ca37d86b0fcb', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('e8890a38-42b6-424f-acec-f9da22e9a933', '9b78890c-9db7-4777-83bf-f6a3781a28c8', '2026-09-07', 90, 'InProgress', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('c91f6da1-e438-4b45-a725-216f20779334', 'a5eb9ec1-30e0-485e-8b7b-b8c4752aad91', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('98505d78-034f-47ab-a944-5ff82dd4009a', '714b5ec7-90d2-41de-b324-4403068ea8b6', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('2dfdae6e-671c-46fa-ac12-e4aaf5c17541', '34690ad2-44fd-4049-b71f-e18ef6c39b61', '2026-09-07', 100, 'Done', 'Green', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;
INSERT INTO weekly_updates (weekly_update_id, task_id, week_start_date, progress, status, rag_status, submitted_by_person_id)
VALUES ('d2d4ab7c-ba9a-46f6-9ae6-20298bef1d07', 'e8f89389-cb9d-4357-934d-42704a412e37', '2026-09-07', 75, 'InProgress', 'Amber', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (weekly_update_id) DO NOTHING;

-- 9. Task Notes
INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id)
VALUES ('62797b72-5a84-4c45-a7a5-96823d9524b5', 'd8147fcc-aa02-428f-af71-b97f3cc52ddf', 'Note', 'ดำเนินการ BRD เรียบร้อยแล้ว และ User accept ข้อมูลการดำเนินการเรียบร้อย', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (task_note_id) DO NOTHING;
INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id)
VALUES ('a4bc91ee-bc43-4dfb-804c-b31ddc77f6c4', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', 'Update', 'เหลือดำเนินการ BRD ให้ครบ', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (task_note_id) DO NOTHING;
INSERT INTO task_notes (task_note_id, task_id, note_type, note_text, created_by_person_id)
VALUES ('cb2886d6-a098-4bdf-8942-57f035f73dea', 'e5d87859-71cd-4243-9ed1-5958a3d1d831', 'Note', 'เก็บ requirement  มาเรียบร้อย เหลือดำเนินการสร้าง BRD', '20000000-0000-0000-0000-000000000001')
ON CONFLICT (task_note_id) DO NOTHING;

-- 10. RAID Items
INSERT INTO raid_items (raid_item_id, project_id, item_code, raid_type, title, description, impact, probability, mitigation_plan, owner_person_id, due_date, status)
VALUES ('7fca77f8-0a4a-48c0-a3f3-a51060ea5f4e', '30000000-0000-0000-0000-000000000001', NULL, 'Risk', 'Pilot feedback may expand the initial scope', NULL, 3, 2, 'Keep the first walkthrough focused on high-level workflow.', '20000000-0000-0000-0000-000000000001', NULL, 'Open')
ON CONFLICT (raid_item_id) DO NOTHING;