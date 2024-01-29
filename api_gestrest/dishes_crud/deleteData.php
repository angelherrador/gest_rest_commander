<?php

    error_reporting(0);
    include('../connect.php');

    $id = $_POST['id'];

    $sql = "DELETE FROM `dishes` WHERE `id` = '$id'";
    $result = $con->query($sql);

    if($result){
        echo json_encode("done");
    }else{
        echo json_encode("fail");
    }
?>