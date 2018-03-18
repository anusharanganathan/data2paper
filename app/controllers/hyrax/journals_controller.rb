# Generated via
#  `rails generate hyrax:work Journal`
require 'scholix_importer'

module Hyrax
  class JournalsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    begin
      Hyrax::CurationConcern.actor_factory.swap Hyrax::Actors::CreateWithFilesActor, Hyrax::Actors::CreateWithFilesAndTypesActor
    rescue RuntimeError => e
      Rails.logger.warn "Could not swap CreateWithFilesActor"
    end

    self.curation_concern_type = ::Journal

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::JournalPresenter

    def new
      raise CanCan::AccessDenied.new("Not authorized!", :new, Journal) unless current_user.journal_admin?
      super
      curation_concern.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    def show
      super
      if presenter.title.present?
        publisher = presenter.title.first.downcase
        publisher[0] = publisher[0].capitalize
        s = ScholixImporter.new()
        @publications = s.linksFromPublishers(publisher)
      end
    end

    def create
      raise CanCan::AccessDenied.new("Not authorized!", :create, Journal) unless current_user.journal_admin?
      super
    end

  end
end
