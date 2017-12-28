class DateStatementInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options)
    out = ''

    date_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:date) and index == 0
      required = true
    end

    # --- description and date - single row
    out << "<div class='row'>"

    # description
    field = :description
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = date_statement.send(field).first
    if object.model_class == ::RdssDataset
        date_options = RdssDateTypesService.select_all_options
    else
        date_options = DateTypesService.select_all_options
    end
    out << "  <div class='col-md-3'>"
    out << template.select_tag(field_name, template.options_for_select(date_options, field_value),
        label: '', class: 'select form-control', prompt: 'choose type', id: field_id)
    out << '  </div>'

    # --- date
    field = :date
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = date_statement.send(field).first

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id,
            data: { provide: 'datepicker' }, required: required))
    out << '  </div>'

    # --- delete checkbox
    field_label = 'Date'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
