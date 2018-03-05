module Hyrax
  class DataPaperTemplateController < Hyrax::DownloadsController

    def show
      send_template
    end

    def generate
      update_data_paper
      send_template
    end

    private

    def send_template
      if buildable?
        # the template exists and is in a supported format - go ahead and build it
        send_attachment_with_headers(build_populated_template, template_file_built_name)

      elsif template_file_reader? && template_file_original_name?
        # there is a template file but its not a supported file type, so just pass it through
        send_attachment_with_headers(template_file_reader.content, template_file_original_name)
      else
        # there is no template file
        render_404
      end
    end

    def data_paper
      @data_paper ||= DataPaper.find(params[:id])
    end

    def data_paper?
      data_paper.present?
    end

    def update_data_paper
      new_data_paper = DataPaper.new
      new_data_paper.id = 'new2new3new'
      if data_paper?
        new_data_paper.title = @data_paper.title
        new_data_paper.description = @data_paper.description
        new_data_paper.journal = @data_paper.journal
        new_data_paper.subject = @data_paper.subject
        new_data_paper.keyword = @data_paper.keyword
        new_data_paper.creator_nested = @data_paper.creator_nested
        new_data_paper.creator_nested.each do |c|
          c.id.sub! @data_paper.uri.to_s, new_data_paper.uri.to_s
        end
      end
      params_permitted = params.require(:data_paper).permit(*permitted_params)
      params_permitted.fetch("creator_nested_attributes", {}).each do |k,c|
        if c.fetch('id', nil).present?
          c['id'].sub!(@data_paper.uri.to_s, new_data_paper.uri.to_s)
        end
      end
      new_data_paper.update_attributes(params_permitted)
      @data_paper = new_data_paper
    end

    def journal
      @journal ||= data_paper.journal if data_paper?
    end

    def journal?
      journal.present?
    end

    def template_file
      @template_file ||= journal.template_file if journal?
    end

    def template_file?
      journal.has_template_file?
    end

    def template_file_reader
      unless @template_file_reader.present?
        if template_file?
          association = template_file.association(Hyrax::DownloadsController.default_content_path.to_sym)
          if association && association.is_a?(ActiveFedora::Associations::SingularAssociation)
            @template_file_reader ||= association.reader
          end
        end
      end
      @template_file_reader
    end

    def template_file_reader?
      template_file_reader.present?
    end

    def template_file_original_name
      @template_file_original_name ||= template_file_reader.original_name if template_file_reader?
    end

    def template_file_original_name?
      template_file_original_name.present?
    end

    def template_file_built_name
      @template_file_built_name ||= "paper_template_#{params[:id]}_#{template_file_original_name}" if template_file_original_name?
    end

    def template_file_built_name?
      template_file_built_name.present?
    end

    def buildable?
      # we can only build a template if it is .docx format
      File.extname(template_file_original_name).downcase == '.docx' if template_file_original_name?
    end

    def authorize_download!
      
      if template_file?
        authorize! :download, template_file.id
      else
        render_404
      end
      rescue CanCan::AccessDenied
        redirect_to [main_app, hyrax_data_paper_path(params[:id])]
    end

    def build_populated_template
      unless @build_populated_template.present?
        if data_paper? && template_file_reader? && template_file_original_name?

          source_template = Tempfile.new(template_file_original_name)
          destination_file = Tempfile.new(template_file_built_name)

          begin
            source_template.binmode
            source_template.write(template_file_reader.content)
            source_template.close

            doc = DocxReplace::Doc.new(source_template.path)
            doc.replace("$data_paper_title$", data_paper.title.first)
            doc.replace("$data_paper_creator$", data_paper.creator_names.join(","))
            doc.replace("$data_paper_description$", data_paper.description.first)
            doc.replace("$data_paper_keywords$", (data_paper.subject + data_paper.keyword).join(', '))

            destination_file.binmode
            doc.commit(destination_file.path)
            destination_file.close

            @build_populated_template = File.binread(destination_file.path)
          ensure
            source_template.close
            source_template.unlink   # deletes the source temp file
            destination_file.close
            destination_file.unlink   # deletes the destination temp file
          end
        end
      end
      @build_populated_template
    end

    def send_attachment_with_headers(data, filename)
      response.headers['Accept-Ranges'] = 'bytes'
      response.headers['Content-Length'] = data.length
      send_data data, filename: filename, disposition: 'attachment', type: mime_type_for(filename)
    end

    def permitted_params
      return [
        { title: [] },
        { description: [] },
        { subject: [] },
        { keyword: [] },
        :journal_id,
        { creator_nested_attributes: [
          :id,
          :_destroy,
          {
            first_name: [],
            last_name: [],
            name: [],
            orcid: [],
            role: [],
            affiliation: []
          },
        ]}
      ]
    end

  end
end
