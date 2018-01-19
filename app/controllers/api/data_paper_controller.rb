module API
  class DataPaperController < API::APIBaseController

    include Hydra::Catalog

    def search_builder_class
      Hyrax::DataPaperAPISearchBuilder
    end

    def index
      (@response, @document_list) = query_solr

      respond_to do |format|
        format.json { render :json => @document_list }
      end
    end
  
    def show
      # Add filter for source source_tesim or relation > identifier
      (@response, @document_list) = query_solr
      respond_to do |format|
        format.json { render :json => @document_list }
      end
    end
  
    def create
      unless (params['doi'].present? and params['orcid'].present?)
        render :nothing => true, :status => 400
      end
      @importer = nil
      @data_paper = nil
      import_and_create_data_paper 
      respond_to do |format|
        format.json { render :json => @data_paper, 
          :status => :created, 
          :location => hyrax_data_paper_path(@data_paper) }
      end
    end

    protected

      def import_and_create_data_paper
        require 'datacite_importer'
        # 1. Import metadata
        @importer = DataciteImporter.new(params)
        # TODO - import metadata from datacite stopped until account is active
        @importer.import
        @importer.write_metadata
        @importer.map_json_metadata

        #2. Find or create user
        user = User.find_by_orcid(params['orcid'])
        if user.nil?
          user = User.new
          user.provider = 'orcid'
          user.uid = params['orcid']
          user.orcid = params['orcid']
          user.email = "#{params['orcid']}@example.com"
          user.save!
        end

        #3. Create data paper
        @data_paper = DataPaper.new
        @data_paper.update_attributes(@importer.data_paper_attributes)
        @data_paper.depositor = user.email
        @data_paper.edit_users = [user]
        @data_paper.date_created = [Time.now]
        @data_paper.date_uploaded = Time.now
        @data_paper.status = 'new'
        @data_paper.save!

        #4. Create fileset with metadata file
        label = File.basename(@importer.filepath)
        fileset = FileSet.create!(
          label: label,
          title: ['Datacite JSON metadata for dataset'],
          resource_type: ['metadata file'],
          edit_users: [user],
          depositor: user.email,
          date_uploaded: Time.now)
        fileset.save!
        Hydra::Works::UploadFileToFileSet.call(fileset, open(@importer.filepath))
        CreateDerivativesJob.perform_now(fileset, fileset.files.first.id)

        #5. Add fileset to data_paper
        @data_paper.ordered_members << fileset
        @data_paper.representative_id = fileset.id
        @data_paper.thumbnail_id = fileset.thumbnail_id
        @data_paper.save!
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
