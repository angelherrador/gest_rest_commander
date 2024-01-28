<?php

    error_reporting(0);
    include('../connect.php');

    $idWaiter = $_POST['idWaiter'];
    $password = $_POST['vPassword'];


    $sql = "SELECT * FROM `waiters` WHERE `id` = '$idWaiter' AND `password` = '$password'";
    $result = $con->query($sql);

    if ($result && $result->num_rows > 0) {
        //echo json_encode("done");
        http_response_code(200);
    }else{
        //echo json_encode("fail");
        http_response_code(401);
    }
?>