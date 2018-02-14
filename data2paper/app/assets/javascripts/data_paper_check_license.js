Blacklight.onLoad(function() {
  $('#data_paper_license_nested_attributes_0_webpage').bind('change', function() {
    $(this).check_license_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.check_license_requirement = function(option) {
    return this.each(function() {
      var $this = $(this);
      if ($this.val().length != 0) {
        $('#submit-required-license').attr('class', 'complete');
      } else {
        $('#submit-required-license').attr('class', 'incomplete');
      }
    })
  }

})(jQuery);
