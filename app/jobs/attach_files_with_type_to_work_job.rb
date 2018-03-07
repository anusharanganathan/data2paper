# Converts UploadedFiles into FileSets and attaches them to works.
class AttachFilesWithTypeToWorkJob < AttachFilesToWorkJob

  # @param [ActiveFedora::Base] work - the work object
  # @param [Array<Hyrax::UploadedFile>] uploaded_files - an array of files to attach
  def perform(work, uploaded_files, file_types, **work_attributes)
    validate_files!(uploaded_files)
    user = User.find_by_user_key(work.depositor) # BUG? file depositor ignored
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)
    uploaded_files.each do |uploaded_file|
      actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
      actor.create_metadata(metadata)
      if file_types.include?(uploaded_file.id.to_s)
        actor.file_set.resource_type = Array.wrap(file_types.fetch(uploaded_file.id.to_s))
      end
      actor.create_content(uploaded_file)
      actor.attach_to_work(work)
      actor.file_set.permissions_attributes = work_permissions
      uploaded_file.update(file_set_uri: actor.file_set.uri)
    end
  end

end

