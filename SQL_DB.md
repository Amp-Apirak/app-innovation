# Ticket Innovation — Database Schema Documentation (SQL_DB.md)

> ระบบจัดการ Ticket สำหรับทีมภายใน — ออกแบบให้รองรับการเปิดงาน/ปิดงาน มอบหมายงาน แสดงไทม์ไลน์ กำหนด SLA และรายงานสถานะได้อย่างครบถ้วน

---

## ภาพรวมสถาปัตยกรรมข้อมูล
- ฐานข้อมูล: **ticket_innovation**
- เอนจินตาราง: **InnoDB**
- Charset/Collation: **utf8mb4 / utf8mb4_unicode_ci**
- หลักการสำคัญ
  - ใช้ **Foreign Key** ครบถ้วนเพื่อคง **Referential Integrity**
  - ใช้ **Timestamp** (`created_at`, `updated_at`) ทุกตารางที่มีการเปลี่ยนแปลงบ่อย
  - จัดหมวดหมู่ **3 ชั้น**: Category → Service Category → Subcategory
  - บันทึก **Time Line** ผ่าน `ticket_activities` และเก็บประวัติที่ต้องอ้างอิงย้อนกลับได้ (`ticket_status_history`, `ticket_assignments`)
  - รองรับ **SLA** ผ่าน `sla_policies` และ **ตัวชี้วัด** `ticket_sla_metrics`
  - มี **Triggers** ช่วยลงไทม์ไลน์/สถานะ/ตัวชี้วัด SLA อัตโนมัติ

---

## รายชื่อตารางและวัตถุประสงค์

### 1) `users`
**วัตถุประสงค์:** เก็บข้อมูลผู้ใช้งานในระบบ (พนักงาน/แอดมิน)  
**ฟิลด์เด่น:**
- `id` PK, AUTO_INCREMENT
- `username` (UNIQUE), `password` (hash), `email` (UNIQUE), `full_name`
- ข้อมูลงาน: `role` (`admin|staff|user`), `position`, `department`, `organization`, `profile` (path/URL รูป)
- ตราประทับเวลา: `created_at`, `updated_at`

**เหตุผลการออกแบบ:** ตารางแม่ของผู้ใช้อื่น ๆ (เชื่อมกับ tickets, comments, activities, assignments ฯลฯ)

---

### 2) `projects`
**วัตถุประสงค์:** เก็บโครงการที่ Ticket ผูกอยู่  
**ฟิลด์เด่น:** `name` (UNIQUE), `status` (`active|completed|on_hold`), `created_by` (FK → users.id), `owner_id` (FK → users.id)  
**FK & เงื่อนไข:**  
- `fk_projects_created_by` → ON DELETE RESTRICT (ห้ามลบผู้ใช้ถ้ามีโปรเจกต์ยังใช้)  
- `fk_projects_owner` → ON DELETE SET NULL (หากเจ้าของลาออกจะไม่ลบโปรเจกต์)  

---

### 3) `ticket_statuses`
**วัตถุประสงค์:** รายการสถานะของ Ticket  
**ตัวอย่างค่าเริ่มต้น:** On Process, Pending, Resolved, Closed, Reopened  
**ชนิด:** `id` เป็น `TINYINT` ประหยัดพื้นที่  
**หมายเหตุ:** สถานะเริ่มต้นของ Ticket คือ **On Process**

---

### 4) `ticket_types`
**วัตถุประสงค์:** ประเภทของ Ticket  
**ตัวอย่างค่าเริ่มต้น:** Incident, Service, Change  
**ชนิด:** `id` เป็น `TINYINT`

---

### 5) `ticket_priorities`
**วัตถุประสงค์:** ระดับความสำคัญของ Ticket  
**ฟิลด์เด่น:** `name` (UNIQUE), `weight` (เรียงความสำคัญ), `color`, `is_default`  
**ตัวอย่างค่าเริ่มต้น:** Low, Normal (default), High, Urgent, Critical

---

### 6) `ticket_categories`
**วัตถุประสงค์:** หมวดหมู่หลักของงาน (เช่น Hardware, Software, Network)  
**ฟิลด์เด่น:** `name` (UNIQUE), `created_by` (FK → users.id)

### 7) `ticket_service_categories`
**วัตถุประสงค์:** ชั้นกลางของหมวดหมู่ (บริการ) อยู่ใต้ Category  
**ฟิลด์เด่น:** `(category_id, name)` (UNIQUE ต่อ Category)  
**FK:** `category_id` → `ticket_categories.id` (CASCADE) ; `created_by` → users.id

