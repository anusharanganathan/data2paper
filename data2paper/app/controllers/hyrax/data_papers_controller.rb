# Generated via
#  `rails generate hyrax:work DataPaper`

module Hyrax
  class DataPapersController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    begin
      Hyrax::CurationConcern.actor_factory.swap Hyrax::Actors::CreateWithFilesActor, Hyrax::Actors::CreateWithFilesAndTypesActor
    rescue RuntimeError => e
      Rails.logger.warn "Could not swap CreateWithFilesActor"
    end

    self.curation_concern_type = ::DataPaper

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::DataPaperPresenter

    def new
      curation_concern.status = 'new'
      super
    end

    def show
      super
      status = presenter.solr_document.fetch('status_ssi','')
      if ['new', 'draft'].include? status
        # TODO: do not hard code path. The path below redirects to generic_works
        # redirect_to edit_hyrax_data_paper_path(:id => params[:id])
        redirect_to "/concern/data_papers/#{params[:id]}/edit?locale=#{params.fetch(:locale, 'en')}"
      end
    end

    def edit
      raise CanCan::AccessDenied.new("Data paper has been submitted!", :edit, curation_concern) unless curation_concern.status_allows_edit?
      curation_concern.status = 'draft'
      super
    end

    # TODO: Submit data paper to journal
    #   Throw error if no user email or data paper or data paper journal or data paper journal account service email 
    #   To deliver email: ElsevierMailer.submission_email(user, data_paper).deliver
  end
end
