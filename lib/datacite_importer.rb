require 'rest-client'

class DataciteImporter
  attr_accessor :filepath 
  attr_reader :doi, :metadata, :data_paper_attributes

  ENDPOINT = "https://api.datacite.org/works/"

  def initialize(import_params)
    unless import_params['doi'].present?
      raise 'Parameter missing DOI'
    end
    @doi = import_params['doi']
    @filepath = nil
    @metadata = nil
    @data_paper_attributes = nil
  end

  def import
    response = RestClient.get URI::join(ENDPOINT, @doi).to_s
    if response.code != 200
      raise 'Error retrieving record'
    end
    @metadata = JSON.parse(response.body)
  end

  def write_metadata
    unless @metadata.present?
      raise 'Metadata missing'
    end
    if @filepath.blank?
      filename = "%s.json" % @doi.gsub('/', '_').gsub(':', '_').gsub('.', '_')
      @filepath = "#{Rails.root}/tmp/#{filename}"
    end
    file = File.open(@filepath, 'w')
    file.write(@metadata)
    file.close()
  end

  def read_metadata
    @metadata = JSON.parse(File.read(@filepath))
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


  def map_json_metadata
    @data_paper_attributes = {}

    # DOI
    doi = @metadata.dig('data', 'attributes', 'doi')

    # identifier
    source = @metadata.dig('data', 'attributes', 'identifier')
    @data_paper_attributes[:source] = [source] unless source.blank?

    # Creators (contributors not returned by rest api)
    creators = []
    @metadata.dig('data', 'attributes', 'author').each do |c|
      creator = {}
      given = c.fetch('given', nil)
      creator[:first_name] = given unless given.blank?
      family = c.fetch('family', nil)
      creator[:last_name] = family unless family.blank?
      name = c.fetch('name', nil) || c.fetch('literal', nil)
      if name.blank? and (given.present? or family.present?)
        name << given if given.present?
        name << family if family.present?
        name = name.join(' ')
      end
      creator[:name] = name unless name.blank?
      creator[:role] = 'creator' unless creator.blank?
      creators << creator unless creator.blank?
    end
    @data_paper_attributes[:creator_nested_attributes] = creators unless creators.blank?

    # Title
    title = @metadata.dig('data', 'attributes', 'title')
    @data_paper_attributes[:title] = [title] unless title.blank?

    # description
    description = @metadata.dig('data', 'attributes', 'description')
    @data_paper_attributes[:description] = [description] unless description.blank?

    # Related object
    related_objects = []
    if doi.present? and source.present? and title.present?
      related_object = {
        label: title,
        url: source,
        identifier: doi,
        identifier_scheme: 'DOI',
        relationship_name: 'Is referenced by',
        relationship_role: 'IsReferencedBy'
      }
      related_objects << related_object
    end
    @data_paper_attributes[:relation_attributes] = related_objects unless related_objects.blank?

    # Not Using
    #   url
    #   container_title (= publisher)
    #   resourceType
    #   license (= rightsURI)
    #   publicationYear
    #   related_identifiers
    #     relation-type-id
    #     related-identifier (= doi as url)
    #   published (= publicationYear)
    #   registered (= minted)
    #   updated_at
    #   data_center_id, data_center
    #   member_id, member (= source organisation)
    #   version
    #   results
    #   schema_version
    #   xml
    #   media
  end

end
