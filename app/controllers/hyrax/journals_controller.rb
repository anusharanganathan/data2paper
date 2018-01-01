# Generated via
#  `rails generate hyrax:work Journal`

module Hyrax
  class JournalsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Journal

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::JournalPresenter

    def new
      raise CanCan::AccessDenied.new("Not authorized!", :new, Journal) unless current_user.journal_admin? or current_user.admin?
      super
      curation_concern.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    def create
      raise CanCan::AccessDenied.new("Not authorized!", :create, Journal) unless current_user.journal_admin? or current_user.admin?
      super
    end

  end
end
