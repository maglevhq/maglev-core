# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Section::ContentConcern
  def build_default_content
    {
      id: SecureRandom.urlsafe_base64(8),
      type: id,
      settings: build_default_settings_content,
      blocks: []
    }
  end

  private

  def build_default_settings_content
    settings.map do |definition|
      { id: definition.id, value: definition.build_default_content }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
