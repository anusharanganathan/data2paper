# Generated via
#  `rails generate hyrax:work DataPaper`
class DataPaperIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata


  # Uncomment this block if you want to add custom indexing behavior:
  def generate_solr_document
    super.tap do |solr_doc|
      # date
      solr_doc[Solrizer.solr_name('date', :stored_searchable)] = object.date.map { |d| d.date.first }
      solr_doc[Solrizer.solr_name('date', :displayable)] = object.date.to_json
      object.date.each do |d|
        label = DateTypesService.label(d.description.first) rescue nil
        if label
          solr_doc[Solrizer.solr_name("date_#{label.downcase}", :stored_sortable)] = d.date
        end
      end
      # creator
      creators = object.creator_nested.map { |c| (c.first_name + c.last_name).reject(&:blank?).join(' ') }
      solr_doc[Solrizer.solr_name('creator_nested', :facetable)] = creators
      solr_doc[Solrizer.solr_name('creator_nested', :stored_searchable)] = creators
      solr_doc[Solrizer.solr_name('creator_nested', :displayable)] = object.creator_nested.to_json
      # relation
      solr_doc[Solrizer.solr_name('relation_url', :facetable)] = object.relation.map { |r| r.url.first }.reject(&:blank?)
      solr_doc[Solrizer.solr_name('relation_id', :facetable)] = object.relation.map { |r| r.identifier.first }.reject(&:blank?)
      solr_doc[Solrizer.solr_name('relation', :displayable)] = object.relation.to_json
      # rights
      solr_doc[Solrizer.solr_name('license_nested', :stored_searchable)] = object.license_nested.map { |r| r.webpage.first }.reject(&:blank?)
      solr_doc[Solrizer.solr_name('license_nested', :facetable)] = object.license_nested.map { |r| r.webpage.first }.reject(&:blank?)
      solr_doc[Solrizer.solr_name('license_nested', :displayable)] = object.license_nested.to_json

    end
  end
end
