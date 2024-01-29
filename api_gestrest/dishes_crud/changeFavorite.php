 <?php

     error_reporting(0);
     include('../connect.php');

     $idDish = $_POST['idDish'];

     $sql = "UPDATE `dishes` SET `favorite` = CASE WHEN `favorite` = 1 THEN 0 ELSE 1 END WHERE `id` = '$idDish'";
     $result = $con->query($sql);

     if($result){
        echo json_encode("ok");
     }else{
         echo json_encode("fail");
     }

     $con->close();

 ?>