# Generated via
#  `rails generate hyrax:work DataPaper`
module Hyrax
  class DataPaperPresenter < Hyrax::WorkShowPresenter
    delegate :creator_nested, :date, :relation, :tagged_version,
      :journal, :license_nested, :statement_agreed, :note, :status,
      to: :solr_document
  end
end
