class NestedCreatorAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  private
  def li_value(value)
    value = JSON.parse(value)
    html = []
    value.each do |v|
      creator = []
      creator_name = []
      if v.include?('first_name') and not v['first_name'].blank?
        creator_name = v['first_name']
      end
      if v.include?('last_name') and not v['last_name'].blank?
        creator_name += v['last_name']
      end
      creator_name = creator_name.join(' ').strip
      if v.include?('name') and not v['name'][0].blank?
        creator << link_to(ERB::Util.h(v['name'][0]), search_path(v['name'][0]))
      elsif creator_name
        creator << link_to(ERB::Util.h(creator_name), search_path(creator_name))
      end
      if v.include?('affiliation') and not v['affiliation'].blank? and not v['affiliation'][0].blank?
        creator << "Affiliation: #{v['affiliation'][0]}"
      end
      if v.include?('orcid') and not v['orcid'].blank? and not v['orcid'][0].blank?
        creator << "Orcid: #{v['orcid'][0]}"
      end
      if v.include?('role') and not v['role'].blank? and not v['role'][0].blank?
        creator << "Role: #{v['role'][0]}"
      end
      html << creator.join('<br>')
    end
    html = html.join('<br/><br/>')
    %(#{html})
  end
end
