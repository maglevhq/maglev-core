class Maglev::PersistStyleService
  include Injectable

  dependency :fetch_theme
  dependency :fetch_site

  argument :new_style

  def call
    site.style = compute_new_style
    site.save!
  end

  private

  def site
    @site ||= fetch_site.call
  end

  def theme
    @theme ||= fetch_theme.call
  end

  def compute_new_style
    theme.style_settings.map do |definition|
      value = new_style[definition.id.to_s]
      { id: definition.id, value: value, type: definition.type }
    end
  end
end