require "./lib/vocabularies/datapaper_terms"
class ContactStatement < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::VCARD.Contact
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
  property :email, predicate: ::RDF::Vocab::VCARD.hasEmail
  property :address, predicate: ::RDF::Vocab::VCARD.hasAddress
  property :telephone, predicate: ::RDF::Vocab::VCARD.hasTelephone

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#contact#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
