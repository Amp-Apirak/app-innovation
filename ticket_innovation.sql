-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 21, 2025 at 05:56 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ticket_innovation`
--

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสโครงการ (Primary Key)',
  `name` varchar(150) NOT NULL COMMENT 'ชื่อโครงการ เช่น ระบบ IT Helpdesk, ระบบ ERP',
  `description` text DEFAULT NULL COMMENT 'รายละเอียดโครงการ',
  `start_date` date DEFAULT NULL COMMENT 'วันเริ่มต้นโครงการ',
  `end_date` date DEFAULT NULL COMMENT 'วันสิ้นสุดโครงการ',
  `status` enum('active','completed','on_hold') DEFAULT 'active' COMMENT 'สถานะโครงการ',
  `created_by` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสผู้ใช้งานที่สร้างโครงการ อ้างอิง users.id',
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'รหัสผู้ใช้งานที่เป็นเจ้าของ/ผู้รับผิดชอบหลักของโครงการ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sla_policies`
--

CREATE TABLE `sla_policies` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัส SLA (Primary Key)',
  `name` varchar(100) NOT NULL COMMENT 'ชื่อ SLA เช่น Default SLA, Urgent SLA',
  `first_response_mins` int(10) UNSIGNED NOT NULL COMMENT 'เวลาที่ต้องตอบครั้งแรก (นาที)',
  `resolve_mins` int(10) UNSIGNED NOT NULL COMMENT 'เวลาที่ต้องแก้ไขเสร็จ (นาที)',
  `description` varchar(255) DEFAULT NULL COMMENT 'คำอธิบาย SLA',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้าง',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่แก้ไขล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sla_policies`
--

