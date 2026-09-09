INSERT OR IGNORE INTO task_statuses (task_status_code, display_name, sort_order, is_terminal)
VALUES ('OnHold', 'On Hold', 3, 0);

UPDATE task_statuses
SET sort_order = CASE task_status_code
  WHEN 'NotStarted' THEN 1
  WHEN 'InProgress' THEN 2
  WHEN 'OnHold' THEN 3
  WHEN 'Blocked' THEN 4
  WHEN 'Done' THEN 5
  WHEN 'Cancelled' THEN 6
  ELSE sort_order
END;
