<?php
  $host_name = 'db5014888842.hosting-data.io';
  $database = 'dbs12368564';
  $user_name = 'dbu2563882';
  $password = 'GestRest2023@';

  $link = new mysqli($host_name, $user_name, $password, $database);

  if ($link->connect_error) {
    die('<p>Error al conectar con servidor MySQL: '. $link->connect_error .'</p>');
  } else {
    echo '<p>Se ha establecido la conexión al servidor MySQL con éxito.</p>';
  }
?>