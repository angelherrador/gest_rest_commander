<?php
error_reporting(0);
include('../connect.php');

   $sql = "SELECT * FROM `waiters` ORDER BY `name`";
   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);
   $con->close();
   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>