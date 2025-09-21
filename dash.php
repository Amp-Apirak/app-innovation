<!DOCTYPE html>
<html lang="en">
<?php $menu = "dash"; ?>

<head>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>

    <script>
        //Zoom Images
        $(function() {

            $('.imgx').hover(function() {
                var w = 600;
                var h = 660;
                var d = 600; //duration
                var imgx = $(this);
                $('.imgy').remove();
                var imgy = $('<img class="imgy" src="' + $(this).attr('src') + '"/>').appendTo('body');
                imgy.css({
                    position: 'absolute',
                    left: imgx.offset().left,
                    top: imgx.offset().top,
                    width: imgx.width(),
                    height: imgx.height()
                }).mouseout(function() {
                    $('.imgy').remove();
                }).click(function() {
                    $('.imgy').remove();
                });
                imgy.animate({
                    left: imgx.offset().left - (w / 2),
                    top: imgx.offset().top - (h / 2),
                    width: w + 'px',
                    height: h + 'px'
                }, d);
            }, function() {});
        });
        //]]>
    </script>


    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Innovation | Work Task</title>

    <!-- highlight -->
    <style>
        .highlight {
            background-color: #FFFF88;
        }
    </style>
    <!-- highlight -->

    <!----------------------------- start header ------------------------------->
    <?php include($_SERVER['DOCUMENT_ROOT'] . '/pms/templated/head.php'); ?>
    <!----------------------------- end header --------------------------------->

    <!----------------------------- start menu ------------------------------->
    <?php include($_SERVER['DOCUMENT_ROOT'] . '/pms/templated/menu.php'); ?>
    <!----------------------------- end menu --------------------------------->


    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">

        <!-- Content Header (Page header) -->
        <section class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1>Dashboard</h1>
                    </div>
                    <div class="col-sm-6">
                        <ol class="breadcrumb float-sm-right">
                            <li class="breadcrumb-item"><a href="index.php">Home</a></li>
                            <li class="breadcrumb-item active">Dashboard</li>
                        </ol>
                    </div>
                </div>
            </div><!-- /.container-fluid -->
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">

                        <!-- Status -->
                        <section class="content">
                            <div class="container-fluid">
                                <!-- Small boxes (Stat box) -->
                                <div class="row">

                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-info">

                                            <!-- Qeury Count All Service -->
                                            <?php

                                            $query2 = "SELECT DISTINCT COUNT(`work_id`) as AMP FROM work ";
                                            $query1 = $query2 . "" . " ORDER BY work_id DESC ";
                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>

                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>Task All</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->

                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->


                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-warning">

                                            <!-- Qeury Count All Service -->
                                            <?php
                                            if (isset($_POST['search'])) {

                                                if (!empty($search) || ($status != "") || ($requester != "") || ($work_type != "") || ($service != "") || ($category != "") || ($items != "")) {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work";
                                                    $query1 = $query2 . $_where . "AND `status` = 'On Process'" . " ORDER BY work_id DESC";
                                                } else {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'On Process'";
                                                    $query1 = $query2 . $_where . "" . " ORDER BY work_id DESC";
                                                }
                                            } else {
                                                $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'On Process'";
                                                $query1 = $query2 . "" . " ORDER BY work_id DESC";
                                            }

                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>


                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>On Process</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->



                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->

                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-success">

                                            <!-- Qeury Count All Service -->
                                            <?php
                                            if (isset($_POST['search'])) {

                                                if (!empty($search) || ($status != "") || ($requester != "") || ($work_type != "") || ($service != "") || ($category != "") || ($items != "")) {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work";
                                                    $query1 = $query2 . $_where . "AND `status` = 'Done'" . " ORDER BY work_id DESC";
                                                } else {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Done'";
                                                    $query1 = $query2 . $_where . "" . " ORDER BY work_id DESC";
                                                }
                                            } else {
                                                $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Done'";
                                                $query1 = $query2 . "" . " ORDER BY work_id DESC";
                                            }

                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>



                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>Done</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->

                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->


                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-primary">

                                            <!-- Qeury Count All Service -->
                                            <?php
                                            if (isset($_POST['search'])) {

                                                if (!empty($search) || ($status != "") || ($requester != "") || ($work_type != "") || ($service != "") || ($category != "") || ($items != "")) {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work";
                                                    $query1 = $query2 . $_where . "AND `status` = 'Approve'" . " ORDER BY work_id DESC";
                                                } else {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Approve'";
                                                    $query1 = $query2 . $_where . "" . " ORDER BY work_id DESC";
                                                }
                                            } else {
                                                $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Approve'";
                                                $query1 = $query2 . "" . " ORDER BY work_id DESC";
                                            }

                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>



                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>Approve</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->

                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->

                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-denger">

                                            <!-- Qeury Count All Service -->
                                            <?php
                                            if (isset($_POST['search'])) {

                                                if (!empty($search) || ($status != "") || ($requester != "") || ($work_type != "") || ($service != "") || ($category != "") || ($items != "")) {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work";
                                                    $query1 = $query2 . $_where . "AND `status` = 'Pending'" . " ORDER BY work_id DESC";
                                                } else {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Pending'";
                                                    $query1 = $query2 . $_where . "" . " ORDER BY work_id DESC";
                                                }
                                            } else {
                                                $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Pending'";
                                                $query1 = $query2 . "" . " ORDER BY work_id DESC";
                                            }

                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>



                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>Pending</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->

                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->

                                    <div class="col-lg-2 col-4">
                                        <!-- small box -->
                                        <div class="small-box bg-secondary">

                                            <!-- Qeury Count All Service -->
                                            <?php
                                            if (isset($_POST['search'])) {

                                                if (!empty($search) || ($status != "") || ($requester != "") || ($work_type != "") || ($service != "") || ($category != "") || ($items != "")) {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work";
                                                    $query1 = $query2 . $_where . "AND `status` = 'Cancel'" . " ORDER BY work_id DESC";
                                                } else {

                                                    $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Cancel'";
                                                    $query1 = $query2 . $_where . "" . " ORDER BY work_id DESC";
                                                }
                                            } else {
                                                $query2 = "SELECT COUNT(`status`) as AMP FROM work  WHERE `status` = 'Cancel'";
                                                $query1 = $query2 . "" . " ORDER BY work_id DESC";
                                            }

                                            $result = mysqli_query($conn, $query1);
                                            $rs = mysqli_fetch_array($result);
                                            $a = $rs['AMP'];
                                            ?>



                                            <div class="inner">
                                                <h3><?php echo number_format($a, 0); ?></h3>

                                                <p>Cancel</p>
                                            </div>
                                            <div class="icon">
                                                <i class="ion ion-person-add"></i>
                                            </div>
                                            <a href="#" class="small-box-footer"></i></a>
                                        </div>
                                    </div>
                                    <!-- ./col -->

                                    <!-- ------------------------------------------------------------------------------------------------------------------ -->

                                </div>

                                <!-- ------------------------------------------------------------------------------------------------------------------ -->
                            </div><!-- /.container-fluid -->
                        </section>
                        <!-- /.Status -->

                        <!-- Main content -->
                        <section class="content">

                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- AREA CHART -->
                                        <div class="card card-primary">
                                            <div class="card-header">
                                                <h3 class="card-title">Ticket Status Chart</h3>

                                                <div class="card-tools">
                                                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="chart" anign="center">
                                                    <div id="chart_div" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.card-body -->
                                        </div>
                                        <!-- /.card -->
                                    </div>
                                    <!-- /.col (LEFT) -->
                                    <div class="col-md-6">
                                        <!-- LINE CHART -->
                                        <div class="card card-info">
                                            <div class="card-header">
                                                <h3 class="card-title">Tickets per Technician</h3>

                                                <div class="card-tools">
                                                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="chart" anign="center">
                                                    <div id="Anthony_chart_div" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.card-body -->
                                        </div>
                                        <!-- /.card -->



                                    </div>
                                    <!-- /.col (RIGHT) -->
                                </div>
                                <!-- /.row -->
                            </div><!-- /.container-fluid -->


                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-md-6">
                                        <!-- AREA CHART -->
                                        <div class="card card-primary">
                                            <div class="card-header">
                                                <h3 class="card-title">Ticket Category</h3>

                                                <div class="card-tools">
                                                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="chart" anign="center">
                                                    <div id="chart_div1" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.card-body -->
                                        </div>
                                        <!-- /.card -->
                                    </div>
                                    <div class="col-md-6">
                                        <!-- LINE CHART -->
                                        <div class="card card-info">
                                            <div class="card-header">
                                                <h3 class="card-title">Tickets By Owner</h3>

                                                <div class="card-tools">
                                                    <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-tool" data-card-widget="remove">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="chart" anign="center">
                                                    <div id="Anthony_chart_div1" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- /.card-body -->
                                        </div>
                                        <!-- /.card -->

                                    </div>
                                </div>
                        </section>
                        <!-- /.content -->







                    </div>
                    <!-- /.col -->
                </div>
                <!-- /.row -->
        </section>
        <!-- /.content -->


    </div>
    <!-- /.content-wrapper -->


    <!----------------------------- start menu ------------------------------->
    <?php include($_SERVER['DOCUMENT_ROOT'] . '/pms/templated/footer.php'); ?>
    <!----------------------------- end menu --------------------------------->

    <!-- highlight -->
    <script src="http://localhost/pms/code/dist/js/highlight.js"></script>

    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {
            'packages': ['corechart']
        });
        google.charts.setOnLoadCallback(drawChart);
        google.charts.setOnLoadCallback(drawAnthonyChart);
        google.charts.setOnLoadCallback(drawChart1);
        google.charts.setOnLoadCallback(drawAnthonyChart1);

        function drawChart() {

            // Create the data table.
            var data = google.visualization.arrayToDataTable([
                ['Status', 'Amount'],
                <?php
                $query = "SELECT `status`, COUNT(*) AS totalStatus
                FROM work
                GROUP BY status
                ORDER BY status;";
                $result = mysqli_query($conn, $query);
                while ($re = mysqli_fetch_array($result)) {
                    echo "['" . $re['status'] . "'," . $re['totalStatus'] . "],";
                }
                ?>
            ]);


            var options = {
                'title': 'สถานะการเปิดงาน',
                'is3D': true, //3D
                'legend': '', //ตัวหนังสือซ้ายหรือขวา
                'width': 750,
                'height': 300,
                'pieHole': 0.4, //,มีรู



            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }

        // Callback that draws the pie chart for Anthony's pizza.
        function drawAnthonyChart() {

            // Create the data table for Anthony's pizza.
            var data = google.visualization.arrayToDataTable([
                ['Name', 'Amount'],
                <?php
                $query = "SELECT `staff_crt`, COUNT(*) AS totalStatus
            FROM work
            GROUP BY staff_crt
            ORDER BY staff_crt;";
                $result = mysqli_query($conn, $query);
                while ($re = mysqli_fetch_array($result)) {
                    echo "['" . $re['staff_crt'] . "'," . $re['totalStatus'] . "],";
                }
                ?>
            ]);

            // Set options for Anthony's pie chart.
            var options = {
                title: 'จำนวนการเปิดงานรายบุคคล',
                is3D: true, //3D
                width: 700,
                height: 300
            };

            // Instantiate and draw the chart for Anthony's pizza.
            var chart = new google.visualization.BarChart(document.getElementById('Anthony_chart_div'));
            chart.draw(data, options);
        }

        function drawChart1() {

            // Create the data table.
            var data = google.visualization.arrayToDataTable([
                ['Type', 'Amount'],
                <?php
                $query = "SELECT `work_type`, COUNT(*) AS totalStatus
                FROM work
                GROUP BY work_type
                ORDER BY work_type;";
                $result = mysqli_query($conn, $query);
                while ($re = mysqli_fetch_array($result)) {
                    echo "['" . $re['work_type'] . "'," . $re['totalStatus'] . "],";
                }
                ?>
            ]);


            var options = {
                'title': 'หมวดหมู่การเปิดแจ้งงาน',
                'is3D': true, //3D
                'legend': '', //ตัวหนังสือซ้ายหรือขวา
                'width': 750,
                'height': 300,
                'pieHole': 0.4, //,มีรู



            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chart_div1'));
            chart.draw(data, options);
        }
        // Callback that draws the pie chart for Anthony's pizza.
        function drawAnthonyChart1() {

            // Create the data table for Anthony's pizza.
            var data = google.visualization.arrayToDataTable([
                ['Name', 'Amount'],
                <?php
                $query = "SELECT `requester`, COUNT(*) AS totalStatus
                FROM work
                GROUP BY requester
                ORDER BY requester;";
                $result = mysqli_query($conn, $query);
                while ($re = mysqli_fetch_array($result)) {
                    echo "['" . $re['requester'] . "'," . $re['totalStatus'] . "],";
                }
                ?>
            ]);

            // Set options for Anthony's pie chart.
            var options = {
                title: 'จำนวนงานรายบุคคล',
                is3D: true, //3D
                width: 700,
                height: 300
            };

            // Instantiate and draw the chart for Anthony's pizza.
            var chart = new google.visualization.BarChart(document.getElementById('Anthony_chart_div1'));
            chart.draw(data, options);
        }
    </script>



    <script>
        //<!-- Fillter -->
        $(document).ready(function() {
            $("#myInput").on("keyup", function() {
                var value = $(this).val().toLowerCase();
                $("#myTable tr").filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });
            });
            // <!-- Fillter -->
            // <!-- Copy -->
            $(document).on('click', '.btncoppy', function() {
                var copyText = $(this).attr("name");
                console.log(copyText);
                var el = $('<input style="position: absolute; bottom: -120%" type="text" value="' +
                    copyText + '"/>').appendTo('body');
                el[0].select();
                document.execCommand("copy");
                el.remove();
            });
        });


        $("#myTable tr").highlight("<?php echo $search; ?>");
    </script>
    <!-- highlight -->