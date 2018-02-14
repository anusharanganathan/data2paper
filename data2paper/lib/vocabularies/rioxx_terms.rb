module RDF
  module Vocab
    class RioxxTerms < RDF::Vocabulary("http://data2paper.org/vocabularies/rioxxterms#")
      property :apc
      property :author
      property :contributor
      property :funder_id
      property :funder_name
      property :project
      property :publication_date
      property :type
      property :version
      property :version_of_record
    end
  end
end
