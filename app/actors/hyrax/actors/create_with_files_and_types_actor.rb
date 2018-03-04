module Hyrax
  module Actors
    class CreateWithFilesAndTypesActor < Hyrax::Actors::CreateWithFilesActor
      def create(env)
        file_types = filter_file_types(env.attributes.delete(:uploaded_file_types))
        uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        validate_files(files, env) && next_actor.create(env) && attach_files(files, file_types, env)
      end

      def update(env)
        file_types = filter_file_types(env.attributes.delete(:uploaded_file_types))
        uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
        files = uploaded_files(uploaded_file_ids)
        validate_files(files, env) && next_actor.update(env) && attach_files(files, file_types, env)
      end

      private 
        # @return [TrueClass]
        def attach_files(files, file_types, env)
          return true if files.blank?
          AttachFilesWithTypeToWorkJob.perform_later(env.curation_concern, files, file_types, env.attributes.to_h.symbolize_keys)
          true
        end


        def filter_file_types(input)
          file_types = {}
          input.values.each do |val|
            if val.fetch('file_id', []).first
              file_types[val.fetch('file_id', []).first] = val.fetch('file_type', []).first
            end
          end
          file_types.delete_if { |k, v| v.blank? }.with_indifferent_access
        end

    end
  end
end

