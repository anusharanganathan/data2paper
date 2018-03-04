Blacklight.onLoad(function() {
  $('#fileupload').bind('fileuploadcompleted', function (e, data) {
    window.setTimeout(add_type, 500);
  });
});


function add_type() {
  $('.template-download').each(function(index) {
    var ele = $('#file_resource_type > select').clone().removeAttr('id');
    if ($(this).children('td').length < 5) {
      var file_name = $(this).find(".name > input").val();
      var input_name = "data_paper[uploaded_file_types][" + index + "][file_type][]";
      ele.attr('name', input_name);
      var ele2 = $('<input>').attr({
        type: 'hidden',
        name: "data_paper[uploaded_file_types][" + index + "][file_id][]"
      })
      ele2.val(file_name);
      $td = $('<td/>').append(ele2).append(ele);
      $(this).append($td);
    }
  });
}
