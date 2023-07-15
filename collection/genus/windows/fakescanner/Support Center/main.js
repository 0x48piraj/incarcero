var audio = new Audio("audio1.mp3");
audio.load();

$(function() {
	$('#exampleModal').modal('show');

});		

window.onbeforeunload = function() {
  return true;
};

$(document).click(function() {
	if(!(audio.duration > 0 && !audio.paused)) {
		audio.play();
	}
});
