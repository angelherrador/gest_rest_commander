<?php
    $host = 'db5014888842.hosting-data.io';
    $dbname = 'dbs12368564';
    $user= 'dbu2563882';
    $pass = 'GestRest2023@';

    /*$host = 'qais720.cepfrada.com';
    $dbname = 'qais720';
    $user= 'qais720';
    $pass = 'GestRest2023@';*/

    $con = mysqli_connect($host, $user, $pass, $dbname);

    if(!$con){
        echo "not connected";
    }
?>