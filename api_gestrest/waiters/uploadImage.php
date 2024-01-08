<?php

    error_reporting(0);
    include('../connect.php');

    $id = $_POST['id'];
    $image = $_FILES['img']['name'];
    $upload = "../../waiters/".$image;
    
    $tem_name = $_FILES['img']['tmp_name'];

    move_uploaded_file($tem_name, $upload);

    $sql = "UPDATE `waiters` SET `image` = '$image' WHERE `id` = '$id'";
    $result = $con->query($sql);   

    if($result){
        echo json_encode("done");
    }else{
        echo json_encode("fail");
    }
?>