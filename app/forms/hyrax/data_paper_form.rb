# Generated via
#  `rails generate hyrax:work DataPaper`
module Hyrax
  class DataPaperForm < Hyrax::Forms::WorkForm
    self.model_class = ::DataPaper
    self.terms += [:resource_type]
  end
end
