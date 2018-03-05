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


// Alternate function - post the form data to the templates controller and generate the template
// Need to save the template file and serve it with another url 
function get_template_on_latest(event) {
  var href = event.target.href;
  var form = $(event.target).closest("form");
  $.ajax({
    type: 'POST',
    url: href,
    headers: {
      Accept : "application/json; charset=utf-8",
      "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
    },
    data: form.serialize(),
    success: function(data) {
      msg = 'The form has been submitted'
    },
    beforeSend: function() {
      $(".download_template .waiting").show();
    },
    error: function(response, textStatus, errorThrown){
      $(".download_template .waiting").hide();
      $('.download_template .template_status').text(response.status);
    },
    complete: function() {
      $(".download_template .waiting").hide();
    }
  });
}


// Alternate function - Save the form data and then fetch the template
// Quick saves of the form will invoke conflict due to actors locking the object
function save_and_get_template(event) {
  var href = event.target.href;
  var form = $(event.target).closest("form");
  $.ajax({
    type: 'POST',
    url: form.attr('action'),
    headers: {
      // Accept : "text/javascript; charset=utf-8",
      Accept : "application/json; charset=utf-8",
      "Content-Type": 'application/x-www-form-urlencoded; charset=UTF-8'
    },
    data: form.serialize(),
    beforeSend: function() {
      $(".download_template .waiting").show();
    },
    success: function() {
      location.reload();
      document.location = href;
    },
    error: function(response, textStatus, errorThrown){
      $(".download_template .waiting").hide();
      $('.download_template .template_status').text(response.status);
    },
    complete: function() {
      $(".download_template .waiting").hide();
    }
  });
}

