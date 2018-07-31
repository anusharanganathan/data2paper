Blacklight.onLoad(function() {
  $(".download_template .waiting").hide();
  $('#download_template').bind('click', function(event) {
    event.preventDefault();
    get_template_for_journal(event);
  });
});


// Fetch the template for the journal chosen in form.
// Form has to be saved for the latest descriptions to be used in the template
function get_template_for_journal(event) {
  var href = event.target.href;
  var journal = $('#data_paper_journal_id').val();
  href = href + "?journal="+ journal;
  document.location = href;
}

