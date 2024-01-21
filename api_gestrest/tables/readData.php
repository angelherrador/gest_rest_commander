<?php

error_reporting(0);
include('../connect.php');

   $idRoom = $_GET['idRoom'] ?? 1;
   $sql = "SELECT * FROM `tables`
        WHERE `idRoom` = '$idRoom' ORDER BY `number`";
   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/
   $con->close();
?>