<?php

    error_reporting(0);
    include('../connect.php');

    $tableNumber = $_POST['tableNumber'];
    $idTable = $_POST['idTable'];
    $idWaiter = $_POST['idWaiter'];

    $sql = "INSERT INTO `command` (`number`,`idTable`,`idWaiter`) values ('$tableNumber','$idTable','$idWaiter')";
    $result = $con->query($sql);

    if($result){
        echo json_encode("ok command");
    }else{
        echo json_encode("fail command");
    }
    $con->close();
?>