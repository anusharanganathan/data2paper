class RelationStatementInput < NestedAttributesInput

protected

  def build_components(attribute_name, value, index, options)
    out = ''

    relation_statement = value

    # Inherit required for fields validated in nested attributes
    required  = false
    if object.required?(:relation) and index == 0
      required = true
    end

    # --- label
    field = :label
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = relation_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Title', required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    # --- url
    field = :url
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = relation_statement.send(field).first

    out << "<div class='row'>"
    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, field.to_s.humanize, required: required)
    out << '  </div>'

    out << "  <div class='col-md-9'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'
    out << '</div>' # row

    # # --- identifier
    # field = :identifier
    # field_value = relation_statement.send(field).first
    # field_id = id_for(attribute_name, index, field)
    # field_name = name_for(attribute_name, index, field)

    # out << "<div class='row'>"
    # out << "  <div class='col-md-3'>"
    # out << template.label_tag(field_name, field.to_s.humanize, required: false)
    # out << '  </div>'

    # out << "  <div class='col-md-9'>"
    # out << @builder.text_field(field_name,
    #     options.merge(value: field_value, name: field_name, id: field_id, required: false))
    # out << '  </div>'
    # out << '</div>' # row

    # last row
    out << "<div class='row'>"

    # --- relationship_name
    field = :relationship_name
    field_name = name_for(attribute_name, index, field)
    field_id = id_for(attribute_name, index, field)
    field_value = relation_statement.send(field).first

    out << "  <div class='col-md-3'>"
    out << template.label_tag(field_name, 'Relationship', required: required)
    out << '  </div>'

    out << "  <div class='col-md-6'>"
    out << @builder.text_field(field_name,
        options.merge(value: field_value, name: field_name, id: field_id, required: required))
    out << '  </div>'

    # --- delete checkbox
    field_label ='Related work'
    out << "  <div class='col-md-3'>"
    out << destroy_widget(attribute_name, index, field_label)
    out << '  </div>'

    out << '</div>' # last row
    out
  end
end
