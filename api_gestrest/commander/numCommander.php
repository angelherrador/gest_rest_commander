<?php

error_reporting(0);
include('../connect.php');

   $sql = "SELECT `command` FROM `counters`";
   $result = $con->query($sql);

//   if ($result->num_rows > 0) {
//       $row = $result->fetch_assoc();
//       $command = $row['command'];
//       echo json_encode(['command' => $command]);
//   } else {
//       echo json_encode(['error' => 'No se encontraron resultados']);
//   }

     while($row = $result->fetch_assoc()){
        $data[] = $row['command'];
       }

       echo json_encode($data);

   $con->close();

?>