# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Page::PathConcern
  extend ActiveSupport::Concern

  included do
    ## associations ##
    has_many :paths,
             class_name: '::Maglev::PagePath',
             dependent: :delete_all,
             foreign_key: 'maglev_page_id',
             inverse_of: 'page',
             autosave: true

    ## callbacks ##
    before_save :spawn_redirection, if: :spawn_redirection?
  end

  def default_path
    @default_path ||= paths.find_by(locale: Maglev::I18n.default_locale)&.value
  end

  def path
    current_path.value
  end

  def path=(value)
    current_path.value = value
  end

  def current_path
    @memoized_paths ||= {}
    @memoized_paths[Maglev::I18n.current_locale] ||= paths.find_or_initialize_by(
      locale: Maglev::I18n.current_locale
    )
  end

  def path_hash
    paths.build_hash
  end

  def canonical_path
    return path if current_path.canonical?

    paths.find_by(canonical: true).value
  end

  def disable_spawn_redirection
    @disable_spawn_redirection = true
  end

  def spawn_redirection_disabled?
    !!@disable_spawn_redirection
  end

  private

  def spawn_redirection
    paths.build(canonical: false, value: current_path.value_in_database)
  end

  def spawn_redirection?
    return if spawn_redirection_disabled?

    current_path.persisted? && current_path.will_save_change_to_value?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
