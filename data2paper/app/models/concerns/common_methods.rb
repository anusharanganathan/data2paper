module CommonMethods
  extend ActiveSupport::Concern

  included do
    def final_parent
      parent
    end

    def persisted?
      !new_record?
    end

    def new_record?
      id.start_with?('#')
    end
  end
end
