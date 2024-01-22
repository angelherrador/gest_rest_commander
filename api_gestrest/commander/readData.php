<?php

error_reporting(0);
include('../connect.php');

   $sql = "SELECT `commandDetail.*`,`dishes.`name`,`dishes`.`image`
   FROM commandDetail left join dishes on commandDetail.idDish=dishes.id";

   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>