# frozen_string_literal: true

module Maglev
  module FlashI18nConcern
    private

    def flash_t(type, **opts)
      controller_name = controller_path.gsub('maglev/editor/', '').gsub('/', '.')
      t("maglev.editor.flash.#{controller_name}.#{action_name}.#{type}", **opts)
    end
  end
end
