module Hyrax
  class ListJournalsController < ApplicationController
    include Hydra::Catalog

    layout 'dashboard'

    def search_builder_class
      Hyrax::JournalsSearchBuilder
    end

    ListJournalsController.append_view_path("views/hyrax/my")
  
    def index
      add_breadcrumb t(:'hyrax.controls.home'), root_path  
      @user = current_user
      (@response, @document_list) = query_solr

      respond_to do |format|
        format.html {}
        format.rss  { render layout: false }
        format.atom { render layout: false }
      end

    end

    private

      def query_solr
        search_results(params)
      end

      def search_action_url(*args)
        hyrax.my_works_url(*args)
      end

  end
end
