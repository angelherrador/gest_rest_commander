<?php

    error_reporting(0);
    include('../connect.php');

    $id = $_POST['id'];

    //sólo borrar platos de familia Fogones
    $sql = "DELETE FROM `dishes` WHERE `id` = '$id' AND `idFamily` = 11";
    $result = $con->query($sql);

    if($result){
        echo json_encode("done");
    }else{
        echo json_encode("fail");
    }
?>