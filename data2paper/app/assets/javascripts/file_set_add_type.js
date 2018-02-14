Blacklight.onLoad(function() {
  $('.file_set_add_type').bind('change', function() {
    var file_url = $(this).data('action');
    var file_name = $(this).data('name');
    
    $.ajax({
      url: file_url,
      headers: {
        Accept : "application/json; charset=utf-8",
        "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      type: 'PUT',
      data: {
        'file_set': { 'resource_type': [ $(this).val() ] }
      },
      success: function(data) {
        msg = 'The file <a href="'+file_url+'">'+file_name+'</a> has been updated.<br/>'
        $('#file_set_add_alert .message').html(msg);
        $('#file_set_add_alert').show();
      }
    });
  });
});


