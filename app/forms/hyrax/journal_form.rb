# Generated via
#  `rails generate hyrax:work Journal`
module Hyrax
  class JournalForm < Hyrax::Forms::WorkForm
    self.model_class = ::Journal

    self.terms -= [
      # Fields not interested in
      :based_near, :creator, :contributor, :date_created, :license,
      :related_url, :rights_statement,
      # Fields interested in, but removing to re-order
      :title, :description, :identifier, :keyword, :language,
      :publisher, :resource_type, :source, :subject
    ]

    self.terms += [:title, :identifier, :homepage, :resource_type,
      :publisher, :description, :keyword, :subject, :language,
      :editor, :contact, :review_process, :average_publish_lead_time,
      :article_guidelines, :needs_apc, :apc_statement, :oa_level,
      :oa_statement, :supported_license, :declaration_statement,
      :agent_group, :account, :date, :source
      ]

    self.required_fields = [:title]

    NESTED_ASSOCIATIONS = [:contact, :date, :account].freeze

    protected

      def self.permitted_contact_params
        [:id,
         :_destroy,
         {
           label: [],
           email: [],
           address: [],
           telephone: []
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

      def self.permitted_account_params
        [:id,
         :_destroy,
         {
           label: [],
           account_type: [],
           account_name: [],
           service_format: [],
           service_email: [],
           service_homepage: [],
           service_key: []
         },
        ]
      end

      def self.build_permitted_params
        permitted = super
        permitted << { contact_attributes: permitted_contact_params }
        permitted << { date_attributes: permitted_date_params }
        permitted << { account_attributes: permitted_account_params }
        permitted
      end

  end
end
