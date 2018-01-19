Blacklight.onLoad(function() {
  $('#data_paper_journal_id').add_license_and_rights();
  $('#data_paper_journal_id').bind('change', function() {
    $(this).add_license_and_rights();
    $(this).check_journal_requirement();
    $('#data-paper-submit-requirements').check_submit_requirements();
  });
});

(function($){

  $.fn.add_license_and_rights = function(option) {
    return this.each(function() {
      var $this = $(this);
      var selected = $this.find(":selected");
      // Add supported_licenses to license drop down
      var supported_licenses = selected.data('supported_license');
      var licenseElement = $('#data_paper_license_nested_attributes_0_webpage');
      licenseElement.children('option:not(:first)').remove();
      $.each( supported_licenses, function( index, value ){
        licenseElement.append(new Option(value, value));
      });
      // Add declaration statements to rights
      var rights = selected.data('declaration_statement');
      $('#data_paper_rights_statement').val(rights);
      // Show checkbox to accept rights
      $('#journal-agreement-active').attr('class', 'show');
      $('#journal-agreement-missing').attr('class', 'hide');
    })
  }

  $.fn.check_journal_requirement = function(option) {
    return this.each(function() {
      var $this = $(this);
      if ($this.val().length != 0) {
        $('#submit-required-journal').attr('class', 'complete');
      } else {
        $('#submit-required-journal').attr('class', 'incomplete');
      }
    })
  }

})(jQuery);
