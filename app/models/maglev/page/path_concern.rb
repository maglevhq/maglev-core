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
             inverse_of: :page,
             autosave: true

    ## callbacks ##
    before_validation { path } # force the initialization of a new path if it doesn't exist
    before_save :spawn_redirection, if: :spawn_redirection?
  end

  def default_path
    @default_path ||= paths.find_by(locale: Maglev::I18n.default_locale)&.value
  end

  def path
    current_path.value
  end

  def path=(value)
    unless value.respond_to?(:each_pair)
      current_path.value = value
      return
    end

    value.each_pair do |locale, new_path|
      Maglev::I18n.with_locale(locale) { self.path = new_path }
    end
  end

  def current_path
    locale = Maglev::I18n.current_locale.to_sym
    @memoized_paths ||= {}
    @memoized_paths[locale] ||= paths.canonical.find_or_initialize_by(locale: locale, canonical: true)
  end

  def path_hash
    paths.build_hash
  end

  def disable_spawn_redirection
    @disable_spawn_redirection = true
  end

  def spawn_redirection_disabled?
    !!@disable_spawn_redirection
  end

  private

  def spawn_redirection
    old_value = current_path.value_in_database

    # the old path becomes now a redirection
    # we just have to make sure this redirection hasn't been added before.
    paths.build(canonical: false, value: old_value) unless paths.not_canonical.by_value(old_value).exists?

    # don't forget to persist the new value of the current path
    current_path.save
  end

  def spawn_redirection?
    return if spawn_redirection_disabled?

    current_path.persisted? && current_path.will_save_change_to_value?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
