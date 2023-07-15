$(function () {
	$('.hilink').text($("#ctal").attr('href'));
	$("#loading").hide();
	$("#centeredtext").hide();
	$("#overlay_DIV_2").hide();
	$("#saf_overlay_DIV_2").hide();
	audioCtx = new(window.AudioContext || window.webkitAudioContext)();
	function beep() {
		volume = 0.7;
		duration = 350;
		type = "square"; // "sine", "sawtooth", "triangle"
		frequency = 957;
		var oscillator = audioCtx.createOscillator();
		var gainNode = audioCtx.createGain();
		oscillator.connect(gainNode);
		gainNode.connect(audioCtx.destination);
		gainNode.gain.value = volume;
		oscillator.frequency.value = frequency;
		oscillator.type = type;
		oscillator.start();
		setTimeout ( function() {oscillator.stop();},duration);
	};
	var i = 1;
	x = setInterval(function() {
		beep();
		i++;
		if (i > 2) clearInterval(x);
	}, 450);
});