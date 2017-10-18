# Generated via
#  `rails generate hyrax:work DataPaper`

module Hyrax
  class DataPapersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::DataPaper

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DataPaperPresenter
  end
end
