# frozen_string_literal: true

module Maglev
  module UserInterfaceLocaleConcern
    extend ActiveSupport::Concern

    included do
      before_action :set_ui_locale

      helper_method :editor_ui_locale
    end

    private

    def set_ui_locale
      ::I18n.locale = editor_ui_locale
    end

    def editor_ui_locale
      case maglev_config.ui_locale
      when nil
        ::I18n.locale
      when String
        maglev_config.ui_locale.to_sym
      when Symbol
        send(maglev_config.ui_locale)
      when Proc
        instance_exec(maglev_site, &maglev_config.ui_locale)
      end
    end
  end
end
