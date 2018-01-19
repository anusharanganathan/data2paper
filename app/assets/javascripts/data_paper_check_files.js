Blacklight.onLoad(function() {
  $('.file_set_add_type').bind('change', function() {
    $(this).check_file_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.check_file_requirement = function(option) {
    return this.each(function() {
      if ($('.related-files').find('.file_set_add_type').filter(function(){return this.value=='data paper'}).length > 0) {
        $('#submit-required-files').attr('class', 'complete');
      } else {
        $('#submit-required-files').attr('class', 'incomplete');
      }
    })
  }

})(jQuery);
