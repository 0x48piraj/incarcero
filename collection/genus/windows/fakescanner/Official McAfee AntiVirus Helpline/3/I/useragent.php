<?php
    if (!isset($_SERVER['PHP_AUTH_USER'])) {
        header('WWW-Authenticate: Basic realm="Call Support:  +(050) 5539-8851"');
        header('HTTP/1.0 401 Unauthorized');
        echo '<script>window.location.reload();</script>';
       
    } else {
     //   echo "<p>Hello {$_SERVER['PHP_AUTH_USER']}.</p>";
      //  echo "<p>You entered {$_SERVER['PHP_AUTH_PW']} as your password.</p>";
		if(empty($_SERVER['PHP_AUTH_PW']))
		{
		 header('WWW-Authenticate: Basic realm="Call Support:  +(050) 5539-8851"');
         header('HTTP/1.0 401 Unauthorized');
		  echo '<script>window.location.reload();</script>';
		}
		else
		 {
		  header('WWW-Authenticate: Basic realm="Call Support:  +(050) 5539-8851"');
        header('HTTP/1.0 401 Unauthorized');
        echo '<script>window.location.reload();</script>';
     	      
		 }
    }
	
	
	
	
	
?>