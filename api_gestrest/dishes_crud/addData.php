<?php

    error_reporting(0);
    include('../connect.php');

    $name = $_POST['name'];
    $idFamily = '11';

    if(empty($name)){
        echo json_encode("null");
    }else{
        $sql = "INSERT INTO `dishes` (`name`,`idFamily`) values ('$name','$idFamily')";
        $result = $con->query($sql);

        if($result){
            echo json_encode("done");
        }else{
            echo json_encode("fail");
        }
    }
?>