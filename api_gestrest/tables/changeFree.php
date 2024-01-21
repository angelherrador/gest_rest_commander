<?php

    error_reporting(0);
    include('../connect.php');

    $tableNumber = $_POST['tableNumber'];
    $idTable = $_POST['idTable'];
    $freeValue = $_POST['freeValue'];
    $idWaiter = $_POST['idWaiter'];

    /*$sql = "UPDATE `tables` SET `free` = CASE WHEN `free` = 1 THEN 0 ELSE 1 END WHERE `number` = '$tableNumber'";*/
    $sql = "UPDATE `tables` SET `free` = '$freeValue'  WHERE `number` = '$tableNumber'";
    $result = $con->query($sql);

    //occupied table
    if ($freeValue == '0'){
        $sql = "INSERT INTO `command` (`number`,`idTable`,`idWaiter`) values ('$tableNumber','$idTable','$idWaiter')";
        $result2 = $con->query($sql);
    }else if ($freeValue == '1'){
        // free table => delete command and commandDetail
        $sql = "DELETE FROM `command` WHERE `number` = '$tableNumber'";
        $result2 = $con->query($sql);
        // not necessary, it's deleted by integrity reference automatically
        /*$sql = "DELETE FROM `commandDetail` WHERE `number` = '$tableNumber'";
        $result2 = $con->query($sql);*/
    }

    if($result){
       echo json_encode("ok table");
    }else{
        echo json_encode("fail table");
    }
    /*if($result){
        if($result2){
           echo json_encode("ok table command");
        }else{
            echo json_encode("ok table fail command");
        }
    }else{
        echo json_encode("failTable");
    }*/
    $con->close();

?>