module Hyrax
  # Added to allow for the Hyrax::My::WorksController to show only things I have deposited
  # If the work went through mediated deposit, I may no longer have edit access to it.
  class JournalsSearchBuilder < My::SearchBuilder
    include Hyrax::FilterByType

    # We remove the access controls filter because we would like all journals to be visible
    # Filter works that are journals
    self.default_processor_chain -= [:add_access_controls_to_solr_params]
    self.default_processor_chain -= [:show_only_resources_deposited_by_current_user]
    self.default_processor_chain +=[:filter_journals]

    def only_works?
      true
    end

    private

      def filter_journals(solr_parameters)
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << "{!terms f=has_model_ssim}Journal"
      end

  end
end
