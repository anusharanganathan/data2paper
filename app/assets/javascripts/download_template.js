Blacklight.onLoad(function() {
  $('#download_template').bind('click', function(event) {
    event.preventDefault();
    var submit_url = $(this).data('action');
    var postData = $(this).closest("form").serialize();
    $.ajax({
      type: 'POST',
      url: submit_url,
      headers: {
        Accept : "application/json; charset=utf-8",
        "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      data: postData,
      success: function(data) {
        msg = 'The form has been submitted'
      }
    });
  });
});

