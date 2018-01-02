module Hyrax
  class ShowJournalsController < ApplicationController
    include Hydra::Catalog

    layout 'dashboard'

    def search_builder_class
      Hyrax::JournalsSearchBuilder
    end

    ShowJournalsController.append_view_path("views/hyrax/my")
  
    def index
      # self.class.append_view_path('views/hyrax/my')
      add_breadcrumb t(:'hyrax.controls.home'), root_path  
      # @journals = Journal.all
      @user = current_user
      (@response, @document_list) = query_solr

      puts '----------------------------------------------------'
      puts @document_list
      puts '----------------------------------------------------'

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
