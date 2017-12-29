class NestedLicenseAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  private
  def attribute_value_to_html(value)
    value = JSON.parse(value)
    if not value.kind_of?(Array)
      value = [value]
    end
    html = []
    value.each do |v|
      row = []
      # extract values
      label = ''
      webpage = ''
      license = ''
      if v.include?('label') and not v['label'].blank? and not not v['label'][0].blank?
        label = v['label'][0]
      end
      if v.include?('webpage') and not v['webpage'].blank? and not v['webpage'][0].blank?
        webpage = v['webpage'][0]
      end
      license = license_attribute_to_html(label, webpage)
      if license
        row << license
      end
      if v.include?('start_date') and not v['start_date'].blank? and not v['start_date'][0].blank?
        val = Date.parse(v['start_date'][0]).to_formatted_s(:standard)
        row << "Start date: #{val}"
      end
      if v.include?('definition') and not v['definition'].blank? and not v['definition'][0].blank?
        row << v['definition'][0]
      end
      html << row.join('<br>')
    end
    html = html.join('<br/><br/>')
    %(#{html})
  end

  def license_attribute_to_html(label, value)
    begin
      parsed_uri = URI.parse(value)
    rescue
      nil
    end
    if label.blank? and !value.blank?
      label = Hyrax::LicenseService.new.label(value)
    end
    if label.nil?
      nil
    elsif parsed_uri.nil? and !label.blank?
      "#{ERB::Util.h(label)}"
    else
      "<a href=#{ERB::Util.h(value)} target=\"_blank\">#{label}</a>"
    end
  end
end
