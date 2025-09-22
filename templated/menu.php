<!-- Sidebar หลัก -->
<aside class="main-sidebar elevation-4 sidebar-light-danger">

  <!-- โลโก้ -->
  <a href="<?php echo BASE_URL; ?>/index.php" class="brand-link bg-danger">
    <img src="<?php echo BASE_URL; ?>/img/up1.png" alt="PMS Management" class="brand-image img-circle elevation-3" style="opacity: .8">
    <span class="brand-text font-weight-light">PMS Management</span>
  </a>

  <!-- แสดงเมื่อ login -->
  <?php if (isset($_SESSION['contact_id'])) { ?>
    <div class="sidebar os-host os-theme-light">

      <!-- ข้อมูลผู้ใช้ -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <img src="<?php echo BASE_URL; ?>/img/002.png" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">
          <a href="<?php echo BASE_URL; ?>/profile.php"><?php echo ($_SESSION['contact_name']); ?></a><br>
          <a href="<?php echo BASE_URL; ?>/profile.php"><?php echo ($_SESSION['position']); ?></a><br>
          <a href="<?php echo BASE_URL; ?>/logout.php"><i class="nav-icon fa fa-sign-in">Logout</i></a>
        </div>
      </div>
  <?php } ?>

      <!-- เมนูหลัก -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu">

          <!-- Dashboard -->
          <li class="nav-item">
            <a href="<?php echo BASE_URL; ?>/dash.php" class="nav-link <?php if ($menu == "dash") { echo "active"; } ?>">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>Dashboard</p>
            </a>
          </li>

          <!-- All Job -->
          <li class="nav-item">
            <a href="<?php echo BASE_URL; ?>/ticket/ticket.php" class="nav-link <?php if ($menu == "ticket") { echo "active"; } ?>">
              <i class="nav-icon fas fa-vial"></i>
              <p>All Job</p>
            </a>
          </li>

          <!-- Test Case -->
          <li class="nav-item">
            <a href="<?php echo BASE_URL; ?>/index.php" class="nav-link <?php if ($menu == "index") { echo "active"; } ?>">
              <i class="nav-icon fa fa-desktop"></i>
              <p>Test Case</p>
            </a>
          </li>

          <!-- หัวข้อการตั้งค่า -->
          <li class="nav-header text-primary">Setting</li>

          <!-- Project -->
          <li class="nav-item">
            <a href="#" class="nav-link <?php if ($menu == "project") { echo "active"; } ?>">
              <i class="nav-icon fa fa-folder-open"></i>
              <p>Project</p>
            </a>
          </li>

          <!-- Contact -->
          <li class="nav-item">
            <a href="#" class="nav-link <?php if ($menu == "contact") { echo "active"; } ?>">
              <i class="nav-icon fa fa-address-book"></i>
              <p>Contact</p>
            </a>
          </li>

        </ul>
      </nav>
      <!-- /เมนู -->
    </div>
    <!-- /sidebar -->
</aside>
