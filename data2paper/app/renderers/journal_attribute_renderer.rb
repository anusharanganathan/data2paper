class JournalAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    html = []
    if not value.kind_of?(Array)
      value = [value]
    end
    value.each do |v|
      id = v.fetch('id', nil)
      title = v.fetch('title', []).first
      if id.present? and title.present?
        html << "<a href=\"/concern/journals/#{id}\">#{title}</a>"
      end
    end
    # html = '<table class="table"><tbodby>'
    # display = ['title', 'resource_type', 'homepage,', 'editor', 'review_process,', 
    #   'average_publish_lead_time', 'oa_level']
    # # extract values
    # value.each do |v|
    #   display.each do |key|
    #     if v.fetch(key, []).present?
    #       html += "<tr>"
    #       html += "<th>#{key}</th>"
    #       html += "<td>#{v[key]}</td>"
    #       html += "</tr>"

    #     end
    #   end
    # end
    # html += '</tbody></table>'
    html = html.join('<br/><br/>')
    %(#{html})
  end
end
