Blacklight.onLoad(function() {
  $('#data_paper_statement_agreed').check_agreement_requirement();
  $('#data_paper_statement_agreed').bind('change', function() {
    $(this).check_agreement_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.check_agreement_requirement = function(option) {
    return this.each(function() {
      var $this = $(this);
      check = $(this).is(":checked");
      if(check) {
        $('#submit-required-agreement').attr('class', 'complete');
      } else {
        $('#submit-required-agreement').attr('class', 'incomplete');
      }
    })
  }

})(jQuery);
