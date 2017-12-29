# Generated via
#  `rails generate hyrax:work Journal`
module Hyrax
  class JournalPresenter < Hyrax::WorkShowPresenter
    delegate :homepage, :editor, :contact, :review_process,
    :average_publish_lead_time, :article_guidelines, :needs_apc,
    :apc_statement, :oa_level, :oa_statement, :supported_license,
    :declaration_statement, :owner, :agent_group, :account, :date,
    to: :solr_document
  end
end
