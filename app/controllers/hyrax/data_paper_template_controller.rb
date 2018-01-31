module Hyrax
  class DataPaperTemplateController < Hyrax::DownloadsController

    def show
      if data_paper.journal and data_paper.journal.has_template_file?
        case extension
        when '.docx'
          #TODO: Returning nil - see load_file
          begin
            # For derivatives stored on the local file system
            response.headers['Accept-Ranges'] = 'bytes'
            response.headers['Content-Length'] = File.size(file).to_s
            send_file file.path, template_download_options
          ensure
            file.unlink
          end
        else
          # For original files that are stored in fedora
          send_content
        end
      else
        render_404
      end
    end

    # TODO: Submit data paper to journal
    #   Throw error if no user email or data paper or data paper journal or data paper journal account service email 
    #   To deliver email: ElsevierMailer.submission_email(user, data_paper).deliver

    private

    def data_paper
      DataPaper.find(params[:id])
    end
 
    def asset
      @asset ||= data_paper.journal.template_file
    end

    def file
      @file ||= load_file
    end
 
    # @return [Hydra::PCDM::File] or replaced [Hydra::PCDM::File] the file
    def load_file
      if extension == '.docx'
       #TODO: Returning nil
        # stream pre-filled data paper template 
        content_file = save_template_file
        return content_file unless content_file.present?
        tmp_file = prepopulate_template(content_file.path)
        content_file.unlink
        tmp_file
      else
        # stream data paper template
        template_file_reader 
      end
    end

    def template_download_options
      { filename: template_file_name, disposition: 'attachment', type: mime_type_for(file_name) }
    end


    def template_file_reader
      association = asset.association(Hyrax::DownloadsController.default_content_path.to_sym)
      if association && association.is_a?(ActiveFedora::Associations::SingularAssociation)
        association.reader
      else
        false
      end
    end

    def save_template_file
      if template_file_reader
        tmp_file = Tempfile.new(file_name, "#{Rails.root}/tmp")
        tmp_file.binmode
        tmp_file.write(template_file_reader.content)
        tmp_file.close
        tmp_file
      else
        nil
      end
    end

    def prepopulate_template(template_file)
      #TODO: method not working
      doc = DocxReplace::Doc.new(template_file, "#{Rails.root}/tmp")
      doc.replace("$data_paper_title$", data_paper.title.first)
      doc.replace("$data_paper_creator$", data_paper.creator_names.join(","))
      doc.replace("$data_paper_description$", data_paper.description.first)
      doc.replace("$data_paper_keywords$", (data_paper.subject + data_paper.keyword).join(', '))
      tmp_file = Tempfile.new(template_file_name, "#{Rails.root}/tmp")
      tmp_file.binmode
      doc.commit(tmp_file.path)
      tmp_file
    end

    def authorize_download!
      authorize! :download, asset.id
    rescue CanCan::AccessDenied
      redirect_to [main_app, hyrax_data_paper_path(params[:id])]
    end

    def file_name
      template_file_reader.original_name || (asset.respond_to?(:label) && asset.label) || params[:id]
    end

    def extension
      File.extname(file_name)
    end

    def template_file_name
      basename = File.basename(file_name, extension)
      "paper_template_#{params[:id]}_#{basename}#{extension}"
    end

  end
end
