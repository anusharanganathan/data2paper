# Generated via
#  `rails generate hyrax:work Journal`

module Hyrax
  class JournalsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Journal

    def new
      raise CanCan::AccessDenied.new("Not authorized!", :new, Journal) unless current_user.journal_admin?
      super
      curation_concern.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    def create
      raise CanCan::AccessDenied.new("Not authorized!", :create, Journal) unless current_user.journal_admin?
      super
    end

  end
end
