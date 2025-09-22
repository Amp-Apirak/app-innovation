<?php 
if (!defined('BASE_URL')) {
    define('BASE_URL', '/app-innovation');
}
if (!defined('BASE_APP')) {
    define('BASE_APP', dirname(__DIR__));
}

      $conn = new mysqli('localhost','root','1234','db_pms'); //ประกาศตัวแปล $conn เก็บค่า การเชื่อมต่อ 
        if ($conn->connect_error) {  //ตรวจสอบเงื่อนไข ฐานข้อมูลเชื่อมต่อได้หรือไม่ หากไม่ให้แสดง error เป็นตัวเลข ออกมา
                die("Connection failed: " . $conn->connect_error);
            } 
            $conn->Set_charset("utf8");
          
?>