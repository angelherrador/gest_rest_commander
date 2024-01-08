<?php

    error_reporting(0);
    include('../connect.php');

    $id = $_POST['id'];
    $name = $_POST['name'];
    $image = $_POST['image'];


    if(empty($name) && empty($image)){
        echo json_encode("null");
    }else if(!empty($image)){
        $sql = "UPDATE `waiters` SET 
            `image` = '$image'
            WHERE `id` = '$id'";
        $result = $con->query($sql);
    }else if(!empty($name)){
        $sql = "UPDATE `waiters` SET 
            `name` = '$name'
            WHERE `id` = '$id'";
        $result = $con->query($sql);
    }else{
        $sql = "UPDATE `waiters` SET 
            `name` = '$name',
            `image` = '$image'
            WHERE `id` = '$id'";

        $result = $con->query($sql);   
    }

    if($result){
        echo json_encode("done");
    }else{
        echo json_encode("fail");
    }
?>