Blacklight.onLoad(function() {
  $('#fileupload').bind('fileuploadcompleted', function (e, data) {
    var ele = $('#file_resource_type > select').clone().removeAttr('id');
    $('.template-download').each(function() {
      if ($(this).children('td').length < 5) {
        var file_name = $(this).find(".name > input").val();
        var input_name = "uploaded_file_types[" + file_name + "]";
        ele.attr('name', input_name);
        $td = $('<td/>').append(ele);
        $(this).append($td);
      }
    });
  });
});

