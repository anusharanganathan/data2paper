module Hyrax
  class DataPaperAPIController < ApplicationController
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
      unless params['doi'].present?
        render :nothing => true, :status => 400
      end
      @user = current_user
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
        # @importer.import 
        # Reading from doi file, until datacite account is active
        @importer.filepath = params[:filepath]
        @importer.read_xml_metadata 
        @importer.write_xml_metadata
        @importer.map_xml_metadata

        #2. Create data paper
        @data_paper = DataPaper.new
        @data_paper.update_attributes(@importer.data_paper_attributes)
        @data_paper.depositor = current_user.email
        @data_paper.edit_users = [current_user]
        @data_paper.status = 'new'
        @data_paper.save!

        #3 Create fileset with metadata file
        label = File.basename(@importer.filepath)
        fileset = FileSet.create!(
          label: label,
          title: ['Datacite XML metadata for dataset'],
          resource_type: ['metadata file'],
          edit_users: [currrent_user],
          depositor: current_user.email,
          date_uploaded: Time.now)
        fileset.save!
        Hydra::Works::UploadFileToFileSet.call(fileset, open(@importer.filepath))
        CreateDerivativesJob.perform_now(fileset, fileset.files.first.id)

        #4. Add fileset to data_paper
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
