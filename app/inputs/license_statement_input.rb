class LicenseStatementInput < NestedAttributesInput

  protected

    # The markup here is also duplicated in app/assets/javascripts/templates/editor/license_statement.hbs
    # Any changes to this markup should also be reflected there as well
    def build_components(attribute_name, value, index, options)
      out = ''

      license_statement = value

      # Inherit required for fields validated in nested attributes
      required  = false
      if object.required?(:license_nested) and index == 0
        required = true
      end

      # last row
      out << "<div class='row'>"

      # --- webpage
      field = :webpage
      field_name = name_for(attribute_name, index, field)
      field_id = id_for(attribute_name, index, field)
      field_value = license_statement.send(field).first
      active_options = []
      out << "  <div class='col-md-3'>"
      out << template.label_tag(field_name, 'License', required: required)
      out << '  </div>'

      out << "  <div class='col-md-6'>"
      out << template.select_tag(field_name,
        template.options_for_select(active_options, field_value),
        prompt: 'Select license', label: '', class: 'select form-control',
        id: field_id, required: required)
      out << '  </div>'

      # delete checkbox
      field_label = 'License'
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label)
      out << '  </div>'

      out << '</div>' # last row
      out
    end
end