### 8) `ticket_subcategories`
**วัตถุประสงค์:** ชั้นย่อยสุดท้าย อยู่ใต้ Service Category  
**ฟิลด์เด่น:** `(service_category_id, name)` (UNIQUE ต่อ Service Category)  
**FK:** `service_category_id` → `ticket_service_categories.id` (CASCADE) ; `created_by` → users.id

> **เหตุผล 3 ชั้น:** ช่วยจัดกลุ่มงานแบบยืดหยุ่น รายงานได้ละเอียด และค้นหาได้แม่นยำ

---

### 9) `tags` และ 10) `ticket_tags`
**วัตถุประสงค์:** ระบบแท็ก/เลเบลของ Ticket  
- `tags` เก็บรายการแท็ก (PK `id`, `name` UNIQUE)  
- `ticket_tags` ผูกแท็กกับ Ticket (PK ผสม `(ticket_id, tag_id)`)  
**FK & เงื่อนไข:** ลบ Ticket/Tag จะลบความเชื่อมโยงตาม (CASCADE) ; `added_by` อ้างอิงผู้กระทำ

---

### 11) `tickets` (ตารางหลัก)
**วัตถุประสงค์:** เก็บ Ticket แต่ละใบ
**โครงสร้างหลัก:**
- FK ไปยัง: `projects`, `ticket_types`, `ticket_priorities`, `ticket_statuses`
- หมวดหมู่ 3 ชั้น: `category_id` → `ticket_categories`, `service_category_id` → `ticket_service_categories`, `subcategory_id` → `ticket_subcategories` (ลบแล้ว SET NULL)
- SLA: `sla_policy_id` → `sla_policies` (SET NULL เพื่อเก็บ Snapshot SLA ใน metrics)
- เนื้อหา: `subject`, `details`
- ผู้เกี่ยวข้อง: `created_by` (RESTRICT), `updated_by` (SET NULL), `assigned_to` (SET NULL)
- เวลา: `due_at`, `resolved_at`, `closed_at`, `created_at`, `updated_at`

**ดัชนีแนะนำ:**  
`(project_id, status_id)`, `assigned_to`, `created_by`, `created_at`, `(due_at, status_id)`

**เหตุผลการออกแบบ:** ให้ Ticket เชื่อมทุกองค์ประกอบ และรองรับรายงาน/หน้า List อย่างมีประสิทธิภาพ

---

### 12) `ticket_comments`
**วัตถุประสงค์:** เก็บคอมเมนต์ใน Ticket  
**ฟิลด์เด่น:** `content`, `is_internal` (คอมเมนต์ภายในทีมเท่านั้น)  
**FK:** `ticket_id` (CASCADE), `author_id` (RESTRICT)

---

### 13) `ticket_attachments`
**วัตถุประสงค์:** เก็บไฟล์แนบของ Ticket (ชื่อไฟล์, path/URL, MIME type, ขนาด)  
**FK:** `ticket_id` (CASCADE), `uploader_id` (RESTRICT)

---

### 14) `ticket_status_history`
**วัตถุประสงค์:** เก็บประวัติการเปลี่ยนสถานะ (old → new โดยใคร เมื่อไร)  
**FK:** `ticket_id` (CASCADE), `old_status` (SET NULL), `new_status` (RESTRICT), `changed_by` (RESTRICT)  
**ดัชนี:** `(ticket_id, changed_at)`, `(changed_by, changed_at)`

---

### 15) `ticket_assignments`
**วัตถุประสงค์:** เก็บประวัติการมอบหมายแบบมีช่วงเวลา (เริ่ม–สิ้นสุด)  
**ตรรกะ:** เมื่อโอนงาน จะปิด `ended_at` ของช่วงก่อน แล้วเปิดช่วงใหม่  
**FK:** `ticket_id` (CASCADE), `assignee_id`/`assigned_by` (RESTRICT)  
**ดัชนี:** `(ticket_id, ended_at)` เพื่อหา assignment ปัจจุบัน (NULL) ได้เร็ว

---

