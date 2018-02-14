module Hyrax
  class StatusBadge
    include ActionView::Helpers::TagHelper

    STATUS_LABEL_CLASS = {
      new: "label-danger",
      draft: "label-warning",
      submitted: "label-success",
      published: "label-primary"
    }.freeze

    # @param status [String] the current status
    def initialize(status)
      @status = status
    end

    # Draws a span tag with styles for a bootstrap label
    def render
      content_tag(:span, text, class: "label #{dom_label_class}")
    end

    private

      def dom_label_class
        if @status.present?
          STATUS_LABEL_CLASS.fetch(@status.to_sym)
        else
          STATUS_LABEL_CLASS.fetch(:new)
        end
      end

      def text
        I18n.t("hyrax.data_paper.status.#{@status}")
      end

  end
end
