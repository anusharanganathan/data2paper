Blacklight.onLoad(function() {
  $('.multi-nested').manage_nested_fields();
});

(function($){
  var DEFAULTS = {
    /* callback to run after add is called */
    add:    null,
    /* callback to run after remove is called */
    remove: null,

    controlsHtml:      '<span class=\"input-group-btn field-controls\">',
    fieldWrapperClass: '.field-wrapper',

    warningClass:      '.has-warning',
    listClass:         '.listing',
    fieldWrapperClass: '.field-wrapper',
    removeInputClass:   '.remove-hidden',

    addHtml:           '<button type=\"button\" class=\"btn btn-link add\"><span class=\"glyphicon glyphicon-plus\"></span><span class="controls-add-text"></span></button>',
    addText:           'Add another',

    // removeHtml:        '<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span><span class="controls-remove-text"></span> <span class=\"sr-only\"> previous <span class="controls-field-name-text">field</span></span></button>',
    // removeText:         'Remove',

    labelControls:      true,
  }

  $.fn.manage_nested_fields = function(option) {
    // var nested_editor = require('./nested_field_manager')
    return this.each(function() {
      var $this = $(this);
      var data  = $this.data('manage_nested_fields');
      var options = $.extend({}, DEFAULTS, $this.data(), typeof option == 'object' && option);

      if (!data) $this.data('manage_nested_fields', (data = new NestedFieldManager(this, options)));
    })
  }

})(jQuery);
