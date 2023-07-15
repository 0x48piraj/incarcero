 function addEvent(obj, evt, fn) {
    if (obj.addEventListener) {
        obj.addEventListener(evt, fn, false);
    } else if (obj.attachEvent) {
        obj.attachEvent("on" + evt, fn);
    }
}

addEvent(document, 'mouseout', function(evt) {
    if (evt.toElement == null && evt.relatedTarget == null) {
        $('.lightbox').slideDown();
    };
});

$('a.close').click(function() {
    $('.lightbox').slideUp();
});
$('body').click(function() {
    $('.lightbox').slideUp();
});
