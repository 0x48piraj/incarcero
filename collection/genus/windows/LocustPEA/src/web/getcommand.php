<?php
	Error_Reporting(E_ALL & ~E_NOTICE);
$gcmd			=		$_GET['getcmd']; 
 if ($gcmd == 1)
 {
   $cmd = "cmd.txt";
   $fh = fopen($cmd, 'r');
   $cmdData = fread($fh, filesize($cmd));
   fclose($fh);
   echo $cmdData;
 }
 ?>