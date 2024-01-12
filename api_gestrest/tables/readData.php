<?php

error_reporting(0);
include('../connect.php');

   $idRoom = $_GET['idRoom'] ?? 1;
   $sql = "SELECT * FROM `tables` WHERE `idRoom` = '$idRoom' ORDER BY `number`";
   /*$sql = "SELECT * FROM `tables` WHERE `idRoom` = 2 ORDER BY `number`";
   /*$sql = "UPDATE `waiters` SET `image` = '$image' WHERE `id` = '$id'";*/
   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>