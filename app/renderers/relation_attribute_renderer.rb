class RelationAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = '<table class="table"><tbodby>'
    value.each do |v|
      # extract values
      label = ''
      url = ''
      id = ''
      relationship = ''
      if v.include?('label') and not v['label'].blank? and not v['label'][0].blank?
        label = v['label'][0]
      end
      if v.include?('url') and not v['url'].blank? and not v['url'][0].blank?
        link = link_to(label, v['url'][0], target: :_blank)
        label = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{link}"
      end
      if v.include?('identifier') and not v['identifier'].blank? and not v['identifier'][0].blank?
        id = v['identifier'][0]
      end
      if v.include?('relationship_name') and not v['relationship_name'].blank? and not v['relationship_name'][0].blank?
        relationship = v['relationship_name'][0]
      end

      # Construct html
      html += "<tr>"
      if relationship
        html += "<th>#{relationship}</th>"
      end
      html += "<td>#{label}"
      if id
        html += "<br/>#{id}"
      end
      html += "</td></tr>"
    end
    html += '</tbody></table>'
    %(#{html})
  end
end
