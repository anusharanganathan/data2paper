Blacklight.onLoad(function() {
  $('#fileupload').bind('fileuploadcompleted', function (e, data) {
    window.setTimeout(add_type, 500);
  });
});


function add_type() {
  $('.template-download').each(function(index) {
    var key = $('#file_resource_type').data('key')
    var ele = $('#file_resource_type > select').clone().removeAttr('id');
    if ($(this).children('td').length < 5) {
      var file_name = $(this).find(".name > input").val();
      var input_name = key + "[uploaded_file_types][" + index + "][file_type][]";
      ele.attr('name', input_name);
      var ele2 = $('<input>').attr({
        type: 'hidden',
        name: key + "[uploaded_file_types][" + index + "][file_id][]"
      })
      ele2.val(file_name);
      $td = $('<td/>').append(ele2).append(ele);
      $(this).append($td);
    }
  });
  $('.file_resource_type_select').bind('change', function() {
    $(this).check_file_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
}
