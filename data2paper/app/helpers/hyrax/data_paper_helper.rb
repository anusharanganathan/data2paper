module Hyrax
  module DataPaperHelper
    def render_status_link(document)
      # Anchor must match with a tab in
      # https://github.com/samvera/hyrax/blob/master/app/views/hyrax/base/_guts4form.html.erb#L2
      if ['submitted', 'published'].include? document.status
        path = polymorphic_path([main_app, document])
      else
        path = edit_polymorphic_path([main_app, document])
      end 
      link_to(
        status_badge(document.status),
        path,
        id: "status_#{document.id}",
        class: 'status-link'
      )
    end

    def status_badge(value)
      StatusBadge.new(value).render
    end
  end
end