INSERT INTO `sla_policies` (`id`, `name`, `first_response_mins`, `resolve_mins`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Default SLA', 60, 1440, 'ตอบกลับใน 1 ชั่วโมง แก้ไขภายใน 24 ชั่วโมง', '2025-09-21 22:21:10', '2025-09-21 22:21:10'),
(2, 'Urgent SLA', 15, 240, 'ตอบกลับใน 15 นาที แก้ไขภายใน 4 ชั่วโมง', '2025-09-21 22:21:10', '2025-09-21 22:21:10');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสแท็ก (Primary Key)',
  `name` varchar(50) NOT NULL COMMENT 'ชื่อแท็ก เช่น printer, vpn, security (ไม่ซ้ำ)',
  `color` varchar(20) DEFAULT NULL COMMENT 'สีสำหรับ UI เช่น #RRGGBB หรือชื่อสี',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้าง',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่แก้ไขล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`, `color`, `created_at`, `updated_at`) VALUES
(1, 'printer', '#9E9E9E', '2025-09-21 22:03:19', '2025-09-21 22:03:19'),
(2, 'vpn', '#9E9E9E', '2025-09-21 22:03:19', '2025-09-21 22:03:19'),
(3, 'email', '#9E9E9E', '2025-09-21 22:03:19', '2025-09-21 22:03:19');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัส Ticket (Primary Key)',
  `project_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'อ้างอิงโครงการที่เกี่ยวข้อง (projects.id)',
  `type_id` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'ประเภท Ticket เช่น Incident/Service/Change (ticket_types.id) ค่าเริ่มต้น=Incident',
  `priority_id` tinyint(3) UNSIGNED NOT NULL DEFAULT 2 COMMENT 'ระดับความสำคัญ (ticket_priorities.id) ค่าเริ่มต้น=Normal',
  `status_id` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'สถานะปัจจุบันของ Ticket (ticket_statuses.id) ค่าเริ่มต้น=On Process',
  `category_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'หมวดหมู่หลัก (ticket_categories.id)',
  `service_category_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'หมวดหมู่บริการ (ticket_service_categories.id)',
  `subcategory_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'หมวดหมู่ย่อย (ticket_subcategories.id)',
  `sla_policy_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'นโยบาย SLA ที่ใช้ (sla_policies.id)',
  `subject` varchar(255) NOT NULL COMMENT 'หัวข้อ/สรุปสั้น ๆ ของ Ticket',
  `details` text NOT NULL COMMENT 'รายละเอียดปัญหาหรือคำขอโดยละเอียด',
  `created_by` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้สร้าง Ticket (users.id)',
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ผู้แก้ไขล่าสุด (users.id) ใช้บันทึกผู้กระทำเวลา UPDATE',
  `assigned_to` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ผู้รับผิดชอบปัจจุบัน (users.id)',
  `due_at` datetime DEFAULT NULL COMMENT 'วันครบกำหนดการดำเนินการ (Due Date/Time)',
  `resolved_at` datetime DEFAULT NULL COMMENT 'วันเวลาที่แก้ไขเสร็จ (Resolved)',
  `closed_at` datetime DEFAULT NULL COMMENT 'วันเวลาที่ปิดงาน (Closed)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาเมื่อสร้าง Ticket',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาเมื่อแก้ไข Ticket ล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `tickets`
--
DELIMITER $$
CREATE TRIGGER `trg_tickets_after_insert` AFTER INSERT ON `tickets` FOR EACH ROW BEGIN
  -- 1) กิจกรรม create
  INSERT INTO ticket_activities (ticket_id, actor_id, action, note, created_at)
  VALUES (NEW.id, NEW.created_by, 'create', 'สร้าง Ticket', NOW());

  -- 2) ประวัติสถานะเริ่มต้น (old_status = NULL → new_status = status_id ปัจจุบัน)
  INSERT INTO ticket_status_history (ticket_id, old_status, new_status, changed_by, note, changed_at)
  VALUES (NEW.id, NULL, NEW.status_id, NEW.created_by, 'สถานะเริ่มต้น', NOW());

  -- 3) ถ้ามีการมอบหมายตั้งแต่สร้าง ให้เปิดช่วง assignment แรก
  IF NEW.assigned_to IS NOT NULL THEN
    INSERT INTO ticket_assignments (ticket_id, assignee_id, assigned_by, started_at, note)
    VALUES (NEW.id, NEW.assigned_to, NEW.created_by, NOW(), 'มอบหมายเมื่อสร้าง Ticket');
    
    INSERT INTO ticket_activities (ticket_id, actor_id, action, from_value, to_value, note, created_at)
    VALUES (NEW.id, NEW.created_by, 'assign',
            NULL,
            CONCAT('assignee_id=', NEW.assigned_to),
            'มอบหมายเริ่มต้น', NOW());
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tickets_after_insert_sla` AFTER INSERT ON `tickets` FOR EACH ROW BEGIN
  /* --------------------------------------------
     คำนวณกำหนดเวลาตอบครั้งแรก/แก้เสร็จจาก SLA
     - ถ้ามีระบุ NEW.sla_policy_id จะอิงค่านั้น
     - ถ้าไม่ได้ระบุ ให้ลองหา SLA ชื่อ 'Default SLA'
     -------------------------------------------- */
  DECLARE v_sla_id BIGINT UNSIGNED;
  DECLARE v_first_mins INT UNSIGNED;
  DECLARE v_resolve_mins INT UNSIGNED;

  -- หา SLA ที่จะใช้
  SET v_sla_id = NEW.sla_policy_id;
  IF v_sla_id IS NULL THEN
    SELECT id INTO v_sla_id
    FROM sla_policies
    WHERE name = 'Default SLA'
    LIMIT 1;
  END IF;

  -- ดึงตัวเลข SLA (นาที)
  IF v_sla_id IS NOT NULL THEN
    SELECT first_response_mins, resolve_mins
      INTO v_first_mins, v_resolve_mins
    FROM sla_policies
    WHERE id = v_sla_id;

    -- แทรกแถว metric พร้อมคำนวณเส้นตาย
    INSERT INTO ticket_sla_metrics (
      ticket_id, sla_policy_id,
      first_response_due_at, resolve_due_at
    )
    VALUES (
      NEW.id, v_sla_id,
      DATE_ADD(NEW.created_at, INTERVAL v_first_mins  MINUTE),
      DATE_ADD(NEW.created_at, INTERVAL v_resolve_mins MINUTE)
    );
  ELSE
    -- ไม่มี SLA ให้สร้าง metric เปล่า ๆ ไว้ก่อน
    INSERT INTO ticket_sla_metrics (ticket_id)
    VALUES (NEW.id);
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tickets_after_update` AFTER UPDATE ON `tickets` FOR EACH ROW BEGIN
  DECLARE v_actor BIGINT UNSIGNED;
  -- เลือกผู้กระทำ: ใช้ @actor_id ถ้ามี → ไม่งั้นใช้ updated_by → ไม่งั้น fallback เป็นคนสร้าง
  SET v_actor = COALESCE(@actor_id, NEW.updated_by, NEW.created_by);

  -- 1) เปลี่ยนสถานะ
  IF (OLD.status_id <> NEW.status_id) THEN
    INSERT INTO ticket_status_history (ticket_id, old_status, new_status, changed_by, note, changed_at)
    VALUES (NEW.id, OLD.status_id, NEW.status_id, v_actor, 'เปลี่ยนสถานะ', NOW());

    INSERT INTO ticket_activities (ticket_id, actor_id, action, from_value, to_value, note, created_at)
    VALUES (NEW.id, v_actor, 'status_change',
            CONCAT('status_id=', OLD.status_id),
            CONCAT('status_id=', NEW.status_id),
            NULL, NOW());
  END IF;

  -- 2) โอนงาน/มอบหมายใหม่
  IF ((OLD.assigned_to IS NULL AND NEW.assigned_to IS NOT NULL) OR
      (OLD.assigned_to IS NOT NULL AND NEW.assigned_to IS NULL) OR
      (OLD.assigned_to <> NEW.assigned_to)) THEN

    -- ปิดช่วง assignment เดิม (ถ้ามี)
    UPDATE ticket_assignments
      SET ended_at = NOW()
      WHERE ticket_id = NEW.id AND ended_at IS NULL;

    -- เปิดช่วงใหม่ถ้ามีผู้รับผิดชอบใหม่
    IF NEW.assigned_to IS NOT NULL THEN
      INSERT INTO ticket_assignments (ticket_id, assignee_id, assigned_by, started_at, note)
      VALUES (NEW.id, NEW.assigned_to, v_actor, NOW(), 'โอนงาน/มอบหมายใหม่');
    END IF;

    INSERT INTO ticket_activities (ticket_id, actor_id, action, from_value, to_value, note, created_at)
    VALUES (NEW.id, v_actor, 'assign',
            CONCAT('assignee_id=', IFNULL(OLD.assigned_to, 'NULL')),
            CONCAT('assignee_id=', IFNULL(NEW.assigned_to, 'NULL')),
            'เปลี่ยนผู้รับผิดชอบ', NOW());
  END IF;

  -- 3) อัปเดตรายละเอียดสำคัญ (หัวข้อ/รายละเอียด/ความสำคัญ/กำหนดส่ง)
  IF (OLD.subject <> NEW.subject OR OLD.details <> NEW.details OR
      OLD.priority_id <> NEW.priority_id OR
      (OLD.due_at IS NULL AND NEW.due_at IS NOT NULL) OR
      (OLD.due_at IS NOT NULL AND NEW.due_at IS NULL) OR
      (OLD.due_at <> NEW.due_at)) THEN
    INSERT INTO ticket_activities (ticket_id, actor_id, action, note, created_at)
    VALUES (NEW.id, v_actor, 'update', 'แก้ไขข้อมูล Ticket', NOW());
  END IF;

  -- 4) ปิดงาน
  IF (OLD.closed_at IS NULL AND NEW.closed_at IS NOT NULL) THEN
    INSERT INTO ticket_activities (ticket_id, actor_id, action, note, created_at)
    VALUES (NEW.id, v_actor, 'close', 'ปิดงาน', NOW());
  END IF;

  -- 5) เปิดงานใหม่
  IF (OLD.closed_at IS NOT NULL AND NEW.closed_at IS NULL) THEN
    INSERT INTO ticket_activities (ticket_id, actor_id, action, note, created_at)
    VALUES (NEW.id, v_actor, 'reopen', 'เปิดงานใหม่', NOW());
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_tickets_after_update_sla` AFTER UPDATE ON `tickets` FOR EACH ROW BEGIN
  /* ----------------------------------------------------
     วัตถุประสงค์:
     - เซ็ต resolved_at อัตโนมัติเมื่อสถานะเป็น Resolved
     - คำนวณเวลาที่ใช้จนแก้เสร็จ (elapsed) และ breached
     ---------------------------------------------------- */
  DECLARE v_resolve_at DATETIME;

  -- ถ้าพึ่งเปลี่ยนเป็น Resolved และยังไม่มี resolved_at ให้ตั้ง NOW()
  IF NEW.status_id = 3 AND (OLD.status_id <> 3) AND NEW.resolved_at IS NULL THEN
    SET v_resolve_at = NOW();

    UPDATE tickets
    SET resolved_at = v_resolve_at
    WHERE id = NEW.id;
  ELSE
    -- ใช้ค่าที่ผู้ใช้ส่งมา หากมี
    SET v_resolve_at = NEW.resolved_at;
  END IF;

  -- อัปเดต metric เมื่อมี resolved_at (ไม่ว่าจะมาจาก NOW() หรือค่าที่ส่งมา)
  IF v_resolve_at IS NOT NULL THEN
    UPDATE ticket_sla_metrics m
    JOIN tickets t ON t.id = m.ticket_id
    SET
      m.resolve_at = v_resolve_at,
      m.resolve_elapsed_mins = TIMESTAMPDIFF(MINUTE, t.created_at, v_resolve_at),
      m.is_resolve_breached =
        CASE
          WHEN m.resolve_due_at IS NOT NULL
           AND v_resolve_at > m.resolve_due_at THEN 1
          ELSE 0
        END
    WHERE m.ticket_id = NEW.id;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_activities`
--

CREATE TABLE `ticket_activities` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสรายการกิจกรรม (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิง Ticket ที่เกี่ยวข้อง (tickets.id)',
  `actor_id` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้กระทำเหตุการณ์ (users.id)',
  `action` enum('create','update','assign','status_change','comment','attach','close','reopen') NOT NULL COMMENT 'ประเภทของเหตุการณ์ที่เกิดขึ้น',
  `from_value` varchar(255) DEFAULT NULL COMMENT 'ค่าก่อนการเปลี่ยนแปลง (เช่น สถานะเดิม/ผู้รับผิดชอบเดิม)',
  `to_value` varchar(255) DEFAULT NULL COMMENT 'ค่าหลังการเปลี่ยนแปลง (เช่น สถานะใหม่/ผู้รับผิดชอบใหม่)',
  `note` text DEFAULT NULL COMMENT 'หมายเหตุหรือรายละเอียดเพิ่มเติมของเหตุการณ์',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาเกิดเหตุการณ์'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_assignments`
--

CREATE TABLE `ticket_assignments` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสการมอบหมาย (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'Ticket ที่ถูกมอบหมาย (tickets.id)',
  `assignee_id` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้ที่ได้รับมอบหมายงาน (users.id)',
  `assigned_by` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้ที่ทำการมอบหมาย (users.id)',
  `started_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาเริ่มการมอบหมาย',
  `ended_at` datetime DEFAULT NULL COMMENT 'วันเวลาสิ้นสุดการมอบหมาย (NULL = กำลังดำเนินอยู่)',
  `note` varchar(255) DEFAULT NULL COMMENT 'หมายเหตุเพิ่มเติมของการมอบหมาย',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่บันทึก',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_attachments`
--

CREATE TABLE `ticket_attachments` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสไฟล์แนบ (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'Ticket ที่ไฟล์นี้ถูกแนบ (tickets.id)',
  `uploader_id` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้ที่อัปโหลดไฟล์ (users.id)',
  `file_name` varchar(255) NOT NULL COMMENT 'ชื่อไฟล์ที่แสดง เช่น error_log.txt, screenshot.png',
  `file_path` varchar(500) NOT NULL COMMENT 'ที่อยู่ไฟล์ (Path หรือ URL)',
  `file_type` varchar(100) DEFAULT NULL COMMENT 'ประเภทไฟล์ เช่น image/png, application/pdf',
  `file_size` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'ขนาดไฟล์ (หน่วยเป็น Byte)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่อัปโหลดไฟล์'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_categories`
--

CREATE TABLE `ticket_categories` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสหมวดหมู่ (Primary Key)',
  `name` varchar(100) NOT NULL COMMENT 'ชื่อหมวดหมู่หลัก เช่น Hardware, Software, Network',
  `description` varchar(255) DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติมของหมวดหมู่',
  `created_by` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสผู้ใช้งานที่สร้างหมวดหมู่ (อ้างอิง users.id)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่บันทึกข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_categories`
--

INSERT INTO `ticket_categories` (`id`, `name`, `description`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 'Hardware', 'หมวดหมู่ที่เกี่ยวกับอุปกรณ์ เช่น PC, Notebook, Printer', 1, '2025-09-21 21:28:19', '2025-09-21 21:28:19'),
(2, 'Software', 'หมวดหมู่ที่เกี่ยวกับโปรแกรม เช่น Windows, Office, ERP', 1, '2025-09-21 21:28:19', '2025-09-21 21:28:19'),
(3, 'Network', 'หมวดหมู่ที่เกี่ยวกับเครือข่าย เช่น LAN, WiFi, VPN', 1, '2025-09-21 21:28:19', '2025-09-21 21:28:19');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_comments`
--

CREATE TABLE `ticket_comments` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสคอมเมนต์ (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิง Ticket ที่คอมเมนต์ (tickets.id)',
  `author_id` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้เขียนคอมเมนต์ (users.id)',
  `content` text NOT NULL COMMENT 'เนื้อหาคอมเมนต์',
  `is_internal` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1=คอมเมนต์ภายใน (ทีมเห็นเท่านั้น), 0=คอมเมนต์สาธารณะ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างคอมเมนต์',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่แก้ไขคอมเมนต์ล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `ticket_comments`
--
DELIMITER $$
CREATE TRIGGER `trg_comments_after_insert_sla` AFTER INSERT ON `ticket_comments` FOR EACH ROW BEGIN
  /* -------------------------------------------------
     วัตถุประสงค์:
     - ถ้า ticket นี้ยังไม่เคยมี first_response_at
       ให้ตั้งเวลาจากคอมเมนต์แรก (ทั้ง internal/public)
     - คำนวณ elapsed (นาที) และสถานะ breached
     ------------------------------------------------- */
  IF NEW.ticket_id IS NOT NULL THEN
    -- ตั้งค่าเวลาตอบครั้งแรกถ้ายังว่าง
    UPDATE ticket_sla_metrics m
    JOIN tickets t ON t.id = m.ticket_id
    SET
      m.first_response_at =
        COALESCE(m.first_response_at, NEW.created_at),
      m.first_response_elapsed_mins =
        COALESCE(m.first_response_elapsed_mins,
                 TIMESTAMPDIFF(MINUTE, t.created_at, NEW.created_at)),
      m.is_first_response_breached =
        COALESCE(m.is_first_response_breached,
          CASE
            WHEN m.first_response_due_at IS NOT NULL
             AND NEW.created_at > m.first_response_due_at THEN 1
            ELSE 0
          END)
    WHERE m.ticket_id = NEW.ticket_id
      AND m.first_response_at IS NULL;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_priorities`
--

CREATE TABLE `ticket_priorities` (
  `id` tinyint(3) UNSIGNED NOT NULL COMMENT 'รหัสระดับความสำคัญ (Primary Key)',
  `name` varchar(50) NOT NULL COMMENT 'ชื่อระดับความสำคัญ เช่น Low, Normal, High, Urgent, Critical (ไม่ซ้ำ)',
  `weight` tinyint(3) UNSIGNED NOT NULL COMMENT 'ค่าน้ำหนักใช้จัดลำดับความสำคัญ (เลขน้อย=ความสำคัญต่ำ → เลขมาก=สูง)',
  `color` varchar(20) DEFAULT NULL COMMENT 'รหัสสีสำหรับ UI (เช่น #RRGGBB หรือชื่อสีมาตรฐาน)',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'กำหนดเป็นค่ามาตรฐานเวลาสร้าง Ticket ใหม่ (1=ค่าเริ่มต้น)',
  `description` varchar(150) DEFAULT NULL COMMENT 'คำอธิบายเพิ่มเติมของระดับความสำคัญ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่บันทึกข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_priorities`
--

INSERT INTO `ticket_priorities` (`id`, `name`, `weight`, `color`, `is_default`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Low', 1, '#9E9E9E', 0, 'ความสำคัญน้อย', '2025-09-21 21:25:12', '2025-09-21 21:25:12'),
(2, 'Normal', 2, '#2196F3', 1, 'ค่ามาตรฐาน', '2025-09-21 21:25:12', '2025-09-21 21:25:12'),
(3, 'High', 3, '#FF9800', 0, 'สูง ต้องเร่งดำเนินการ', '2025-09-21 21:25:12', '2025-09-21 21:25:12'),
(4, 'Urgent', 4, '#F44336', 0, 'เร่งด่วนมาก', '2025-09-21 21:25:12', '2025-09-21 21:25:12'),
(5, 'Critical', 5, '#B71C1C', 0, 'วิกฤต กระทบกว้าง', '2025-09-21 21:25:12', '2025-09-21 21:25:12');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_service_categories`
--

CREATE TABLE `ticket_service_categories` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัส Service Category (Primary Key)',
  `category_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิงไปยัง ticket_categories.id',
  `name` varchar(100) NOT NULL COMMENT 'ชื่อ Service Category เช่น Email, Database, Printer',
  `description` varchar(255) DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติมเกี่ยวกับ Service Category',
  `created_by` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสผู้ใช้งานที่สร้าง (อ้างอิง users.id)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_service_categories`
--

INSERT INTO `ticket_service_categories` (`id`, `category_id`, `name`, `description`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'Printer', 'บริการเกี่ยวกับเครื่องพิมพ์', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16'),
(2, 1, 'PC & Notebook', 'บริการเกี่ยวกับคอมพิวเตอร์', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16'),
(3, 2, 'Email', 'บริการเกี่ยวกับระบบอีเมล เช่น Outlook', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16'),
(4, 2, 'Database', 'บริการเกี่ยวกับฐานข้อมูล เช่น MySQL, SQL Server', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16'),
(5, 3, 'LAN/WiFi', 'ปัญหาหรือบริการเกี่ยวกับเครือข่ายภายใน', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16'),
(6, 3, 'VPN', 'บริการเกี่ยวกับ VPN การเชื่อมต่อจากภายนอก', 1, '2025-09-21 21:30:16', '2025-09-21 21:30:16');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_sla_metrics`
--

CREATE TABLE `ticket_sla_metrics` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสรายการ SLA Metric (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิง Ticket (tickets.id)',
  `sla_policy_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'อ้างอิงนโยบาย SLA ที่ใช้คำนวณ (sla_policies.id) ณ เวลาที่บันทึก',
  `first_response_due_at` datetime DEFAULT NULL COMMENT 'กำหนดเวลาต้องตอบครั้งแรกตาม SLA',
  `resolve_due_at` datetime DEFAULT NULL COMMENT 'กำหนดเวลาต้องแก้ไขเสร็จตาม SLA',
  `first_response_at` datetime DEFAULT NULL COMMENT 'เวลาที่มีการตอบครั้งแรกจริง (เช่น คอมเมนต์/อัปเดตแรก)',
  `resolve_at` datetime DEFAULT NULL COMMENT 'เวลาที่ทำงานเสร็จจริง (เชื่อมกับ tickets.resolved_at หรือบันทึกเมื่อสถานะเป็น Resolved)',
  `is_first_response_breached` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'ละเมิด SLA การตอบครั้งแรกหรือไม่ (1=ละเมิด)',
  `is_resolve_breached` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'ละเมิด SLA การแก้ไขเสร็จหรือไม่ (1=ละเมิด)',
  `first_response_elapsed_mins` int(10) UNSIGNED DEFAULT NULL COMMENT 'จำนวนนาทีที่ใช้ถึงการตอบครั้งแรก (นับจาก created_at)',
  `resolve_elapsed_mins` int(10) UNSIGNED DEFAULT NULL COMMENT 'จำนวนนาทีที่ใช้จนแก้เสร็จ (นับจาก created_at)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_statuses`
--

CREATE TABLE `ticket_statuses` (
  `id` tinyint(3) UNSIGNED NOT NULL COMMENT 'รหัสสถานะ (Primary Key)',
  `name` varchar(50) NOT NULL COMMENT 'ชื่อสถานะ เช่น On Process, Resolved, Closed, Pending',
  `description` varchar(150) DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติมเกี่ยวกับสถานะ',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_statuses`
--

INSERT INTO `ticket_statuses` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'On Process', 'สถานะเริ่มต้นของ Ticket ทุกใบ', '2025-09-21 21:19:07', '2025-09-21 21:19:07'),
(2, 'Pending', 'รอข้อมูลเพิ่มเติม หรือรอดำเนินการ', '2025-09-21 21:19:07', '2025-09-21 21:19:07'),
(3, 'Resolved', 'ดำเนินการเสร็จสิ้นและรอการปิด', '2025-09-21 21:19:07', '2025-09-21 21:19:07'),
(4, 'Closed', 'ปิดงานเรียบร้อยแล้ว', '2025-09-21 21:19:07', '2025-09-21 21:19:07'),
(5, 'Reopened', 'Ticket ถูกเปิดใหม่หลังจากปิดไปแล้ว', '2025-09-21 21:19:07', '2025-09-21 21:19:07');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_status_history`
--

CREATE TABLE `ticket_status_history` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสรายการประวัติสถานะ (Primary Key)',
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิง Ticket ที่ถูกเปลี่ยนสถานะ (tickets.id)',
  `old_status` tinyint(3) UNSIGNED DEFAULT NULL COMMENT 'สถานะเดิมก่อนเปลี่ยน (ticket_statuses.id) อาจเป็น NULL ถ้าเป็นการสร้างครั้งแรก',
  `new_status` tinyint(3) UNSIGNED NOT NULL COMMENT 'สถานะใหม่หลังเปลี่ยน (ticket_statuses.id)',
  `changed_by` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้ที่ทำการเปลี่ยนสถานะ (users.id)',
  `note` varchar(255) DEFAULT NULL COMMENT 'เหตุผลหรือคำอธิบายสั้นๆ ของการเปลี่ยนสถานะ',
  `changed_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาเกิดเหตุการณ์เปลี่ยนสถานะ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_subcategories`
--

CREATE TABLE `ticket_subcategories` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัส Subcategory (Primary Key)',
  `service_category_id` bigint(20) UNSIGNED NOT NULL COMMENT 'อ้างอิงไปยัง ticket_service_categories.id',
  `name` varchar(100) NOT NULL COMMENT 'ชื่อ Subcategory เช่น HP LaserJet, Outlook, Cisco VPN',
  `description` varchar(255) DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติมเกี่ยวกับ Subcategory',
  `created_by` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสผู้ใช้งานที่สร้าง (อ้างอิง users.id)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_subcategories`
--

INSERT INTO `ticket_subcategories` (`id`, `service_category_id`, `name`, `description`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 'HP LaserJet', 'เครื่องพิมพ์ HP รุ่น LaserJet', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(2, 1, 'Canon Pixma', 'เครื่องพิมพ์ Canon รุ่น Pixma', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(3, 2, 'Dell Laptop', 'โน้ตบุ๊ค Dell', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(4, 2, 'Lenovo ThinkCentre', 'PC Desktop Lenovo', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(5, 3, 'Outlook', 'บริการอีเมล Microsoft Outlook', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(6, 3, 'Gmail', 'บริการอีเมล Google Gmail', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(7, 4, 'MySQL', 'ฐานข้อมูล MySQL', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(8, 4, 'SQL Server', 'ฐานข้อมูล Microsoft SQL Server', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(9, 5, 'LAN', 'เครือข่ายภายในแบบ LAN', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(10, 5, 'WiFi', 'เครือข่ายไร้สาย WiFi', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(11, 6, 'Cisco VPN', 'VPN ของ Cisco', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28'),
(12, 6, 'Fortinet VPN', 'VPN ของ Fortinet', 1, '2025-09-21 21:31:28', '2025-09-21 21:31:28');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_types`
--

CREATE TABLE `ticket_types` (
  `id` tinyint(3) UNSIGNED NOT NULL COMMENT 'รหัสประเภท (Primary Key)',
  `name` varchar(50) NOT NULL COMMENT 'ชื่อประเภท เช่น Incident, Service, Change',
  `description` varchar(150) DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติมเกี่ยวกับประเภท',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_types`
--

INSERT INTO `ticket_types` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Incident', 'เหตุการณ์/ปัญหาที่ต้องแก้ไข เช่น ระบบล่ม, เครื่องเสีย', '2025-09-21 21:20:26', '2025-09-21 21:20:26'),
(2, 'Service', 'คำขอบริการ เช่น ขอเพิ่มผู้ใช้งาน, ขอเปิดสิทธิ์การใช้งาน', '2025-09-21 21:20:26', '2025-09-21 21:20:26'),
(3, 'Change', 'การเปลี่ยนแปลงระบบ เช่น Update Software, เปลี่ยน Configuration', '2025-09-21 21:20:26', '2025-09-21 21:20:26');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_watchers`
--

CREATE TABLE `ticket_watchers` (
  `ticket_id` bigint(20) UNSIGNED NOT NULL COMMENT 'Ticket ที่ผู้ใช้ติดตาม (tickets.id)',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT 'ผู้ใช้งานที่ติดตาม Ticket (users.id)',
  `added_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่เพิ่มการติดตาม'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'รหัสผู้ใช้งาน (Primary Key)',
  `username` varchar(50) NOT NULL COMMENT 'ชื่อผู้ใช้งาน (ไม่ซ้ำ)',
  `password` varchar(255) NOT NULL COMMENT 'รหัสผ่าน (เก็บเป็น Hash)',
  `email` varchar(100) DEFAULT NULL COMMENT 'อีเมล (ใช้สำหรับติดต่อ/เข้าสู่ระบบ)',
  `full_name` varchar(150) DEFAULT NULL COMMENT 'ชื่อ-นามสกุลจริง',
  `role` enum('admin','staff','user') NOT NULL DEFAULT 'user' COMMENT 'บทบาทผู้ใช้งาน เช่น admin, staff, user',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'วันเวลาที่สร้างข้อมูล',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'วันเวลาที่อัปเดตล่าสุด',
  `position` varchar(100) DEFAULT NULL COMMENT 'ตำแหน่งงาน เช่น Programmer, IT Support',
  `department` varchar(150) DEFAULT NULL COMMENT 'ชื่อแผนกที่สังกัด เช่น แผนกไอที, ฝ่ายบุคคล',
  `organization` varchar(200) DEFAULT NULL COMMENT 'ชื่อองค์กรหรือบริษัทที่สังกัด เช่น บริษัท ABC จำกัด',
  `profile` varchar(255) DEFAULT NULL COMMENT 'ที่อยู่ไฟล์รูปโปรไฟล์ เช่น /uploads/profile/123.jpg หรือ URL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `full_name`, `role`, `created_at`, `updated_at`, `position`, `department`, `organization`, `profile`) VALUES
(1, 'admin', 'changeme', 'admin@example.com', 'System Administrator', 'admin', '2025-09-21 21:27:15', '2025-09-21 21:27:15', NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `fk_projects_created_by` (`created_by`),
  ADD KEY `fk_projects_owner` (`owner_id`);

--
-- Indexes for table `sla_policies`
--
ALTER TABLE `sla_policies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_tickets_type` (`type_id`),
  ADD KEY `fk_tickets_priority` (`priority_id`),
  ADD KEY `fk_tickets_status` (`status_id`),
  ADD KEY `fk_tickets_category` (`category_id`),
  ADD KEY `fk_tickets_service_cat` (`service_category_id`),
  ADD KEY `fk_tickets_subcategory` (`subcategory_id`),
  ADD KEY `fk_tickets_updated_by` (`updated_by`),
  ADD KEY `idx_tickets_project_status` (`project_id`,`status_id`),
  ADD KEY `idx_tickets_assigned_to` (`assigned_to`),
  ADD KEY `idx_tickets_created_by` (`created_by`),
  ADD KEY `idx_tickets_created_at` (`created_at`),
  ADD KEY `idx_tickets_due_status` (`due_at`,`status_id`),
  ADD KEY `fk_tickets_sla` (`sla_policy_id`),
  ADD KEY `idx_tickets_assigned_to_v2` (`assigned_to`),
  ADD KEY `idx_tickets_created_by_v2` (`created_by`),
  ADD KEY `idx_tickets_created_at_v2` (`created_at`),
  ADD KEY `idx_tickets_due_status_v2` (`due_at`,`status_id`);

--
-- Indexes for table `ticket_activities`
--
ALTER TABLE `ticket_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_act_ticket_created` (`ticket_id`,`created_at`),
  ADD KEY `idx_act_actor_created` (`actor_id`,`created_at`);

--
-- Indexes for table `ticket_assignments`
--
ALTER TABLE `ticket_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_asg_assigned` (`assigned_by`),
  ADD KEY `idx_asg_ticket_active` (`ticket_id`,`ended_at`),
  ADD KEY `idx_asg_assignee_time` (`assignee_id`,`started_at`);

--
-- Indexes for table `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_att_uploader` (`uploader_id`),
  ADD KEY `idx_att_ticket_created` (`ticket_id`,`created_at`);

--
-- Indexes for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `fk_ticket_categories_created_by` (`created_by`);

--
-- Indexes for table `ticket_comments`
--
ALTER TABLE `ticket_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cmt_author` (`author_id`),
  ADD KEY `idx_cmt_ticket_created` (`ticket_id`,`created_at`);

--
-- Indexes for table `ticket_priorities`
--
ALTER TABLE `ticket_priorities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `ticket_service_categories`
--
ALTER TABLE `ticket_service_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_service_category` (`category_id`,`name`),
  ADD KEY `fk_service_category_created_by` (`created_by`);

--
-- Indexes for table `ticket_sla_metrics`
--
ALTER TABLE `ticket_sla_metrics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sla_metrics_policy` (`sla_policy_id`),
  ADD KEY `idx_sla_ticket` (`ticket_id`),
  ADD KEY `idx_sla_due` (`resolve_due_at`,`first_response_due_at`),
  ADD KEY `idx_sla_flags` (`is_first_response_breached`,`is_resolve_breached`);

--
-- Indexes for table `ticket_statuses`
--
ALTER TABLE `ticket_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_sth_old` (`old_status`),
  ADD KEY `fk_sth_new` (`new_status`),
  ADD KEY `idx_sth_ticket_time` (`ticket_id`,`changed_at`),
  ADD KEY `idx_sth_changed_by` (`changed_by`,`changed_at`);

--
-- Indexes for table `ticket_subcategories`
--
ALTER TABLE `ticket_subcategories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_service_sub` (`service_category_id`,`name`),
  ADD KEY `fk_sub_created_by` (`created_by`);

--
-- Indexes for table `ticket_types`
--
ALTER TABLE `ticket_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `ticket_watchers`
--
ALTER TABLE `ticket_watchers`
  ADD PRIMARY KEY (`ticket_id`,`user_id`),
  ADD KEY `fk_watch_user` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `username_2` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสโครงการ (Primary Key)';

--
-- AUTO_INCREMENT for table `sla_policies`
--
ALTER TABLE `sla_policies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัส SLA (Primary Key)', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tags`
--
ALTER TABLE `tags`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสแท็ก (Primary Key)', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัส Ticket (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_activities`
--
ALTER TABLE `ticket_activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสรายการกิจกรรม (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_assignments`
--
ALTER TABLE `ticket_assignments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสการมอบหมาย (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสไฟล์แนบ (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสหมวดหมู่ (Primary Key)', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ticket_comments`
--
ALTER TABLE `ticket_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสคอมเมนต์ (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_service_categories`
--
ALTER TABLE `ticket_service_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัส Service Category (Primary Key)', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ticket_sla_metrics`
--
ALTER TABLE `ticket_sla_metrics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสรายการ SLA Metric (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสรายการประวัติสถานะ (Primary Key)';

--
-- AUTO_INCREMENT for table `ticket_subcategories`
--
ALTER TABLE `ticket_subcategories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัส Subcategory (Primary Key)', AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'รหัสผู้ใช้งาน (Primary Key)', AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `fk_projects_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_projects_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_tickets_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_category` FOREIGN KEY (`category_id`) REFERENCES `ticket_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_priority` FOREIGN KEY (`priority_id`) REFERENCES `ticket_priorities` (`id`),
  ADD CONSTRAINT `fk_tickets_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_service_cat` FOREIGN KEY (`service_category_id`) REFERENCES `ticket_service_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_sla` FOREIGN KEY (`sla_policy_id`) REFERENCES `sla_policies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_status` FOREIGN KEY (`status_id`) REFERENCES `ticket_statuses` (`id`),
  ADD CONSTRAINT `fk_tickets_subcategory` FOREIGN KEY (`subcategory_id`) REFERENCES `ticket_subcategories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_type` FOREIGN KEY (`type_id`) REFERENCES `ticket_types` (`id`),
  ADD CONSTRAINT `fk_tickets_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `ticket_activities`
--
ALTER TABLE `ticket_activities`
  ADD CONSTRAINT `fk_act_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_act_user` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `ticket_assignments`
--
ALTER TABLE `ticket_assignments`
  ADD CONSTRAINT `fk_asg_assigned` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_asg_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_asg_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_attachments`
--
ALTER TABLE `ticket_attachments`
  ADD CONSTRAINT `fk_att_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_att_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `ticket_categories`
--
ALTER TABLE `ticket_categories`
  ADD CONSTRAINT `fk_ticket_categories_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `ticket_comments`
--
ALTER TABLE `ticket_comments`
  ADD CONSTRAINT `fk_cmt_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cmt_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_service_categories`
--
ALTER TABLE `ticket_service_categories`
  ADD CONSTRAINT `fk_service_category_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_category_parent` FOREIGN KEY (`category_id`) REFERENCES `ticket_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_sla_metrics`
--
ALTER TABLE `ticket_sla_metrics`
  ADD CONSTRAINT `fk_sla_metrics_policy` FOREIGN KEY (`sla_policy_id`) REFERENCES `sla_policies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sla_metrics_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_status_history`
--
ALTER TABLE `ticket_status_history`
  ADD CONSTRAINT `fk_sth_by` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sth_new` FOREIGN KEY (`new_status`) REFERENCES `ticket_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sth_old` FOREIGN KEY (`old_status`) REFERENCES `ticket_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sth_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_subcategories`
--
ALTER TABLE `ticket_subcategories`
  ADD CONSTRAINT `fk_sub_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sub_service` FOREIGN KEY (`service_category_id`) REFERENCES `ticket_service_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ticket_watchers`
--
ALTER TABLE `ticket_watchers`
  ADD CONSTRAINT `fk_watch_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_watch_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
