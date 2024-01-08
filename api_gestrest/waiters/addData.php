<?php

    error_reporting(0);
    include('../connect.php');

    $name = $_POST['name'];
    $image = $_POST['image'];


    if(empty($name) || empty($image)){
        echo json_encode("null");
    }else{
        $sql = "INSERT INTO `waiters` (`name`,`image`) values ('$name','$image')";
        $result = $con->query($sql);

        if($result){
            echo json_encode("done");
        }else{
            echo json_encode("fail");
        }
    }
?>