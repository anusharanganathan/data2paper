# Generated via
#  `rails generate hyrax:work Journal`
class JournalIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      # account
      solr_doc[Solrizer.solr_name('account', :displayable)] = object.account.to_json
      solr_doc[Solrizer.solr_name('account_type', :facetable)] = object.account.map { |a| a.account_type.first }.reject(&:blank?)
      # contact
      solr_doc[Solrizer.solr_name('contact_label', :facetable)] = object.contact.map { |c| c.label.first }.reject(&:blank?)
      solr_doc[Solrizer.solr_name('contact', :displayable)] = object.contact.to_json
    end
  end
end
