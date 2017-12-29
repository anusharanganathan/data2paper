# Generated via
#  `rails generate hyrax:work DataPaper`
require "./lib/vocabularies/datapaper_terms"
require "./lib/vocabularies/rioxx_terms"
class DataPaper < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = DataPaperIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your data paper must have a title.' }

  self.human_readable_type = 'Data paper'

  property :creator_nested, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"PersonStatement"

  property :date, predicate: ::RDF::Vocab::DC.date, class_name:"DateStatement"

  property :relation, predicate: ::RDF::Vocab::DC.relation, class_name:"RelationStatement"

  property :tagged_version, predicate: ::RDF::Vocab::RioxxTerms.version, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :license_nested, predicate: ::RDF::Vocab::DC.license, class_name:"LicenseStatement"

  property :statement_agreed, predicate: ::RDF::Vocab::DatapaperTerms.agreementAccepted, multiple: false do |index|
    index.as :symbol, :stored_sortable
  end

  property :note, predicate: ::RDF::Vocab::BIBO.Note, multiple: false do |index|
    index.as :stored_searchable
  end

  property :status, predicate: ::RDF::Vocab::BIBO.status, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  # data paper belongs to journal
  belongs_to :journal, predicate: ::RDF::Vocab::DC.references
  # TODO: Add type to files model

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include DataPaperNestedAttributes
end
# -----------------------------------------
# Not needed        # Existing
#   based_near      #   title
#   creator         #   description
#   contributor     #   keyword
#   date_created    #   subject
#   identifier      #   rights_statement
#   language        #   source
#   license         #
#   publisher       # Files
#   related_url     #   Data paper
#   resource_type   #   Supplementary file
#                   #   metadata file
# -----------------------------------------
# Fields in order
#   title
# * creator_nested - facet
#   description (abstract)
#   keyword - facet
#   subject - facet
# * date
# * relation
# * tagged_version - facet
#   source
# * license_nested
#   rights_statement
# * statement_agreed
# * note
# * status - facet
# -----------------------------------------
