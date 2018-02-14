class ContactStatementInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options)
    out = ''

    contact_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:contact) and index == 0
      required = true
    end

    # --- label
    field = :label
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = contact_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    # --- email
    field = :email
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = contact_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"

    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required, type: 'email'))
    out << '  </div>'
    out << '</div>' # row

    # --- address
    field = :address
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = contact_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_area(field_name,
        options.merge(value: field_value, name: field_name, id: field_id,
            required: required, rows: 5))
    out << '  </div>'
    out << '</div>' # row

    # last row
    out << "<div class='row'>"

    # --- telephone
    field = :telephone
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = contact_statement.send(field).first

    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: false)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: false, type: 'tel'))
    out << '  </div>'

    # --- delete checkbox
    field_label = 'Contact'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
