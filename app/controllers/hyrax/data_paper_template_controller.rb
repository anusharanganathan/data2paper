module Hyrax
  class DataPaperTemplateController < Hyrax::DownloadsController

    def show
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

    def journal
      if params.fetch('journal', nil).present?
        @journal ||= Journal.find(params['journal'])
      else
        @journal ||= data_paper.journal if data_paper?
      end
      @journal
    end

    def journal?
      journal.present?
    end

    def template_file
      @template_file ||= journal.template_file if journal?
    end

    def template_file?
      journal? && journal.has_template_file?
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
      authorize! :download, template_file.id if template_file?
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
      response.headers['Content-Length'] = data.length.to_s
      send_data data, filename: filename, disposition: 'attachment', type: mime_type_for(filename)
    end

  end
end
