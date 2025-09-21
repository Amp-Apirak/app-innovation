# Project Analysis: PMS (Project Management System)

## 1. Project Overview

This project is a web-based **Project Management System (PMS)**, seemingly designed for internal ticket and task management. It allows users to create, view, update, and delete tasks (referred to as "work" or "tickets"). The system includes user authentication, a dashboard with analytics, and detailed views for each task. It also features a notification system that sends updates to LINE Messenger.

**Core Technologies:**
- **Backend:** PHP
- **Database:** MySQL (MariaDB)
- **Frontend:** HTML, CSS, JavaScript (jQuery, Bootstrap)
- **Charting:** Google Charts
- **Notifications:** LINE Notify API

## 2. Database Schema (`db_pms`)

The database is the core of the application, storing all information related to tasks, users, and system categories.

**Key Tables:**

- **`work`**: The main table for tasks or tickets. It stores all details about a task.
    - `work_id`: Primary Key
    - `project_name`, `work_type`, `service`, `category`, `items`: Classifications for the task.
    - `subject`, `detail`: The title and description of the task.
    - `status`: The current state of the task (e.g., `On Process`, `Done`, `Pending`).
    - `requester`, `staff_crt`, `staff_edit`: Users associated with the task (Owner, Creator, Editor).
    - `date_crt`, `date_edit`: Timestamps for creation and last update.
    - `file_im1`, `file_im2`, `file_im3`, `file_im4`: Paths to uploaded images related to the task.
    - `file_test`: Path to an image uploaded as proof of testing/completion.

- **`contact`**: Acts as the user table.
    - `contact_id`: Primary Key
    - `contact_name`: User's display name.
    - `username`, `password`: Credentials for login.
    - `role`: User role (e.g., 'a' for QC, 'b' for Dev, 'c' for Tester), which dictates permissions.

- **`tb_log`**: A log table that records the history of updates for each task in the `work` table.
    - `log_id`: Primary Key
    - `work_id`: Foreign key linking to the `work` table.
    - `v_status`, `add_task`, `staff_edit`, `date_edit`: Stores the status, comment, editor, and timestamp for each update.

- **`category`, `service`, `items`, `device`**: Lookup tables that provide options for dropdown menus in the task creation/editing forms. This allows for dynamic management of task classifications.

- **Other Tables (`tickets`, `projects`, `users`, etc.)**: The `db_pms.sql` file contains a much more extensive and normalized schema for a full-featured helpdesk system (including SLA policies, ticket activities, attachments). However, the current PHP code primarily interacts with the `work`, `contact`, and `tb_log` tables. The more complex schema seems to be either for a future version or a different, more advanced system.

## 3. File Breakdown & Application Flow

The application logic is spread across several PHP files in the root directory.

- **`connection/connection.php`**:
  - Establishes the connection to the `db_pms` MySQL database using `mysqli`.
  - Sets character encoding to `utf8`.

- **`login.php` & `templated/cklogin.php`**:
  - `login.php` presents a form where users select their name from a dropdown populated from the `contact` table.
  - It submits the `username` and a hardcoded password (`12345678`) to `cklogin.php`, which handles session creation and authentication.

- **`logout.php`**:
  - Destroys the user session and redirects to `login.php`.

- **`index.php` (Main Task List)**:
  - The main page after login, displaying a filterable and searchable table of all tasks from the `work` table.
  - Shows key information like status, subject, owner, and dates.
  - Provides action buttons to **edit** or **delete** a task.
  - Displays KPI cards at the top, counting tasks by status (`On Process`, `Done`, `Approve`, etc.).
  - Includes modals for viewing attached images.

- **`dash.php` (Dashboard)**:
  - Provides a visual overview of the project status.
  - Displays KPI cards similar to `index.php`.
  - Renders several Google Charts (Pie and Bar charts) to visualize:
    - Ticket status distribution.
    - Tickets per technician (`staff_crt`).
    - Tickets by category (`work_type`).
    - Tickets by owner (`requester`).

- **`add.php` & `add1.php` (Create Task)**:
  - `add.php` provides a form to create a new task. Dropdowns for `Service`, `Category`, `Items`, `Device`, and `Owner` are populated from their respective database tables.
  - The form allows uploading up to 4 images.
  - The form is submitted to `add1.php`, which:
    - Processes the form data and moves uploaded files to the `example/` directory.
    - Inserts a new record into the `work` table.
    - Sends a notification to a LINE group using the LINE Notify API, summarizing the new ticket.

- **`edit.php` (Update Task)**:
  - A form to update an existing task, pre-filled with data from the `work` table based on the `work_id` from the URL.
  - Allows changing all task fields, including status, owner, and details.
  - Allows uploading a "Test Image" (`file_test`), which is saved to the `test/` directory.
  - Upon submission, it:
    1.  Updates the corresponding record in the `work` table.
    2.  Inserts a new record into `tb_log` to capture the update history (comment, new status, editor, timestamp).
    3.  Sends a LINE notification summarizing the update.

- **`view.php` (View Task Details)**:
  - Displays a detailed, read-only view of a single task.
  - Shows all project details from the `work` table.
  - Below the main details, it displays a history of all updates for that task by querying the `tb_log` table.

- **`del.php` & `view_del.php` (Delete Logic)**:
  - `del.php` deletes a task from the `work` table based on the `work_id`.
  - `view_del.php` appears to be for deleting a log entry from the `tb_log` table.

- **`templated/` directory**:
  - Contains reusable PHP files for the page layout:
    - `head.php`: Includes all necessary CSS and meta tags.
    - `menu.php`: The main navigation sidebar and top bar, which checks the user's session and role.
    - `footer.php`: The page footer and inclusion of common JavaScript files.

- **`sql_table.md`**:
  - A markdown file containing a detailed, well-structured proposal for a more advanced ticket management database schema. This schema is more normalized and robust than the one currently implemented in the PHP code. It's a valuable reference for future development.
