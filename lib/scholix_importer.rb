require 'rest-client'

class ScholixImporter
  # attr_accessor :filepath
  attr_reader :metadata, :paper_attributes

  VERSION = 'v1'
  ENDPOINT = "http://api.scholexplorer.openaire.eu/v1/"
  OPERATIONS = {
    'listDatasources' => {
      'parameters' => ['page'],
      'required' => []
      },
    'linksFromDatasource' => {
      'parameters' => ['datasource', 'page'],
      'required' => ['datasource']
    },
    'linksFromPid' => {
      'parameters' => ['pid', 'pidType', 'typologyTarget', 'datasourceTarget', 'page'],
      'required' => ['pid']
    },
    'linksFromPublishers' => {
       'parameters' => ['publisher', 'page'],
       'required' => ['publisher']
    }
  }.with_indifferent_access
  URI_PREFIXES = {
    'doi' => 'http://dx.doi.org/',
    'pdb' => 'https://www.ncbi.nlm.nih.gov/Structure/pdb/',
    'ncbi-n' => 'https://www.ncbi.nlm.nih.gov/nuccore/',
    'url' => '',
    'pbmid' => 'http://europepmc.org/abstract/med/'
  }

  def initialize()
    @metadata = nil
    @paper_attributes = nil
  end

  def listDatasources()
    params = {}
    call_api('listDatasources', params)
  end

  def linksFromDatasource(datasource)
    params = {'datasource' => datasource}
    response = call_api('linksFromDatasource', params)
    return nil unless response.present?
    map_scholix_object(response)
  end

  def linksFromPid(pid)
    # Example pids 10.5281/zenodo.1116163, 10.5517/cc124wdh, 10.6084/m9.figshare.5931529
    params = {'pid' => pid, 'typologyTarget' => 'publication'}
    response = call_api('linksFromPid', params)
    return nil unless response.present?
    map_scholix_object(response)
  end

  def linksFromPublishers(publisher)
    params = {'publisher' => publisher}
    response = call_api('linksFromPublishers', params)
    return nil unless response.present?
    map_scholix_object(response)
  end

  private

  def call_api(operation, params)
    check_operation(operation)
    check_params(operation, params)
    response = RestClient.get URI::join(ENDPOINT, operation).to_s,
      {params: params, accept: :json}
    return nil unless response.code == 200
    JSON.parse(response.body)
  end

  def check_operation(operation)
    # check operation is supported
    message = 'Operation not supported'
    raise message unless OPERATIONS.include?(operation)
  end

  def check_params(operation, params)
    # check required parameters exist
    required_params = OPERATIONS.dig(operation, 'required')
    message = "Parameter is missing. Required parameters: #{required_params.join(', ')}"
    Array.wrap(required_params).each do |param|
      if params.fetch(param, nil).blank?
        raise message
      end
    end
  end

  def map_scholix_object(scholix_object)
    publications = []
    scholix_object.each do |pub|
      publications << {
        source: {
          type: pub.dig('source', 'objectType', 'type'),
          publisher: map_publishers(pub.dig('source', 'publisher')),
          identifiers: id_to_url(pub.dig('source', 'identifiers')),
          title: pub.dig('source', 'title')
        }, 
        target: {
          type: pub.dig('target', 'objectType', 'type'),
          publisher: map_publishers(pub.dig('target', 'publisher')),
          identifiers: id_to_url(pub.dig('target', 'identifiers')),
          title: pub.dig('target', 'title')
        }
      }
    end
    publications
  end

  def id_to_url(scholix_identifiers)
    identifiers = []
    filtered_identifiers = Array.wrap(scholix_identifiers).select {|identifier| identifier['schema'] != 'dnetIdentifier'}
    filtered_identifiers.each do |id|
      if id.fetch('identifier', nil) and id.fetch('schema', nil)
        if URI_PREFIXES.fetch(id['schema'], nil)
          id['uri'] = URI_PREFIXES[id['schema']] + id['identifier']
        end
        id['display'] = "#{id['schema']}: #{id['identifier']}"
      end
    end
    filtered_identifiers.map{|id| id.symbolize_keys}
  end

  def map_publishers(publishers)
    Array.wrap(publishers).map{|publisher| publisher.dig('name')}.reject(&:blank?)
  end

  # def render_400(message)
  #   render :nothing => true, :status => :bad_request, json: { message: message }.to_json
  # end

  def write_metadata(filepath, metadata)
    # unless metadata.present?
    #   raise 'Metadata missing'
    # end
    # if @filepath.blank?
    #   filename = "%s.json" % @doi.gsub('/', '_').gsub(':', '_').gsub('.', '_')
    #   @filepath = "#{Rails.root}/tmp/#{filename}"
    # end
    file = File.open(filepath, 'w')
    file.write(metadata)
    file.close()
  end

  def read_metadata(filepath)
    JSON.parse(File.read(filepath))
  rescue
    nil
  end

end

