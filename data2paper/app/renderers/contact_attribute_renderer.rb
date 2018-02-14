class ContactAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      contact = []
      if v.include?('label') and not v['label'][0].blank?
        contact << "Label: #{v['label'][0]}"
      end
      if v.include?('email') and not v['email'].blank? and not v['email'][0].blank?
        contact << "Email: #{v['email'][0]}"
      end
      if v.include?('address') and not v['address'].blank? and not v['address'][0].blank?
        contact << "Address: #{v['address'][0]}"
      end
      if v.include?('telephone') and not v['telephone'].blank? and not v['telephone'][0].blank?
        contact << "Telephone: #{v['telephone'][0]}"
      end
      html << contact.join('<br>')
    end
    html = html.join('<br/><br/>')
    %(#{html})
  end
end
