class RelationStatement < ActiveTriples::Resource
  include CommonMethods

  configure type: ::RDF::Vocab::PROV.Association
  property :label, predicate: ::RDF::Vocab::SKOS.prefLabel
  property :url, predicate: ::RDF::Vocab::MODS.locationUrl
  property :identifier, predicate: ::RDF::Vocab::DataCite.hasIdentifier
  property :identifier_scheme, predicate: ::RDF::Vocab::DataCite.usesIdentifierScheme
  property :relationship_name, predicate: ::RDF::Vocab::MODS.roleRelationshipName
  property :relationship_role, predicate: ::RDF::Vocab::MODS.roleRelationshipRole

  ## Necessary to get AT to create hash URIs.
  def initialize(uri, parent)
    if uri.try(:node?)
      uri = RDF::URI("#relation#{uri.to_s.gsub('_:', '')}")
    elsif uri.start_with?("#")
      uri = RDF::URI(uri)
    end
    super
  end

end
