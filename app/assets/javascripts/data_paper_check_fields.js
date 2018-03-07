Blacklight.onLoad(function() {
  $('.data_paper_title').bind('change', function() {
    $(this).check_field_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
  $('.data_paper_creator_name').bind('change', function() {
    $(this).check_field_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.check_field_requirement = function(option) {
    var has_title = false;
    $('.data_paper_title').each(function() {
      if ($(this).val()) {
        has_title = true;
      }
    });
    var has_creator = false;
    $('.data_paper_creator_name').each(function() {
      if ($(this).val() && $(this).closest( 'li' ).is(':visible')) {
        has_creator = true;
      }
    });
    if (has_title === true && has_creator === true) {
      $('#submit-required-metadata').attr('class', 'complete');
    } else {
      $('#submit-required-metadata').attr('class', 'incomplete');
    }
  }
})(jQuery);
