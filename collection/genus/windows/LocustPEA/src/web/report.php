<?php
$good = "good.txt";/*not behind router*/
$raw  = "raw.txt";/*behind router but upnp is enabled*/
$ip = $_SERVER['REMOTE_ADDR'];
$port = $_GET['p'];
$network = $_GET['n'];
if($network == 1)
{
$fp  = fopen( "$raw",  "a");
fputs( $fp, $ip.":".$port."\n" );
fclose( $fp );
}
else
$fp2 = fopen( "$good", "a" );
fputs( $fp2, $ip.":".$port."\n" );
fclose( $fp2 );
?>
