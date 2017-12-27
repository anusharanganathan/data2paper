class AccountStatement < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::FOAF.OnlineAccount

  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
  property :account_type, predicate: ::RDF::DC.type
  property :account_name, predicate: ::RDF::Vocab::FOAF.accountName
  property :service_homepage, predicate: ::RDF::Vocab::FOAF.accountServiceHomepage
  property :service_email, predicate: ::RDF::Vocab::DatapaperTerms.accountServiceEmail
  property :service_format, predicate: ::RDF::DC.instructionalMethod
  property :service_key, predicate: ::RDF::Vocab::DatapaperTerms.accountServiceKey


  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#account#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
