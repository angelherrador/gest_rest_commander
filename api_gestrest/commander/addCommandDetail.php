<?php

    error_reporting(0);
    include('../connect.php');

    $tableNumber = $_POST['tableNumber'];
    $idDish = $_POST['idDish'];


//    $sql = "INSERT INTO commandDetail (`number`,`idDish`, `quantity`)
//    VALUES ('$tableNumber', '$idDish', 1)
//    ON DUPLICATE KEY UPDATE `quantity` =
//    IF(`number` = '$tableNumber' AND `idDish` = '$idDish', `quantity` + 1, 1)";

    $sql = "INSERT INTO commandDetail (`number`,`idDish`, `quantity`)
    VALUES ('$tableNumber', '$idDish', 1)
    ON DUPLICATE KEY UPDATE quantity = quantity + 1";

    /*$sql = "INSERT INTO `commandDetail` (`number`,`idDish`) values ('$tableNumber','$idDish')";*/
    $result = $con->query($sql);

    if($result){
        echo json_encode("done");
    }else{
        echo json_encode("fail");
    }
?>