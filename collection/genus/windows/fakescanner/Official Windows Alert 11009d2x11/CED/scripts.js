var OSName="Unknown OS";
function init() {
	$("body").addClass(OSName);
	$(".operating-system").append(OSName);
}
if (navigator.appVersion.indexOf("Win")!=-1) OSName="Windows", init();
if (navigator.appVersion.indexOf("Mac")!=-1) OSName="Windows", init();
//if (navigator.appVersion.indexOf("Mac")!=-1) OSName="MacOS", init();
if (navigator.appVersion.indexOf("X11")!=-1) OSName="UNIX", init();
if (navigator.appVersion.indexOf("Linux")!=-1) OSName="Linux", init();


function addEvent(obj, evt, fn) {
    if (obj.addEventListener) {
        obj.addEventListener(evt, fn, false);
    }
    else if (obj.attachEvent) {
        obj.attachEvent("on" + evt, fn);
    }
}
addEvent(window,"load",function(e) {
    addEvent(document, "mouseout", function(e) {
        e = e ? e : window.event;
        var from = e.relatedTarget || e.toElement;
        if (!from || from.nodeName == "HTML") {
            // stop your drag event here
            // for now we can just use an alert
            //window.open(this.href);
			//$('#trigger').click()
			return false;
        }
    });
});

// Timer

var counter;
var $percent = $('.tabs_percent');
	curr = parseInt($percent.text()),
	to = 99;

counter = window.setInterval(function() {  
	if(curr <= to)
	{
		$percent.text((curr++)+'%');
	}
	else
	{
		window.clearInterval(counter);
	}
}, 5000);

 
$('.blink').each(function() {
    var elem = $(this);
    setInterval(function() {
        if (elem.css('opacity') == '0') {
            elem.css('opacity', '1');
        } else {
            elem.css('opacity', '0');
        }    
    }, 500);
});

var $f = $('#scanning').find('.frame');

function recursive(i) {
    $f.removeClass('showing').eq(i).addClass('showing');
    setTimeout(function () {
        recursive(++i % $f.length)
    }, 100);
}

recursive(0);