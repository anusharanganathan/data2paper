class DataciteImporter
  attr_accessor :filepath 
  attr_reader :xml_metadata, :data_paper_attributes

  def initialize(import_params)
    unless import_params[:doi].present?
      raise 'Parameter missing DOI'
    end
    @doi = import_params[:doi]
    @filepath = nil
    @xml_metadata = nil
    @data_paper_attributes = nil
  end

  def import
    dc = Datacite.new(ENV['DATACITE_PREFIX'], ENV['DATACITE_PASSWORD'], Datacite::ENDPOINT)
    @xml_metadata = dc.metadata(@doi)
  end

  def write_xml_metadata
    unless @xml_metadata.present?
      fail 'XML metadata missing'
    end
    unless @filepath.blank?
      filename = "%s.xml" % @doi.gsub('/', '_').gsub(':', '_').gsub('.', '_')
      @filepath = "#{Rails.root}/tmp/#{filename}"
    end
    file = File.open(@filepath, 'w')
    file.write(@xml_metadata)
    file.close()
  end

  def read_xml_metadata
    @xml_metadata = File.read(@filepath)
    # file_name = "10.5072⁄bodleian:nZaoXzEm5.xml"
    # src_file = Rails.root.join("tmp", "test_data", file_name)
    # doc = File.open(src_file) { |f| Nokogiri::XML(f) } # from file
  end

  def map_xml_metadata
    @data_paper_attributes = {}
    
    doc = Nokogiri::XML(@xml_metadata)
    doc.remove_namespaces!
    
    # Identifier
    sources = []
    doi = ''
    doc.xpath('//identifier') .each do |i|
      if i.text.present? and i.attr('identifierType') == "DOI"
        sources << "http://dx.doi.org/#{i.text}"
        doi = i.text
      end
    end
    @data_paper_attributes[:source] = sources unless sources.blank?
     
    # Creators and contributors
    creators = []
    (doc.xpath('//creator') + doc.xpath('//contributor')).each do |c|
      creator = {}
      if c.attr('contributorType').present?
        creator[:role] = c.attr('contributorType')
      else
        creator[:role] = 'creator'
      end
      if c.xpath('creatorName').text.present?
        creator[:name] = c.xpath('creatorName').text
      end
      if c.xpath('givenName').text.present?
        creator[:first_name] = c.xpath('givenName').text
      end
      if c.xpath('familyName').text.present?
        creator[:last_name] = c.xpath('familyName').text
      end
      if c.attr('nameIdentifierScheme') == 'ORCID' and
         c.xpath('nameIdentifier').text.present?
         creator[:orcid] = c.xpath('nameIdentifier').text
      end
      if c.xpath('affiliation').text.present?
        creator[:affiliation] = c.xpath('affiliation').text
      end
      creators << creator unless creator.blank?
    end
    @data_paper_attributes[:creator_nested_attributes] = creators unless creators.blank?
    
    # Title
    titles = []
    doc.xpath('//title').each do |t|
      unless t.attributes.present?
        titles << t.text unless t.text.blank?
      end
    end
    @data_paper_attributes[:title] = titles unless titles.blank?
    
    # subjects
    subjects = []
    doc.xpath('//subject').each do |s|
      subjects << s.text unless s.text.blank?
    end
    @data_paper_attributes[:subject] = subjects unless subjects.blank?
    
    # language
    languages = []
    if doc.xpath('//language').text.present?
      languages << doc.xpath('//language').text
    end
    @data_paper_attributes[:language] = languages unless languages.blank?
    
    # description
    descriptions = []
    doc.xpath('//description').each do |d|
      if d.text.present? and d.attr('descriptionType') == "Abstract"
        descriptions << d.text
      end
    end
    @data_paper_attributes[:description] = descriptions unless descriptions.blank?

    # Related object
    related_objects = []
    if sources.present? and titles.present?
      related_object = {
        label: titles.first,
        url: sources.first,
        identifier: doi,
        identifier_scheme: 'DOI',
        relationship_name: 'Is referenced by',
        relationship_role: 'IsReferencedBy'
      }
      related_objects << related_object
    end
    @data_paper_attributes[:relation_attributes] = related_objects unless related_objects.blank?

    # Not Using     
    #   publisher 
    #   publicationYear
    #   dates
    #   resourceType
    #   alternateIdentifiers
    #   relatedIdentifiers
    #   sizes
    #   formats
    #   version
    #   rightsList
    #   geoLocation
    #   fundingReferences
  end

end
