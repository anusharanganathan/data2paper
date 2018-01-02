$(function(){
    // Enables popover
    $(".journal_image").popover({
        html : true, 
        content: function() {
          return $(this).closest('.gallery_journal').find(".journal_text").html();
        }
    });
});
