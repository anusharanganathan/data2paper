# Generated via
#  `rails generate hyrax:work Journal`
require "./lib/vocabularies/datapaper_terms"
class Journal < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = JournalIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your journal must have a title.' }

  self.human_readable_type = 'Journal'

  property :homepage, predicate: ::RDF::Vocab::FOAF.homepage do |index|
    index.as :symbol
  end

  property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
    index.as :stored_searchable, :facetable
  end

  property :review_process, predicate: ::RDF::Vocab::DatapaperTerms.reviewProcess do |index|
    index.as :stored_searchable
  end

  property :average_publish_lead_time, predicate: ::RDF::Vocab::DatapaperTerms.averagePublishLeadTime, multiple: false

  property :article_guidelines, predicate: ::RDF::Vocab::DatapaperTerms.articleGuidelines  do |index|
    index.as :stored_searchable
  end

  property :needs_apc, predicate: ::RDF::Vocab::DatapaperTerms.needsArticleProcessingCharge, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :apc_statement, predicate: ::RDF::Vocab::DatapaperTerms.articleProcessingChargeStatement  do |index|
    index.as :stored_searchable
  end

  property :oa_statement, predicate: ::RDF::Vocab::DatapaperTerms.openAccessStatement do |index|
    index.as :stored_searchable
  end

  property :oa_level, predicate: ::RDF::Vocab::DatapaperTerms.openAccessLevel, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :supported_license, predicate: ::RDF::Vocab::DatapaperTerms.supportedLicense do |index|
    index.as :stored_searchable
  end

  property :declaration_statement, predicate: ::RDF::Vocab::DatapaperTerms.declarationStatement  do |index|
    index.as :stored_searchable
  end

  property :owner, predicate: ::RDF::Vocab::ACL.owner

  property :agent_group, predicate: ::RDF::Vocab::ACL.agentGroup

  property :account, predicate: ::RDF::Vocab::FOAF.account, class_name: "AccountStatement"

  property :contact, predicate: ::RDF::Vocab::DCAT.contactPoint, class_name: "ContactStatement"

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include JournalNestedAttributes

  # Not needed
  #   based_near
  #   creator
  #   contributor
  #   license
  #   related_url
  #   rights_statement

  # Existing
  #   title - Destination archive / journal
  #   identifier
  #   publisher
  #   type of journal - resource_type
  #   description
  #   keyword
  #   subject
  #   language
  #   date_created
  #   source

  # Files
  #   Journal logo
  #   Open access logo - Could be derived based on open access level
  #   template files

end