### 16) `ticket_activities` (Time Line)
**วัตถุประสงค์:** บันทึกกิจกรรมทั้งหมดของ Ticket เพื่อแสดงไทม์ไลน์  
**action:** `create | update | assign | status_change | comment | attach | close | reopen`  
**รายละเอียด:** เก็บ `from_value`, `to_value`, `note`, `actor_id`, `created_at`  
**FK:** `ticket_id` (CASCADE), `actor_id` (RESTRICT)  
**ดัชนี:** `(ticket_id, created_at)`, `(actor_id, created_at)`

---

### 17) `ticket_watchers`
**วัตถุประสงค์:** เก็บผู้ติดตาม Ticket (คนที่ต้องการรับแจ้งเตือน)  
**PK:** `(ticket_id, user_id)` ป้องกันซ้ำ  
**FK:** `ticket_id` / `user_id` (CASCADE) — ลบชิ้นใดชิ้นหนึ่ง ความเชื่อมโยงหายตาม

---

### 18) `sla_policies`
**วัตถุประสงค์:** นิยาม SLA (เวลาตอบครั้งแรก/แก้เสร็จใน “นาที”)  
**ฟิลด์เด่น:** `first_response_mins`, `resolve_mins`

---

### 19) `ticket_sla_metrics`
**วัตถุประสงค์:** เก็บตัวชี้วัด SLA ของ Ticket (Snapshot เส้นตายและเวลาที่ทำจริง)  
**ฟิลด์เด่น:**
- เส้นตาย: `first_response_due_at`, `resolve_due_at` (คำนวณจาก SLA ตอนสร้าง Ticket)
- เวลาจริง: `first_response_at`, `resolve_at`
- สถานะละเมิด: `is_first_response_breached`, `is_resolve_breached`
- เวลาใช้จริง (นาที): `first_response_elapsed_mins`, `resolve_elapsed_mins`  
**FK:** `ticket_id` (CASCADE), `sla_policy_id` (SET NULL)  
**ดัชนี:** `ticket_id`, `(resolve_due_at, first_response_due_at)`, `(is_first_response_breached, is_resolve_breached)`

---

## Triggers ที่ใช้งาน

### A) `trg_tickets_after_insert`
**เหตุผล/วัตถุประสงค์:**  
- บันทึก Time Line `create` เมื่อมี Ticket ใหม่  
- ลง `ticket_status_history` (old=NULL → new=สถานะเริ่มต้น)  
- ถ้ามี `assigned_to` ตอนสร้าง → เปิดช่วงใน `ticket_assignments` และบันทึก activity `assign`

### B) `trg_tickets_after_update`
**เหตุผล/วัตถุประสงค์:**  
- จับการเปลี่ยน **สถานะ** → ลง `ticket_status_history` + `ticket_activities` (action=`status_change`)  
- จับการ **โอนงาน/มอบหมายใหม่** → ปิดช่วง assignment เดิม, เปิดช่วงใหม่, ลง activity `assign`  
- จับการ **แก้ไขรายละเอียดสำคัญ** → ลง activity `update`  
- จับการ **ปิดงาน/เปิดงานใหม่** → ลง activity `close`/`reopen`  
**หมายเหตุ:** ใช้ผู้กระทำจาก `@actor_id` หากตั้งไว้, ถ้าไม่มีก็ใช้ `updated_by` → `created_by` ตามลำดับ

### C) `trg_tickets_after_insert_sla`
**เหตุผล/วัตถุประสงค์:**  
- สร้างแถวใน `ticket_sla_metrics` เมื่อสร้าง Ticket ใหม่  
- คำนวณเส้นตาย `first_response_due_at` / `resolve_due_at` จาก SLA ที่กำหนด (หรือ `Default SLA`)

### D) `trg_comments_after_insert_sla`
**เหตุผล/วัตถุประสงค์:**  
- เมื่อมีคอมเมนต์แรกของ Ticket → บันทึก `first_response_at`  
- คำนวณ `first_response_elapsed_mins` และตั้ง `is_first_response_breached` หากเกินกำหนด

### E) `trg_tickets_after_update_sla`
**เหตุผล/วัตถุประสงค์:**  
- เมื่อสถานะเปลี่ยนเป็น **Resolved** หรือมี `resolved_at` → อัปเดต `ticket_sla_metrics.resolve_at`  
- คำนวณ `resolve_elapsed_mins` และ `is_resolve_breached`

> **หมายเหตุ:** ตัวอย่างตั้งสมมติฐานว่า id ของสถานะ Resolved = `3` (สอดคล้องชุด seed) หากต่างไปให้ปรับใน Trigger

