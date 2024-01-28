<?php

error_reporting(0);
include('../connect.php');


   $numberCommander = $_GET['idTable'] ?? 0;
   $sql = "SELECT `commandDetail`.*,`dishes`.`name`,`dishes`.`image`,
   `families`.`directory`,`families`.`id` as `idFamily`
   FROM `commandDetail` LEFT JOIN `dishes` on `commandDetail`.`idDish` = `dishes`.`id`
   LEFT JOIN `families` ON `families`.`id` = `dishes`.`idFamily`
   WHERE  `commandDetail`.`number` = '$numberCommander' ORDER BY `families`.`id`";


   $result = $con->query($sql);

   while($row = $result->fetch_assoc()){
    $data[] = $row;
   }

   echo json_encode($data);

   /*echo "<pre>";
   print_r ($data);
   echo "<pre>";*/

?>