<?php
include '../connection.php';

$waiterName = $_POST['name'];
$waiterImage = $_POST['image'];
$waiterPass = md5($_POST['password']);

$sqlQuery = 'SELECT id, name, image, password FROM waiters';

$result = $link->query($sqlQuery);

if($result -> num_rows > 0){
    echo json_encode(array("success"=>true));
}else{
    echo json_encode(array("success"=>false));
}
?>video 21