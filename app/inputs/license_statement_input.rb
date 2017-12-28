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

      # --- webpage
      field = :webpage
      field_name = name_for(attribute_name, index, field)
      field_id = id_for(attribute_name, index, field)
      field_value = license_statement.send(field).first
      active_options = Hyrax::LicenseService.new.select_active_options

      out << "<div class='row'>"
      out << "  <div class='col-md-3'>"
      out << template.label_tag(field_name, 'License', required: required)
      out << '  </div>'

      out << "  <div class='col-md-9'>"
      out << template.select_tag(field_name,
        template.options_for_select(active_options, field_value),
        prompt: 'Select license', label: '', class: 'select form-control',
        id: field_id, required: required)
      out << '  </div>'
      out << '</div>' # row

      # # --- Definition
      field = :definition
      field_name = name_for(attribute_name, index, field)
      field_id = id_for(attribute_name, index, field)
      field_value = license_statement.send(field).first

      out << "<div class='row'>"
      out << "  <div class='col-md-3'>"
      out << template.label_tag(field_name, 'License statement', required: false)
      out << '  </div>'

      out << "  <div class='col-md-9'>"
      out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false))
      out << '  </div>'
      out << '</div>' # row

      # last row
      out << "<div class='row'>"

      # --- start date
      field = :start_date
      field_name = name_for(attribute_name, index, field)
      field_id = id_for(attribute_name, index, field)
      field_value = license_statement.send(field).first

      out << "  <div class='col-md-3'>"
      out << template.label_tag(field_name, field.to_s.humanize, required: false)
      out << '  </div>'

      out << "  <div class='col-md-6'>"
      out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id,
          data: { provide: 'datepicker' }, required: false))
      out << '  </div>'

      # delete checkbox
      field_label = 'Rights'
      out << "  <div class='col-md-3'>"
      out << destroy_widget(attribute_name, index, field_label)
      out << '  </div>'

      out << '</div>' # last row
      out
    end
end
