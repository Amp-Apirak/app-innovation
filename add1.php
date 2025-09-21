

    <!-- Start Configrate  -->
    <?php
    include("connection/connection.php");
    ?>
    <!-- End Configrate  -->

    <!-- sweetalert -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">


    <?php
    if (isset($_POST['submit'])) { /* ถ้า POST มีการกด Submit ให้ทำส่วนล่าง */

        $work_type  = $_POST['work_type']; /* ประกาศตัวแปลเก็บค่า  POST ที่รับมาจาก INPUT  */
        $work_type = $_POST['work_type'];
        $service = $_POST['service_name'];
        $category = $_POST['category_name'];
        $items = $_POST['items_name'];
        $subject = $_POST['subject'];
        $status = $_POST['status'];
        $detail = $_POST['detail'];
        $device_name = $_POST['device_name'];
        $requester = $_POST['requester'];
        $staff_crt = $_POST['staff_crt'];
        $project_name = $_POST['project_name'];
        $date_crt = $_POST['date_crt'];



        $target_dir = "../pms/example/";
        $target_file = $target_dir . basename($_FILES["file_im1"]["name"]);
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

        $target_dir1 = "../pms/example/";
        $target_file1 = $target_dir1 . basename($_FILES["file_im2"]["name"]);
        $imageFileType1 = strtolower(pathinfo($target_file1, PATHINFO_EXTENSION));
        $file_im2 = $_FILES["file_im2"]["name"] ;

        $target_dir3 = "../pms/example/";
        $target_file3 = $target_dir3 . basename($_FILES["file_im3"]["name"]);
        $imageFileType3 = strtolower(pathinfo($target_file3, PATHINFO_EXTENSION));
        $file_im3 = $_FILES["file_im3"]["name"] ;
        
        $target_dir4 = "../pms/example/";
        $target_file4 = $target_dir4 . basename($_FILES["file_im4"]["name"]);
        $imageFileType4 = strtolower(pathinfo($target_file4, PATHINFO_EXTENSION));
        $file_im4 = $_FILES["file_im4"]["name"] ;


        //printf($target_file1);

        // Check if $uploadOk is set to 0 by an error
        if ($imageFileType == " " ) {

            //echo "Sorry, your file was not uploaded.";
            echo '<script>
                    setTimeout(function(){
                        swal({
                            title: "Sorry, your file was not uploaded.",
                            text: "Please check the file name.",
                            type:"warning"
                        }, function(){
                            window.location = "doc_add.php";
                        })
                    },1000);
                </script>';
            // echo "<script>alert('ยินดีตอนรับ Admin เข้าสู่ระบบ'); window.location='../index.php'</script>
        //}

        // Check if file already exists
        // if (file_exists($target_file)) {

        //     //echo "Sorry, file already exists.";
        //     // <!-- sweetalert -->
        //     echo '<script>
        //             setTimeout(function(){
        //                 swal({
        //                     title: "Sorry, file already exists.",
        //                     text: "Please check the file name.",
        //                     type:"warning"
        //                 }, function(){
        //                     window.location = "add.php";
        //                 })
        //             },1000);
        //         </script>';
            // echo "<script>alert('ยินดีตอนรับ Admin เข้าสู่ระบบ'); window.location='../index.php'</script>";
        } else {

            $file_im1 = $_FILES['file_im1']['name'];
            $file_tmp = $_FILES['file_im1']['tmp_name'];
            move_uploaded_file($file_tmp, "../pms/example/$file_im1");

            $file_im2 = $_FILES['file_im2']['name'];
            $file_tmp1 = $_FILES['file_im2']['tmp_name'];
            move_uploaded_file($file_tmp1, "../pms/example/$file_im2");

            $file_im3 = $_FILES['file_im3']['name'];
            $file_tmp3 = $_FILES['file_im3']['tmp_name'];
            move_uploaded_file($file_tmp3, "../pms/example/$file_im3");

            $file_im4 = $_FILES['file_im4']['name'];
            $file_tmp4 = $_FILES['file_im4']['tmp_name'];
            move_uploaded_file($file_tmp4, "../pms/example/$file_im4");



            $sql = "INSERT INTO `work` (`work_id`, `work_type`,`service`, `category`, `date_crt`,
            `items`, `file_im1`,`device_name`, `subject`, `status`,`detail`,`requester`,`staff_crt`,
            `file_im2`,`project_name`,`file_im3`,`file_im4`)
            VALUES (NULL, '$work_type', '$service', '$category', '$date_crt', '$items', '$file_im1', '$device_name',
             '$subject', '$status', '$detail', '$requester', '$staff_crt','$file_im2','$project_name','$file_im3','$file_im4')";



            $result = $conn->query($sql);

            //print_r($sql);

            if ($result) {
                // <!-- sweetalert -->
                echo '<script>
                        setTimeout(function(){
                            swal({
                                title: "Save data successfully",
                                text: "Thank You . ",
                                type:"success"
                            }, function(){
                                window.location = "index.php";
                            })
                        },1000);
                   </script>';

                $sToken = "tWqvxinV7NsZKTMs544JF5uMJsdsvjDUIxyLT25iDEZ"; 
                $sMessage = "👉 ".$staff_crt." **Open Ticket** \n\n";

                $sMessage .= "Category: ".$category." \n";
                $sMessage .= "Type: ".$work_type." \n";
                $sMessage .= "Items: ".$items." \n";
                $sMessage .= "-------------------------- \n";
                $sMessage .= "📌 Status : ".$status." 📌\n";
                $sMessage .= "-------------------------- \n";
                $sMessage .= "👉 Owner: ".$requester." \n";
                $sMessage .= "📢 Subject : ".$subject."\n\n";

                   
       
                   $sMessage .= "ติดตามงานได้ที่ Link Web: http://iss.pointit.co.th/pms/index.php \n";
       
       
                   $chOne = curl_init(); 
                   curl_setopt( $chOne, CURLOPT_URL, "https://notify-api.line.me/api/notify"); 
                   curl_setopt( $chOne, CURLOPT_SSL_VERIFYHOST, 0); 
                   curl_setopt( $chOne, CURLOPT_SSL_VERIFYPEER, 0); 
                   curl_setopt( $chOne, CURLOPT_POST, 1); 
                   curl_setopt( $chOne, CURLOPT_POSTFIELDS, "message=".$sMessage); 
                   $headers = array( 'Content-type: application/x-www-form-urlencoded', 'Authorization: Bearer '.$sToken.'', );
                   curl_setopt($chOne, CURLOPT_HTTPHEADER, $headers); 
                   curl_setopt( $chOne, CURLOPT_RETURNTRANSFER, 1); 
                   $resultt1 = curl_exec( $chOne ); 
       
                // echo "<script>alert('ยินดีตอนรับ Admin เข้าสู่ระบบ'); window.location='../index.php'</script>";
            } else {
                // <!-- sweetalert -->
                echo '<script>
                                            setTimeout(function(){
                                                swal({
                                                    title: "Can Not Save Successfully!",
                                                    text: "Checking Your Data",
                                                    type:"warning"
                                                }, function(){
                                                    window.location = "add.php";
                                                })
                                            },1000);
                                        </script>';
                // echo "<script>alert('ยินดีตอนรับ Admin เข้าสู่ระบบ'); window.location='../index.php'</script>";
            }
        }
    }
    // echo '<pre>';
    // print_r($_POST);
    // print_r($_FILES);
    // echo '</pre>';
    ?>


<!-- sweetalert -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert-dev.min.js"></script>