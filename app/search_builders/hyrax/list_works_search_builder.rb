module Hyrax
  # Returns all works, either active or suppressed.
  # This should only be used by an admin user
  class ListWorksSearchBuilder < My::SearchBuilder
    include Hyrax::FilterByType
    self.default_processor_chain -= [:only_active_works]
    self.default_processor_chain +=[:filter_data_papers]

    def only_works?
      true
    end

    private

      def filter_data_papers(solr_parameters)
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << "{!terms f=has_model_ssim}DataPaper"
      end
  end
end


