class LicenseStatement < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::DC.RightsStatement
  # license name
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
  # license definition
  property :definition, predicate: ::RDF::Vocab::SKOS.definition
  # license uri
  property :webpage, predicate: ::RDF::Vocab::FOAF.page
  # license start date
  property :start_date, predicate: ::RDF::Vocab::DISCO.startDate

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#rights#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
