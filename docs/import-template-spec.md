# Excel Import Template Specification

Phase 1 import specification for RRMS WBS and task setup.

The MVP import is limited to project delivery structure: WBS, Main Task, Task, Subtask, owners, assignees, planned dates, status, weight, progress, and evidence requirement. It does not import binary evidence files or production credentials.

## Workbook

| Worksheet | Required | Purpose |
| --- | --- | --- |
| `wbs_task_import` | Yes | Single-sheet import for RRMS WBS, Main Task, Task, and Subtask hierarchy. |
| `validation_lists` | No | Optional helper sheet for allowed values. Not imported. |

## wbs_task_import Columns

| Column | Required | Type | Example | Notes |
| --- | --- | --- | --- | --- |
| `Project Code` | Yes | String | `RRMS` | Must match an existing Project Master record. |
| `Parent WBS` | No | String | `RRMS-01` | Parent WBS code. Blank means root WBS. |
| `WBS Code` | Yes | String | `RRMS-01.01` | Unique within project. |
| `WBS Name` | Yes | String | `Requirements` | Required for creating or updating WBS item. |
| `Item Code` | Yes | String | `RRMS-T-001` | Unique work item code within project. |
| `Item Type` | Yes | Enum | `Task` | Allowed values: Main Task, Task, Subtask. |
| `Parent Item Code` | No | String | `RRMS-MT-001` | Required when Item Type is Task or Subtask, except when PM approves flat structure. |
| `Title` | Yes | String | `Confirm RRMS workflow` | Task title. |
| `Description` | No | Text | `Review current RRMS process` | Optional task detail. |
| `Owner Person ID` | Yes | UUID/String | `P-00012` | Must exist in People Master and project membership. |
| `Assignee Person IDs` | Yes | String list | `P-00012;P-00019;P-00025` | Semicolon-separated list. Each person must exist and be a project member. |
| `Role` | Yes | Enum | `BA` | Assignment role for listed assignees. Allowed values: Owner, BA, DEV, QA, Reviewer, Contributor, Observer. |
| `Start Date` | No | Date | `2026-09-01` | ISO date format: YYYY-MM-DD. |
| `Due Date` | No | Date | `2026-09-15` | Must be equal to or later than Start Date when both are present. |
| `Status` | Yes | Enum | `NotStarted` | Allowed values: NotStarted, InProgress, OnHold, Blocked, Done, Cancelled. |
| `Weight` | No | Decimal | `10` | 0-100. PM must decide if sum must equal 100 by WBS. |
| `Progress` | Yes | Decimal | `0` | 0-100. Done requires 100. NotStarted should be 0. |
| `Evidence Required` | Yes | Boolean | `TRUE` | Allowed values: TRUE, FALSE, Yes, No, 1, 0. |

## Hierarchy Rules

- `Project Code` must be `RRMS` for the first pilot unless PM approves another pilot code.
- `WBS Code` is unique within `Project Code`.
- `Parent WBS` must either be blank or reference another `WBS Code` in the same project.
- Main Task must belong to a valid WBS.
- Task should reference a Main Task in `Parent Item Code`.
- Subtask should reference a Task in `Parent Item Code`.
- Circular parent-child references are invalid.
- The import must support multiple people per task through `Assignee Person IDs`.

## Validation Rules

| Rule | Error Code | Error Message Template |
| --- | --- | --- |
| Missing required value | `IMPORT_REQUIRED_VALUE` | `Sheet {sheet}, row {row}, column {column}: value is required.` |
| Unknown project | `IMPORT_UNKNOWN_PROJECT` | `Sheet {sheet}, row {row}: Project Code '{value}' does not exist.` |
| Duplicate WBS code | `IMPORT_DUPLICATE_WBS` | `Sheet {sheet}, row {row}: WBS Code '{value}' is duplicated within project '{project_code}'.` |
| Duplicate item code | `IMPORT_DUPLICATE_ITEM` | `Sheet {sheet}, row {row}: Item Code '{value}' is duplicated within project '{project_code}'.` |
| Unknown parent WBS | `IMPORT_UNKNOWN_PARENT_WBS` | `Sheet {sheet}, row {row}: Parent WBS '{value}' was not found in project '{project_code}'.` |
| Unknown parent item | `IMPORT_UNKNOWN_PARENT_ITEM` | `Sheet {sheet}, row {row}: Parent Item Code '{value}' was not found in project '{project_code}'.` |
| Invalid hierarchy | `IMPORT_INVALID_HIERARCHY` | `Sheet {sheet}, row {row}: Item Type '{item_type}' cannot be placed under parent type '{parent_type}'.` |
| Unknown person | `IMPORT_UNKNOWN_PERSON` | `Sheet {sheet}, row {row}, column {column}: Person ID '{value}' does not exist in People Master.` |
| Person not in project | `IMPORT_PERSON_NOT_PROJECT_MEMBER` | `Sheet {sheet}, row {row}: Person ID '{value}' is not a member of project '{project_code}'.` |
| Invalid role | `IMPORT_INVALID_ROLE` | `Sheet {sheet}, row {row}: Role '{value}' is not allowed.` |
| Invalid date | `IMPORT_INVALID_DATE` | `Sheet {sheet}, row {row}, column {column}: date must use YYYY-MM-DD.` |
| Due date before start date | `IMPORT_INVALID_DATE_RANGE` | `Sheet {sheet}, row {row}: Due Date must be equal to or later than Start Date.` |
| Invalid status | `IMPORT_INVALID_STATUS` | `Sheet {sheet}, row {row}: Status '{value}' is not allowed.` |
| Invalid weight | `IMPORT_INVALID_WEIGHT` | `Sheet {sheet}, row {row}: Weight must be a number from 0 to 100.` |
| Invalid progress | `IMPORT_INVALID_PROGRESS` | `Sheet {sheet}, row {row}: Progress must be a number from 0 to 100.` |
| Done without full progress | `IMPORT_DONE_PROGRESS_REQUIRED` | `Sheet {sheet}, row {row}: Status Done requires Progress 100.` |
| Invalid evidence flag | `IMPORT_INVALID_EVIDENCE_REQUIRED` | `Sheet {sheet}, row {row}: Evidence Required must be TRUE or FALSE.` |
| Circular reference | `IMPORT_CIRCULAR_REFERENCE` | `Sheet {sheet}, row {row}: parent-child hierarchy contains a circular reference.` |

## Import Behavior

- Import runs in validation mode first and returns all row-level errors.
- No records are saved when validation errors exist.
- If the same `WBS Code` or `Item Code` already exists, MVP behavior must be decided by PM: reject, update, or preview-and-confirm.
- Imported changes must create Audit Log records for created or updated WBS, Task, and Assignment records.
- Evidence files are not uploaded by this import. `Evidence Required` only marks future evidence obligation.

## Open PM Decisions

- Confirm whether `Weight` must total 100 per Project, WBS, or Main Task.
- Confirm whether existing tasks can be updated by import or only created.
- Confirm whether Task without Main Task parent is allowed for RRMS.
- Confirm final allowed values for Role and Status.
