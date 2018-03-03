module Hyrax
  module Actors
    class CreateWithFilesAndTypesActor < Hyrax::Actors::CreateWithFilesActor
      def create(env)
        uploaded_file_types = filter_file_types(env.attributes.delete(:uploaded_file_types))
        super
      end

      private 

        def filter_file_types(input)
          input.select {|_,v| v.present? }
        end

    end
  end
end

