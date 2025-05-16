# frozen_string_literal: true

module Maglev
  module Errors
    class NotAuthorized < StandardError; end
    class UnknownSection < StandardError; end
    class DuplicateSectionDefinition < StandardError; end

    class UnknownSetting < StandardError
      def initialize(section_id, block_id, setting_id)
        key = [section_id, block_id].compact.join('.')
        super("[#{key}] The #{setting_id} setting is undeclared OR its type is unknown.")
      end
    end
  end
end
