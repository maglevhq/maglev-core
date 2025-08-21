class Maglev::Uikit::LocaleSwitcherComponent < Maglev::Uikit::BaseComponent
  attr_reader :locales, :current_locale

  def initialize(locales:, current_locale:)
    @locales = locales
    @current_locale = current_locale.to_s
  end

  def current_locale_label
    locales.find { |locale| locale[:value].to_s == current_locale }[:label]
  end
end