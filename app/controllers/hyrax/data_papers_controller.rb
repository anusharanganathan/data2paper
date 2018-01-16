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

    def new
      curation_concern.status = 'new'
      super
    end

    def edit
      raise CanCan::AccessDenied.new("Not authorized!", :edit, curation_concern) unless curation_concern.status_allows_edit?
      curation_concern.status = 'draft'
      super
    end

    # TODO: Submit data paper to journal
    #   Throw error if no user email or data paper or data paper journal or data paper journal account service email 
    #   To deliver email: ElsevierMailer.submission_email(user, data_paper).deliver
  end
end
