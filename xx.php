<!DOCTYPE html>
<html lang="en">
<?php $menu = "index"; ?>


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CRA | Dashboard</title>


    <!----------------------------- start header ------------------------------->
    <?php include_once("templated/head.php");?>
    <!----------------------------- end header --------------------------------->

    <!----------------------------- start menu ------------------------------->
    <?php include_once("templated/menu.php");?>
    <!----------------------------- end menu --------------------------------->


    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Dashboard</h1>
                    </div><!-- /.col -->
                    <div class="col-sm-6">
                        <ol class="breadcrumb float-sm-right">
                            <li class="breadcrumb-item"><a href="#">Home</a></li>
                            <li class="breadcrumb-item active">Dashboard </li>
                        </ol>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <!-- /.content-header -->

        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <!-- Small boxes (Stat box) -->
                <div class="row">
                    <div class="col-lg-3 col-6">
                        <!-- small box -->
                        <div class="small-box bg-info">
                            <!-- Qeury All Ticket -->
                            <?php 
                                $query = "SELECT tiket_number FROM tb_ticket ORDER BY id_ticket";
                                $result = mysqli_query($conn, $query);
                                $row = mysqli_num_rows($result);                                  
                             ?>

                            <div class="inner">
                                <h3><?php  echo $row; ?></h3>

                                <p>All Ticket</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-cog"></i>
                            </div>
                            <a href="ticket.php" class="small-box-footer">More info <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-6">
                        <!-- small box -->
                        <div class="small-box bg-success">
                            <!-- Qeury Count All Knowledge -->
                            <?php 
                                $query = "SELECT km_id FROM tb_km ORDER BY km_id";
                                $result = mysqli_query($conn, $query);
                                $row_ = mysqli_num_rows($result);                                  
                             ?>

                            <div class="inner">
                                <h3><?php  echo $row_; ?></h3>

                                <p>Count All Knowledge</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-stats-bars"></i>
                            </div>
                            <a href="km.php" class="small-box-footer">More info <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-6">
                        <!-- small box -->
                        <div class="small-box bg-warning">

                            <!-- Qeury Count All Service -->
                            <?php 
                                $query = "SELECT service_id FROM tb_service ORDER BY service_id";
                                $result = mysqli_query($conn, $query);
                                $rs = mysqli_num_rows($result);                                  
                             ?>

                            <div class="inner">
                                <h3><?php  echo $rs; ?></h3>

                                <p>Count All Service</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-person-add"></i>
                            </div>
                            <a href="service.php" class="small-box-footer">More info <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                    <div class="col-lg-3 col-6">
                        <!-- small box -->
                        <div class="small-box bg-danger">

                            <!-- Qeury Count All Service -->
                            <?php 
                                $query = "SELECT id_report FROM tb_report ORDER BY id_report";
                                $result = mysqli_query($conn, $query);
                                $ls = mysqli_num_rows($result);                                  
                             ?>

                            <div class="inner">
                                <h3><?php  echo $ls; ?></h3>

                                <p>Count All Report</p>
                            </div>
                            <div class="icon">
                                <i class="ion ion-pie-graph"></i>
                            </div>
                            <a href="report.php" class="small-box-footer">More info <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <!-- ./col -->
                </div>

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
                                        <div id="chart_div"
                                            style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
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
                                        <div id="Anthony_chart_div"
                                            style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
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



                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Daily ticket</h3>

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
                        <div class="chart">
                            <div id="Anthony_chart"
                                style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;">
                            </div>
                        </div>
                    </div>
                    <!-- /.card-body -->
                </div>
                <!-- /.card -->







            </div><!-- /.container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
    google.charts.load('current', {
        'packages': ['corechart']
    });
    google.charts.setOnLoadCallback(drawChart);
    google.charts.setOnLoadCallback(drawAnthonyChart);
    google.charts.setOnLoadCallback(drawAnthony);

    function drawChart() {

        // Create the data table.
        var data = google.visualization.arrayToDataTable([
            ['Status', 'Amount'],
            <?php 
            $query ="SELECT `status_ticket`, COUNT(*) AS totalStatus
            FROM tb_ticket
            GROUP BY status_ticket
            ORDER BY status_ticket;";
            $result = mysqli_query($conn, $query);
            while ($re = mysqli_fetch_array($result)){
                echo"['".$re['status_ticket']."',".$re['totalStatus']."],";
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
            $query ="SELECT `id_name`, COUNT(*) AS totalStatus
            FROM tb_ticket
            GROUP BY id_name
            ORDER BY id_name;";
            $result = mysqli_query($conn, $query);
            while ($re = mysqli_fetch_array($result)){
                echo"['".$re['id_name']."',".$re['totalStatus']."],";
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

    // Callback that draws the pie chart for Anthony's pizza.
    function drawAnthony() {

        // Create the data table for Anthony's pizza.
        var data = google.visualization.arrayToDataTable([
            ['Name', 'Amount'],
            <?php 
                $query ="SELECT `date_crt`, COUNT(*) AS totalStatus
                FROM tb_ticket
                GROUP BY date_crt
                ORDER BY date_crt;";
                $result = mysqli_query($conn, $query);
                while ($re = mysqli_fetch_array($result)){
        echo"['".$re['date_crt']."',".$re['totalStatus']."],";
    }
?>
        ]);

        // Set options for Anthony's pie chart.
        var options = {
            title: 'จำนวนการเปิดงานรายวัน.',
            width: 700,
            height: 300
        };

        // Instantiate and draw the chart for Anthony's pizza.
        var chart = new google.visualization.ColumnChart(document.getElementById('Anthony_chart'));
        chart.draw(data, options);
    }
    </script>


    <!----------------------------- start menu ------------------------------->
    <?php include_once("templated/footer.php");?>
    <!----------------------------- end menu --------------------------------->