# frozen_string_literal: true

module Maglev
  module DashboardHelper
    def section_file_path(section)
      "<RailsRoot>/app/theme/sections/#{section.id}.yml"
    end

    def section_template_path(section)
      "<RailsRoot>/app/views/theme/sections/#{section.id}.html.erb"
    end
  end
end
