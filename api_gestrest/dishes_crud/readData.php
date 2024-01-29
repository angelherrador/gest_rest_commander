<?php

error_reporting(0);
include('../connect.php');

   $sql = "SELECT `dishes`.*, `families`.`directory`,`families`.`id` as `idFamily`,`families`.`name` as `familyName`
   FROM `dishes` LEFT JOIN `families` ON `families`.`id` = `dishes`.`idFamily`
   ORDER BY `dishes`.`idFamily` DESC, `dishes`.`name`";
   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>