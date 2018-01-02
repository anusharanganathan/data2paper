# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  def creator_nested
    self[Solrizer.solr_name('creator_nested', :displayable)]
  end

  def date
    self[Solrizer.solr_name('date', :displayable)]
  end

  def relation
    self[Solrizer.solr_name('relation', :displayable)]
  end

  def tagged_version
    self[Solrizer.solr_name('tagged_version', :stored_searchable)]
  end

  def license_nested
    self[Solrizer.solr_name('license_nested', :displayable)]
  end

  def statement_agreed
    self[Solrizer.solr_name('statement_agreed', :stored_sortable)]
  end

  def note
    self[Solrizer.solr_name('note', :stored_sortable)]
  end

  def status
    self[Solrizer.solr_name('status', :stored_sortable)]
  end

  def homepage
    self[Solrizer.solr_name('homepage', :stored_searchable)]
  end

  def editor
    self[Solrizer.solr_name('editor', :stored_searchable)]
  end

  def contact
    self[Solrizer.solr_name('contact', :displayable)]
  end

  def review_process
    self[Solrizer.solr_name('review_process', :stored_searchable)]
  end

  def average_publish_lead_time
    self[Solrizer.solr_name('average_publish_lead_time', :stored_searchable)]
  end

  def article_guidelines
    self[Solrizer.solr_name('article_guidelines', :stored_searchable)]
  end

  def needs_apc
    self[Solrizer.solr_name('needs_apc', :stored_sortable)]
  end

  def apc_statement
    self[Solrizer.solr_name('apc_statement', :stored_searchable)]
  end

  def oa_statement
    self[Solrizer.solr_name('oa_statement', :stored_searchable)]
  end

  def oa_level
    self[Solrizer.solr_name('oa_level', :stored_sortable)]
  end

  def supported_license
    self[Solrizer.solr_name('supported_license', :stored_searchable)]
  end

  def declaration_statement
    self[Solrizer.solr_name('declaration_statement', :stored_searchable)]
  end

  def owner
    self[Solrizer.solr_name('owner', :stored_searchable)]
  end

  def agent_group
    self[Solrizer.solr_name('agent_group', :stored_searchable)]
  end

  def account
    self[Solrizer.solr_name('account', :displayable)]
  end

  def template_path
    self['template_path_ss']
  end

end
