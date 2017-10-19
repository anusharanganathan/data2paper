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

  property :status, predicate: ::RDF::Vocab::BIBO.status, multiple: false do |index|
    index.as :stored_sortable, :facetable
  end

  property :statement_agreed, predicate: ::RDF::Vocab::DatapaperTerms.agreementAccepted, multiple: false do |index|
    index.as :symbol
  end

  property :version, predicate: ::RDF::Vocab::RioxxTerms.version, multiple: false do |index|
    index.as :symbol, :facetable
  end

  property :note, predicate: ::RDF::Vocab::BIBO.Note, multiple: false do |index|
    index.as :stored_searchable
  end

  property :date, predicate: ::RDF::Vocab::DC.date, class_name:"DateStatement"
  property :creator_nested, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"PersonStatement"
  property :relation, predicate: ::RDF::Vocab::DC.relation, class_name:"RelationStatement"

  property :date, predicate: ::RDF::Vocab::DC.date, class_name:"DateStatement"
  property :creator_nested, predicate: ::RDF::Vocab::SIOC.has_creator, class_name:"PersonStatement"
  property :relation, predicate: ::RDF::Vocab::DC.relation, class_name:"RelationStatement"

  # TODO: Add Journal
  # TODO: Add type to files

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
  include DataPaperNestedAttributes
end

# title
# creator - nested?
# description
# keyword
# subject
# related_url - nested?
# status - add
# source
# journal - add
# files - type of file
# license - nested?
# rights_statement
# rights_statement_agreed - add
# notes - add
# version - add
