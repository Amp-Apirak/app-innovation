# SQL Tables for Ticket Management (Summary & DDL)

เอกสารนี้สรุปสิ่งที่ผมแนะนำในการออกแบบ **ตารางทั้งหมดที่เกี่ยวกับ Ticket** พร้อมสคริปต์สร้างตาราง (DDL) และตัวอย่างข้อมูลตั้งต้น (Seed) เพื่อให้คุณนำไปใช้งานต่อได้ทันทีกับ MySQL (แนะนำ 8.0+).  
ค่าเริ่มต้นใช้ **ENGINE=InnoDB** และ **utf8mb4**

> โครงสร้างอ้างอิงจากหน้าจอและความต้องการของคุณ: ใช้ตารางหลัก `ticket` และตารางอ้างอิง (lookup) สำหรับ `status`, `priority`, `type`, `category`, `subcategory`, `project`, `sla_policy`, `users`


---

## 1) แผนผังความสัมพันธ์ (ย่อ)

```
users (id) ─┬──< ticket.created_by
            └──< ticket.assigned_to

projects (id) ──< ticket.project_id

ticket_types (id) ──< ticket.type_id

ticket_categories (id) ──< ticket.category_id ──< ticket_subcategories (category_id)
ticket_subcategories (id) ──< ticket.subcategory_id

ticket_statuses (id) ──< ticket.status_id
ticket_priorities (id) ──< ticket.priority_id

sla_policies (id) ──< ticket.sla_policy_id
```

> หมายเหตุ: `id` ของ statuses/priorities กำหนดตาม mapping ด้านล่าง เพื่อให้ใช้งานกับการ์ด KPI ได้สะดวก


---

## 2) สร้างฐานข้อมูล (ถ้ายังไม่มี)

```sql
CREATE DATABASE IF NOT EXISTS `db_pms`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `db_pms`;
```


---

## 3) ตารางอ้างอิง (Lookup Tables)

### 3.1 ผู้ใช้ (อย่างย่อสำหรับ FK)
> ถ้าคุณมีตารางผู้ใช้อยู่แล้ว ให้ข้ามส่วนนี้

