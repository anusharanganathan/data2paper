class AccountAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      account = []
      if v.include?('account_type') and not v['account_type'][0].blank?
        account << "Type: #{link_to(ERB::Util.h(v['account_type'][0]), search_path(v['account_type'][0]))}"
      end
      if v.include?('account_name') and not v['account_name'].blank? and not v['account_name'][0].blank?
        account << "Name: #{v['account_name'][0]}"
      end
      if v.include?('service_homepage') and not v['service_homepage'].blank? and not v['service_homepage'][0].blank?
        account << "Service homepage: #{link_to(ERB::Util.h(v['service_homepage'][0], v['service_homepage'][0]))}"
      end
      if v.include?('service_email') and not v['service_email'].blank? and not v['service_email'][0].blank?
        account << "Service email: #{v['service_email'][0]}"
      end
      if v.include?('service_format') and not v['service_format'].blank? and not v['service_format'][0].blank?
        account << "Service format: #{v['service_format'][0]}"
      end
      if v.include?('service_key') and not v['service_key'].blank? and not v['service_key'][0].blank?
        account << "Service key: #{v['service_key'][0]}"
      end
      html << account.join('<br>')
    end
    html = html.join('<br/><br/>')
    %(#{html})
  end
end
