$(function(){
    // Enables popover
    $(".journal_image").popover({
        html : true, 
        content: function() {
          return $(this).closest('.gallery-journal').find(".journal_text").html();
        }
    });
});
