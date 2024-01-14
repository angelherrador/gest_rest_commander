<?php

error_reporting(0);
include('../connect.php');

   /*$sql = "SELECT * FROM `dishes` WHERE `favorite` = 1 ORDER BY `name`";*/
   $sql = "SELECT `dishes`.`id`, `dishes`.`name`, `dishes`.`image`, `dishes`.`kitchen`, `dishes`.`idFamily`, `dishes`.`favorite`, `dishes`.`suggestion`,
        `families`.`directory`
        FROM `dishes` LEFT JOIN `families` ON `families`.`id` = `dishes`.`idFamily`
         WHERE  `dishes`.`favorite` = 1 ORDER BY  `dishes`.`name`";

   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>