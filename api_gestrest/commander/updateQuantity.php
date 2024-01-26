<?php

    error_reporting(0);
    include('../connect.php');

    $tableNumber = $_POST['tableNumber'];
    $idDish = $_POST['idDish'];
    $quantity = $_POST['quantity'];


    $sql = "UPDATE `commandDetail` SET `quantity` = `quantity` + '$quantity'  WHERE `number` = '$tableNumber' AND `idDish` = '$idDish'";
    $result = $con->query($sql);

    $sql = "DELETE FROM `commandDetail` WHERE `quantity` = '0' AND `number` = '$tableNumber'";
    $result = $con->query($sql);

    if($result){
        echo json_encode("ok update quantity");
    }else{
        echo json_encode("fail update quantity");
    }

    $con->close();

?>