class NestedDateAttributeRenderer < Hyrax::Renderers::DateAttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = '<table class="table"><tbodby>'
    value.each do |v|
      label = ''
      val = ''
      if v.include?('description') and not v['description'].blank? and not v['description'][0].blank?
        label = DateTypesService.label(v['description'][0])
      end
      if v.include?('date') and not v['date'].blank? and not v['date'][0].blank?
        val = Date.parse(v['date'][0]).to_formatted_s(:standard)
      end
      html += "<tr><th>#{label}</th><td>#{val}</td><tr>"
    end
    html += '</tbody></table>'
    %(#{html})
  end
end
