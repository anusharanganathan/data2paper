# Generated via
#  `rails generate hyrax:work DataPaper`
module Hyrax
  class DataPaperForm < Hyrax::Forms::WorkForm
    self.model_class = ::DataPaper

    self.terms -= [
      # Fields not interested in
      :based_near, :creator, :contributor, :date_created, :identifier,
      :language, :license, :publisher, :related_url, :resource_type,
      # Fields interested in, but removing to re-order
      :title, :description, :keyword, :rights_statement, :source, :subject
    ]

    self.terms += [:title, :creator_nested, :description, :keyword, :subject,
      :date, :relation, :tagged_version, :source, :license_nested,
      :rights_statement, :statement_agreed, :note, :status]

    self.required_fields = []

    NESTED_ASSOCIATIONS = [:creator_nested, :date, :relation, :license_nested].freeze

    protected

      def self.permitted_creator_params
        [:id,
         :_destroy,
         {
           first_name: [],
           last_name: [],
           orcid: [],
           role: [],
           affiliation: []
         },
        ]
      end

      def self.permitted_date_params
        [:id,
         :_destroy,
         {
           date: [],
           description: []
         },
        ]
      end

      def self.permitted_relation_params
        [:id,
         :_destroy,
         {
           label: [],
           url: [],
           identifier: [],
           identifier_scheme: [],
           relationship_name: [],
           relationship_role: []
         },
        ]
      end

      def self.permitted_license_params
        [:id,
         :_destroy,
         {
           label: [],
           definition: [],
           webpage: [],
           start_date: []
         },
        ]
      end

      def self.build_permitted_params
        permitted = super
        permitted << { creator_nested_attributes: permitted_creator_params }
        permitted << { date_attributes: permitted_date_params }
        permitted << { relation_attributes: permitted_relation_params }
        permitted << { license_nested_attributes: permitted_license_params }
        permitted
      end

  end
end
