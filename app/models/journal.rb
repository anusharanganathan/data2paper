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
    index.as :symbol, :stored_searchable
  end

  property :editor, predicate: ::RDF::Vocab::BIBO.editor do |index|
    index.as :stored_searchable, :facetable
  end

  property :contact, predicate: ::RDF::Vocab::DCAT.contactPoint, class_name: "ContactStatement"

  property :review_process, predicate: ::RDF::Vocab::DatapaperTerms.reviewProcess do |index|
    index.as :stored_searchable
  end

  property :average_publish_lead_time, predicate: ::RDF::Vocab::DatapaperTerms.averagePublishLeadTime, multiple: false do |index|
    index.as :stored_searchable
  end

  property :article_guidelines, predicate: ::RDF::Vocab::DatapaperTerms.articleGuidelines  do |index|
    index.as :stored_searchable
  end

  property :needs_apc, predicate: ::RDF::Vocab::DatapaperTerms.needsArticleProcessingCharge, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :apc_statement, predicate: ::RDF::Vocab::DatapaperTerms.articleProcessingChargeStatement  do |index|
    index.as :stored_searchable
  end

  property :oa_level, predicate: ::RDF::Vocab::DatapaperTerms.openAccessLevel, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :oa_statement, predicate: ::RDF::Vocab::DatapaperTerms.openAccessStatement do |index|
    index.as :stored_searchable
  end

  property :supported_license, predicate: ::RDF::Vocab::DatapaperTerms.supportedLicense do |index|
    index.as :stored_searchable
  end

  property :declaration_statement, predicate: ::RDF::Vocab::DatapaperTerms.declarationStatement  do |index|
    index.as :stored_searchable
  end

  # property :owner, predicate: ::RDF::Vocab::ACL.owner do |index|
  #   index.as :stored_searchable
  # end

  property :agent_group, predicate: ::RDF::Vocab::ACL.agentGroup do |index|
    index.as :stored_searchable
  end

  property :account, predicate: ::RDF::Vocab::FOAF.account, class_name: "AccountStatement"

  property :date, predicate: ::RDF::Vocab::DC.date, class_name:"DateStatement"

  has_many :data_papers

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include JournalNestedAttributes

  def template_files
    members.select{|f| f.resource_type == ['data paper template']}
  end

  def has_template_file?
    if template_files.present?
      true
    else
      false
    end
  end

  def template_file
    template_files.first || nil
  end

end

# -----------------------------------------
# Not needed         # Existing
#   based_near       #   title
#   creator          #   identifier
#   contributor      #   publisher
#   license          #   resource_type
#   related_url      #   description
#   rights_statement #   keyword
#   date_created     #   subject
#                    #   language
#                    #   source
# -----------------------------------------
# Files
#   template files
#   Journal logo
#   Open access logo - Could be derived based on open access level
# -----------------------------------------
# Fields in order
#   title (Destination journal or archive)
#   identifier (ISSN)
# * homepage
#   resource_type (Data journal / Journal accepting data papers)
#   publisher
#   description
#   keyword
#   subject
#   language
# * editor
# * contact
#     name / email / telephone
# * review_process
# * average_publish_lead_time
# * article_guidelines
# * needs_apc - facet
# * apc_statement
# * oa_level - facet
# * oa_statement
# * supported_license
# * declaration_statement
# * owner
# * agent_group
# * account
#     sword / email (account type facet)
# * date (created & modified)
#   source
# -----------------------------------------
