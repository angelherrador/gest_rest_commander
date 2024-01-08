<?php

    /*$host = "localhost";
    $user = "root";
    $pass = "";
    $dbname = "project";

    $con = mysqli_connect($host,$user,$pass,$dbname);

    if(!$con){
        echo "not connected";
    }*/

    

    $host = 'db5014888842.hosting-data.io';
    $dbname = 'dbs12368564';
    $user= 'dbu2563882';
    $pass = 'GestRest2023@';

    $con = mysqli_connect($host, $user, $pass, $dbname);

    if(!$con){
        echo "not connected";
    }

    /*$link = new mysqli($host_name, $user_name, $password, $database);

    if ($link->connect_error) {
        die('<p>Error al conectar con servidor MySQL: '. $link->connect_error .'</p>');
    } else {
        echo '<p>Se ha establecido la conexión al servidor MySQL con éxito TOTAL.</p>';
    }*/
?>