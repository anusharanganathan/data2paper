(function($){

  $.fn.check_submit_requirements = function(option) {
    return this.each(function() {
      var incomplete_elements = $('#data-paper-submit-requirements').find('li.incomplete');
      if(incomplete_elements.length > 0) {
        $('#submit_with_files').prop('disabled', true);
      } else {
        $('#submit_with_files').prop('disabled', false);
      }
    })
  }

})(jQuery);
