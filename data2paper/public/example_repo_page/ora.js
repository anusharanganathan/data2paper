$(function() {
	$('.visitd2p').hide();
        $('.d2perror').hide();
        $('.d2perror').text('');

	// Get the form.
	var form = $('#data2paper-form');

	// Set up an event listener for the contact form.
	$(form).submit(function(e) {
		// Stop the browser from submitting the form.
		e.preventDefault();

		// Serialize the form data.
		var formData = $(form).serialize();
                var authorizationToken = 'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.oJN7SjJacKdu-u77O4jDmm4jRlrFfsvbcBeqdHAB7c0'
		// Submit the form using AJAX.
		$.ajax({
			type: 'POST',
			beforeSend: function(request) {
				request.setRequestHeader("Authorization", authorizationToken);
                        },
			url: $(form).attr('action'),
			data: formData
		})
		.done(function(response) {
                        $('.visitd2p').show();
                        $('.composed2p').hide();
		})
		.fail(function(data) {
                        $('.d2perror').show();
			// Set the message text.
			/* if (data.responseText !== '') {
				$('.d2perror').text(data.responseText);
			} else {
				$('.d2perror').text('Oops! An error occured and the your details could not be sent.');
			}*/
			$('.d2perror').text('Oops! An error occured and the your details could not be sent.');

		});

	});

});
