Blacklight.onLoad(function() {
  $('.file_set_add_type').bind('change', function() {
    $(this).check_file_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.check_file_requirement = function(option) {
    check1 = false
    if ($('.related-files').find('.file_set_add_type').filter(function(){return this.value=='data paper'}).length > 0) {
      check1 = true
    }
    check2 = false
    if ($('.files').find('.file_resource_type_select').filter(function(){return this.value=='data paper'}).length > 0) {
      check2 = true
    }
    if (check1 === true || check2 === true) {
      $('#submit-required-files').attr('class', 'complete');
    } else {
      $('#submit-required-files').attr('class', 'incomplete');
    }
  }

})(jQuery);