---

## ดัชนีสำคัญ (Index) ที่ควรมี
- `tickets(project_id, status_id)` — โหลดรายการตามโปรเจกต์/สถานะ
- `tickets(assigned_to)` — กล่องงานของผู้รับผิดชอบ
- `tickets(created_by)` / `tickets(created_at)` — รายงานงานตามผู้สร้าง/ช่วงเวลา
- `tickets(due_at, status_id)` — ติดตามงานค้าง/ใกล้ครบกำหนด
- `ticket_activities(ticket_id, created_at)` — แสดง Time Line เร็ว
- `ticket_status_history(ticket_id, changed_at)` — เรียกดูประวัติสถานะเร็ว
- `ticket_assignments(ticket_id, ended_at)` — หา assignment ปัจจุบัน (ended_at IS NULL)

---

## ลำดับการสร้างและ Seed ข้อมูล (แนะนำ)
1. `users` → สร้าง admin เริ่มต้น (เช่น `admin/changeme`)  
2. `projects` (เชื่อมกับผู้สร้าง/เจ้าของ)  
3. `ticket_statuses`, `ticket_types`, `ticket_priorities` (seed ค่ามาตรฐาน)  
4. `ticket_categories` → `ticket_service_categories` → `ticket_subcategories` (seed ตามตัวอย่าง)  
5. `sla_policies` (สร้าง Default/Urgent)  
6. `tags` (ถ้าต้องการ)  
7. `tickets` + ตารางประกอบ (`comments`, `attachments`, `status_history`, `assignments`, `activities`, `watchers`, `ticket_tags`, `ticket_sla_metrics`)  
8. ติดตั้ง **Triggers** ทั้งหมด

> ขณะ seed: ค่าที่เป็น FK (เช่น `created_by`) ต้องอ้างอิง `users.id` ที่มีอยู่จริง

---

## แนวทางทดสอบระบบ
- สร้าง Ticket ใหม่ที่กำหนด `assigned_to` และมี `sla_policy_id`  
  - ควรเห็นแถวใน `ticket_activities` (create/assign) และ `ticket_status_history` (สถานะเริ่มต้น)  
  - ควรเห็นแถวใน `ticket_sla_metrics` พร้อมเส้นตายที่คำนวณแล้ว  
- เพิ่มคอมเมนต์แรก → `first_response_at` ต้องถูกตั้ง และประเมิน breached ถูกต้อง  
- เปลี่ยนสถานะเป็น Resolved → `resolved_at` ต้องถูกตั้ง และ SLA resolve ถูกคำนวณ  
- โอนงาน → assignment เก่าถูกปิด (`ended_at`), assignment ใหม่ถูกเปิด

---

## หมายเหตุด้านความปลอดภัยและประสิทธิภาพ
- เก็บ `password` แบบ **hash** (เช่น bcrypt/argon2) — ห้ามเก็บ plain text
- เลี่ยงเก็บไฟล์จริงใน DB; เก็บ **path/URL** ใน `ticket_attachments.file_path`
- ใช้ **Transaction** ครอบหลายคำสั่งที่เกี่ยวเนื่องกัน (เช่น อัปเดต ticket + assignments + activities)
- ตรวจสอบ/ sanitize input ก่อนบันทึก (SQL Injection, XSS ผ่านคอมเมนต์/รายละเอียด)
- สำรองข้อมูล/มี migration script ทุกครั้งที่ปรับ schema

---

## ผังความเชื่อมโยง (ย่อ)
- `tickets` → `users` (created_by, updated_by, assigned_to)  
- `tickets` → `projects`, `ticket_types`, `ticket_priorities`, `ticket_statuses`  
- `tickets` → `ticket_categories` → `ticket_service_categories` → `ticket_subcategories`  
- `ticket_comments`, `ticket_attachments`, `ticket_activities`, `ticket_assignments`, `ticket_status_history`, `ticket_watchers`, `ticket_tags`, `ticket_sla_metrics` → **FK ไปที่** `tickets`  
- `ticket_tags` → `tags`  
- `ticket_sla_metrics` → `sla_policies`

---

> เอกสารนี้สรุปสคีมาและกติกาทั้งหมดสำหรับระบบ Ticket Innovation เพื่อใช้เป็นอ้างอิงในการพัฒนา API/Backend, Frontend และคู่มือทีมปฏิบัติการ
