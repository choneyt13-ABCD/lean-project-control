ALTER TABLE task_assignments
    DROP CONSTRAINT IF EXISTS task_assignments_assignment_role_check;

ALTER TABLE task_assignments
    ALTER COLUMN assignment_role TYPE varchar(100);
