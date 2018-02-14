class NestedAttributesInput < MultiValueInput

  def input(wrapper_options)
    super
  end

  # def input_type
  #   'multi_value'.freeze
  # end

  protected

    # Delegate this completely to the form.
    # def collection
    #   @collection ||= Array.wrap(object[attribute_name]).reject { |value| value.to_s.strip.blank? }
    # end

    def build_field(value, index)
      options = input_html_options.dup
      if !value.kind_of? ActiveTriples::Resource
        # association = @builder.object.model.send("#{attribute_name}")
        association = @builder.object.model.send(attribute_name)
        value = association.build
      end
      # if value.kind_of? ActiveTriples::Resource
      options[:name] = name_for(attribute_name, index, 'hidden_label'.freeze)
      options[:id] = id_for(attribute_name, index, 'hidden_label'.freeze)

      if value.new_record?
        build_options_for_new_row(attribute_name, index, options)
      else
        build_options_for_existing_row(attribute_name, index, value, options)
      end
      # end

      options[:required] = nil if @rendered_first_element

      options[:class] ||= []
      options[:class] += ["#{input_dom_id} form-control multi-text-field"]
      options[:'aria-labelledby'] = label_id

      @rendered_first_element = true

      out = ''
      out << build_components(attribute_name, value, index, options)
      out << hidden_id_field(value, index) unless value.new_record?
      out
    end

    def destroy_widget(attribute_name, index, field_label="field")
      out = ''
      out << hidden_destroy_field(attribute_name, index)
      out << "    <button type=\"button\" class=\"btn btn-link remove\">"
      out << "      <span class=\"glyphicon glyphicon-remove\"></span>"
      out << "      <span class=\"controls-remove-text\">Remove</span>"
      out << "      <span class=\"sr-only\"> previous <span class=\"controls-field-name-text\"> #{field_label}</span></span>"
      out << "    </button>"
      out
    end

    def hidden_id_field(value, index)
      name = id_name_for(attribute_name, index)
      id = id_for(attribute_name, index, 'id'.freeze)
      hidden_value = value.new_record? ? '' : value.rdf_subject
      @builder.hidden_field(attribute_name, name: name, id: id, value: hidden_value, data: { id: 'remote' })
    end

    def hidden_destroy_field(attribute_name, index)
      name = destroy_name_for(attribute_name, index)
      id = id_for(attribute_name, index, '_destroy'.freeze)
      hidden_value = false
      @builder.hidden_field(attribute_name, name: name, id: id,
        value: hidden_value, data: { destroy: true }, class: 'form-control remove-hidden')
    end

    def build_options_for_new_row(_attribute_name, _index, options)
      options[:value] = ''
    end

    def build_options_for_existing_row(_attribute_name, _index, value, options)
      options[:value] = value.rdf_label.first || "Unable to fetch label for #{value.rdf_subject}"
    end

    def name_for(attribute_name, index, field)
      "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}][]"
    end

    def id_name_for(attribute_name, index)
      singular_input_name_for(attribute_name, index, 'id')
    end

    def destroy_name_for(attribute_name, index)
      singular_input_name_for(attribute_name, index, '_destroy')
    end

    def singular_input_name_for(attribute_name, index, field)
      "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}]"
    end

    def id_for(attribute_name, index, field)
      [@builder.object_name, "#{attribute_name}_attributes", index, field].join('_'.freeze)
    end
end