```sql
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(64) NOT NULL,
  `display_name` VARCHAR(128) NULL,
  `email` VARCHAR(191) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.2 โครงการ
```sql
CREATE TABLE IF NOT EXISTS `projects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(191) NOT NULL,
  `description` TEXT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 ประเภท Ticket
```sql
CREATE TABLE IF NOT EXISTS `ticket_types` (
  `id` TINYINT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.4 หมวดหมู่ / หมวดหมู่ย่อย
```sql
CREATE TABLE IF NOT EXISTS `ticket_categories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ticket_subcategories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_subcat_category_idx` (`category_id`),
  CONSTRAINT `fk_subcat_category` FOREIGN KEY (`category_id`)
    REFERENCES `ticket_categories` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.5 สถานะ & ความสำคัญ (Mapping ที่ใช้กับการ์ด KPI)
```sql
CREATE TABLE IF NOT EXISTS `ticket_statuses` (
  `id` TINYINT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `ticket_priorities` (
  `id` TINYINT UNSIGNED NOT NULL,
  `name` VARCHAR(32) NOT NULL,
  `weight` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> **Mapping สถานะที่ใช้**:  
> 1 = On Process, 2 = Pending, 3 = Approve, 4 = Done, 5 = Cancel  
> **Mapping ความสำคัญ**:  
> 1 = Low, 2 = Normal, 3 = High


### 3.6 นโยบาย SLA
```sql
CREATE TABLE IF NOT EXISTS `sla_policies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `response_time_minutes` INT UNSIGNED NULL,
  `resolution_time_minutes` INT UNSIGNED NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```


---

## 4) ตารางหลัก: `ticket` (อิงจากหน้าจอของคุณ)

```sql
CREATE TABLE IF NOT EXISTS `ticket` (
  `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `project_id` BIGINT(20) UNSIGNED NULL,
  `type_id` TINYINT(3) UNSIGNED NOT NULL,
  `category_id` BIGINT(20) UNSIGNED NULL,
  `subcategory_id` BIGINT(20) UNSIGNED NULL,

  `subject` VARCHAR(255) NOT NULL,
  `details` TEXT NOT NULL,

  `status_id` TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,   -- 1=On Process
  `priority_id` TINYINT(3) UNSIGNED NOT NULL DEFAULT 2, -- 2=Normal

  `sla_policy_id` BIGINT(20) UNSIGNED NULL,

  `created_by` BIGINT(20) UNSIGNED NOT NULL,
  `assigned_to` BIGINT(20) UNSIGNED NULL,

  `due_at` DATETIME NULL,
  `resolved_at` DATETIME NULL,
  `closed_at` DATETIME NULL,

  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),

  KEY `fk_tickets_type` (`type_id`),
  KEY `fk_tickets_category` (`category_id`),
  KEY `fk_tickets_subcategory` (`subcategory_id`),
  KEY `idx_tickets_status` (`status_id`),
  KEY `idx_tickets_priority` (`priority_id`),
  KEY `idx_tickets_assigned` (`assigned_to`),
  KEY `idx_tickets_created_by` (`created_by`),
  KEY `idx_tickets_due` (`due_at`),

  CONSTRAINT `fk_tickets_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_tickets_type2` FOREIGN KEY (`type_id`) REFERENCES `ticket_types` (`id`),
  CONSTRAINT `fk_tickets_category2` FOREIGN KEY (`category_id`) REFERENCES `ticket_categories` (`id`),
  CONSTRAINT `fk_tickets_subcategory2` FOREIGN KEY (`subcategory_id`) REFERENCES `ticket_subcategories` (`id`),
  CONSTRAINT `fk_tickets_status2` FOREIGN KEY (`status_id`) REFERENCES `ticket_statuses` (`id`),
  CONSTRAINT `fk_tickets_priority2` FOREIGN KEY (`priority_id`) REFERENCES `ticket_priorities` (`id`),
  CONSTRAINT `fk_tickets_sla` FOREIGN KEY (`sla_policy_id`) REFERENCES `sla_policies` (`id`),
  CONSTRAINT `fk_tickets_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_tickets_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

> โครงสร้างนี้ตรงกับรูป screenshot ของคุณ โดยใช้ `id` เป็น AUTO_INCREMENT และคอลัมน์อื่น ๆ ตามภาพ


---

## 5) ข้อมูลตั้งต้น (Seed)

### 5.1 ค่าอ้างอิง
```sql
-- ประเภท
INSERT INTO `ticket_types` (`id`,`name`) VALUES
(1,'Incident'),(2,'Request')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- สถานะ
INSERT INTO `ticket_statuses` (`id`,`name`) VALUES
(1,'On Process'),(2,'Pending'),(3,'Approve'),(4,'Done'),(5,'Cancel')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- ความสำคัญ
INSERT INTO `ticket_priorities` (`id`,`name`,`weight`) VALUES
(1,'Low',1),(2,'Normal',2),(3,'High',3)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`weight`=VALUES(`weight`);

-- ตัวอย่าง Category/Subcategory
INSERT INTO `ticket_categories` (`name`) VALUES ('Application'),('Network'),('Hardware')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- subcategory จะอิง id ของ category ที่เพิ่งสร้าง (ตัวอย่างง่าย ๆ)
-- สมมติ: 1=Application, 2=Network, 3=Hardware
INSERT INTO `ticket_subcategories` (`category_id`,`name`) VALUES
(1,'Bug'),(1,'Feature'),(2,'Access'),(3,'Repair')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- ตัวอย่างผู้ใช้/โครงการ (ถ้ายังไม่มี)
INSERT INTO `users` (`username`,`display_name`,`email`) VALUES
('user1','คุณผู้ใช้หนึ่ง','user1@example.com'),
('user2','คุณผู้ใช้สอง','user2@example.com'),
('devA','Dev A','deva@example.com'),
('devB','Dev B','devb@example.com')
ON DUPLICATE KEY UPDATE `display_name`=VALUES(`display_name`),`email`=VALUES(`email`);

INSERT INTO `projects` (`name`,`description`) VALUES
('PMS Management','ระบบจัดการ Ticket/Job'),
('Intranet','ระบบภายในองค์กร')
ON DUPLICATE KEY UPDATE `description`=VALUES(`description`);

INSERT INTO `sla_policies` (`name`,`response_time_minutes`,`resolution_time_minutes`) VALUES
('Standard',240,2880), -- ตอบกลับภายใน 4 ชม. แก้ไขภายใน 48 ชม.
('Urgent',60,480)
ON DUPLICATE KEY UPDATE `response_time_minutes`=VALUES(`response_time_minutes`),
                        `resolution_time_minutes`=VALUES(`resolution_time_minutes`);
```

### 5.2 ตัวอย่างข้อมูล `ticket` (10 แถว)  
> **ปรับ `created_by` / `assigned_to` / `project_id` ตาม id ที่มีจริงในระบบของคุณ**

```sql
INSERT INTO `ticket`
(`project_id`,`type_id`,`category_id`,`subcategory_id`,
 `subject`,`details`,
 `status_id`,`priority_id`,`sla_policy_id`,
 `created_by`,`assigned_to`,
 `due_at`,`resolved_at`,`closed_at`)
VALUES
(1,1,1,1,'ทดสอบเปิดงาน #001','ทดสอบระบบและเก็บ log',               1,2,1,1,2,DATE_ADD(NOW(), INTERVAL 2 DAY),NULL,NULL),
(1,1,1,2,'คิวรอติดตั้งอุปกรณ์','รออะไหล่มาถึง',                      2,2,1,1,NULL,DATE_ADD(NOW(), INTERVAL 3 DAY),NULL,NULL),
(1,2,1,2,'คำขอเพิ่มสิทธิ์เมนู','เปิดเมนู Test Case ให้ทีม QA',         3,1,1,2,4,DATE_ADD(NOW(), INTERVAL 1 DAY),NULL,NULL),
(1,1,1,1,'บั๊กหน้า Dashboard','แก้ปัญหาโหลดช้า',                       4,3,1,1,3,NULL,DATE_SUB(NOW(), INTERVAL 10 MINUTE),NOW()),
(2,2,1,2,'ยกเลิกคำขอรายงาน','ผู้ใช้ยกเลิกคำขอ',                         5,1,1,3,NULL,NULL,NULL,NOW()),
(1,1,2,3,'Hotfix การแจ้งเตือน','อีเมลไม่ส่งใน production',               1,3,2,1,2,DATE_ADD(NOW(), INTERVAL 12 HOUR),NULL,NULL),
(1,1,1,2,'ปรับปรุง UI สีการ์ด','ปรับ CI ให้ตรงคู่มือ',                  1,2,1,2,NULL,DATE_ADD(NOW(), INTERVAL 1 DAY),NULL,NULL),
(2,2,2,3,'นัดอบรมผู้ใช้','จัดอบรมเบื้องต้น',                            2,1,1,2,3,DATE_ADD(NOW(), INTERVAL 5 DAY),NULL,NULL),
(1,2,1,2,'รออนุมัติแผนงาน','ส่งแผนงานให้หัวหน้าพิจารณา',               3,2,1,1,4,DATE_ADD(NOW(), INTERVAL 2 DAY),NULL,NULL),
(1,1,1,1,'ปิดงานตรวจสอบ Log','ปิดงานเรียบร้อย',                         4,2,2,1,2,NULL,DATE_SUB(NOW(), INTERVAL 1 HOUR),NOW());
```


---

## 6) ตัวอย่าง Query สำหรับการ์ด KPI (นับจำนวน)

```sql
-- รวมทั้งหมด
SELECT COUNT(t.id) AS total_all
FROM ticket t;

-- On Process
SELECT COUNT(t.id) AS total_onprocess
FROM ticket t
WHERE t.status_id = 1;

-- Pending
SELECT COUNT(t.id) AS total_pending
FROM ticket t
WHERE t.status_id = 2;

-- Approve
SELECT COUNT(t.id) AS total_approve
FROM ticket t
WHERE t.status_id = 3;

-- Done
SELECT COUNT(t.id) AS total_done
FROM ticket t
WHERE t.status_id = 4;

-- Cancel
SELECT COUNT(t.id) AS total_cancel
FROM ticket t
WHERE t.status_id = 5;
```

> ถ้าหน้าค้นหาของคุณมีตัวแปรเงื่อนไข (เช่น `$_where`) ให้เติมเงื่อนไขต่อท้าย `WHERE` ได้ตามต้องการ เช่น `... WHERE t.status_id=1 AND ${เงื่อนไขกรอง}`

---

## 7) แนวทางใช้งาน & ข้อควรระวัง
- สร้าง lookup tables และ seed ค่าอ้างอิงก่อน เพื่อเลี่ยง FK ผิดพลาดตอน insert ticket
- แนะนำให้ใช้ **prepared statements** (mysqli หรือ PDO) ทุกครั้งเมื่อ insert/update
- ควรกำหนด **index** เพิ่มเติมถ้าต้องค้นหาตาม `subject`, `created_at`, `project_id` บ่อย ๆ
- `resolved_at` และ `closed_at` ให้บันทึกเมื่อสถานะเปลี่ยนเป็น Done/Cancel ตาม workflow จริง
- หากย้ายจากตารางเดิม `work` -> `ticket` ให้ map คีย์และสถานะตามตารางสถานะใหม่ (numeric id) เพื่อให้ query เร็วขึ้นและสอดคล้องกับการ์ด KPI

---

## 8) ลำดับการรันสคริปต์ (แนะนำ)
1. สร้าง DB และตาราง lookup ทั้งหมด (ข้อ 2–3)  
2. สร้างตารางหลัก `ticket` (ข้อ 4)  
3. ใส่ seed lookup (สถานะ/ความสำคัญ/ประเภท/หมวดหมู่/ผู้ใช้/โครงการ/SLA) (ข้อ 5.1)  
4. ใส่ตัวอย่าง ticket (ข้อ 5.2)  
5. ใช้ query การ์ด KPI (ข้อ 6) บนหน้า dashboard

---

> เอกสารนี้ครอบคลุม **DDL + Seed + ตัวอย่าง Query** ตามที่เราคุยกัน เพื่อให้คุณนำไปใช้งานและต่อยอดในระบบ PMS Management ได้ทันที
