class Maglev::Uikit::IconComponent < ViewComponent::Base
  attr_reader :name, :size, :class_names

  def initialize(name:, size: '1.25rem', class_names: nil)
    @name = name
    @size = size
    @class_names = class_names
  end

  def call
    icon_svg = ICONS[name] || raise("Icon #{name} not found")
    
    # Apply styling and classes to the SVG
    styled_svg = icon_svg.gsub(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"',
      "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" style=\"#{style}\" class=\"#{final_class_names}\""
    )
    
    styled_svg.html_safe
  end

  private

  def style
    "width: #{size}; height: #{size};"
  end

  def final_class_names
    helpers.class_names(*class_names, 'fill-current')
  end

  # Centralized icon definitions
  ICONS = {
    # Remix Icons
    'error_warning' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm-1-7v2h2v-2h-2zm0-8v6h2V7h-2z"/></svg>',
    
    'stack' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M20.083 15.2l1.202.721a.5.5 0 0 1 0 .858l-8.77 5.262a1 1 0 0 1-1.03 0l-8.77-5.262a.5.5 0 0 1 0-.858l1.202-.721L12 20.05l8.083-4.85zm0-4.7l1.202.721a.5.5 0 0 1 0 .858L12 17.65l-9.285-5.571a.5.5 0 0 1 0-.858l1.202-.721L12 15.35l8.083-4.85zm-7.569-9.191l8.771 5.262a.5.5 0 0 1 0 .858L12 13L2.715 7.43a.5.5 0 0 1 0-.858l8.771-5.262a1 1 0 0 1 1.03 0zM12 3.332L5.887 7 12 10.668 18.113 7 12 3.332z"/></svg>',
    
    'checkbox_circle' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm-.997-6l7.07-7.071-1.414-1.414-5.656 5.657-2.829-2.829-1.414 1.414L11.003 16z"/></svg>',
    
    'settings' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M2.213 14.06a9.945 9.945 0 0 1 0-4.12c1.11.13 2.08-.237 2.396-1.001.317-.765-.108-1.71-.986-2.403a9.945 9.945 0 0 1 2.913-2.913c.692.877 1.638 1.303 2.403.986.765-.317 1.132-1.286 1.001-2.396a9.945 9.945 0 0 1 4.12 0c-.13 1.11.237 2.08 1.001 2.396.765.317 1.71-.108 2.403-.986a9.945 9.945 0 0 1 2.913 2.913c-.877.692-1.303 1.638-.986 2.403.317.765 1.286 1.132 2.396 1.001a9.945 9.945 0 0 1 0 4.12c-1.11-.13-2.08.237-2.396 1.001-.317.765.108 1.71.986 2.403a9.945 9.945 0 0 1-2.913 2.913c-.692-.877-1.638-1.303-2.403-.986-.765.317-1.132 1.286-1.001 2.396a9.945 9.945 0 0 1-4.12 0c.13-1.11-.237-2.08-1.001-2.396-.765-.317-1.71.108-2.403.986a9.945 9.945 0 0 1-2.913-2.913c.877-.692 1.303-1.638.986-2.403-.317-.765-1.286-1.132-2.396-1.001zM4 12.21c1.1.305 2.007 1.002 2.457 2.086.449 1.085.3 2.22-.262 3.212.096.102.195.201.297.297.993-.562 2.127-.71 3.212-.262 1.084.45 1.781 1.357 2.086 2.457.14.004.28.004.42 0 .305-1.1 1.002-2.007 2.086-2.457 1.085-.449 2.22-.3 3.212.262.102-.096.201-.195.297-.297-.562-.993-.71-2.127-.262-3.212.45-1.084 1.357-1.781 2.457-2.086.004-.14.004-.28 0-.42-1.1-.305-2.007-1.002-2.457-2.086-.449-1.085-.3-2.22.262-3.212a7.935 7.935 0 0 0-.297-.297c-.993.562-2.127.71-3.212.262C13.212 6.007 12.515 5.1 12.21 4a7.935 7.935 0 0 0-.42 0c-.305 1.1-1.002 2.007-2.086 2.457-1.085.449-2.22.3-3.212-.262-.102.096-.201.195-.297.297.562.993.71 2.127.262 3.212C6.007 10.788 5.1 11.485 4 11.79c-.004.14-.004.28 0 .42zM12 15a3 3 0 1 1 0-6 3 3 0 0 1 0 6zm0-2a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/></svg>',
    
    'close' => '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current" style="width: 1.15rem; height: 1.15rem;"><path fill="none" d="M0 0h24v24H0z"></path><path d="m12 10.586 4.95-4.95 1.414 1.414-4.95 4.95 4.95 4.95-1.414 1.414-4.95-4.95-4.95 4.95-1.414-1.414 4.95-4.95-4.95-4.95L7.05 5.636z"></path></svg>',
    
    'more' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M12 3c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 14c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0-7c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/></svg>',
    
    'more_2' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M12 3c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 14c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0-7c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/></svg>',
    
    'file' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M9 2.003V2h10.998C20.55 2 21 2.455 21 2.992v18.016a.993.993 0 0 1-.993.992H3.993A1 1 0 0 1 3 20.993V8l6-5.997zM5.83 8H9V4.83L5.83 8zM11 4v5a1 1 0 0 1-1 1H5v10h14V4h-8z"/></svg>',
    
    'file_copy' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M7 6V3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-3v3c0 .552-.45 1-1.007 1H4.007A1.001 1.001 0 0 1 3 21l.003-14c0-.552.45-1 1.007-1H7zM5.003 8L5 20h10V8H5.003zM9 6h8v10h2V4H9v2z"/></svg>',
    
    # Other icons
    'home' => '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M19 21H5a1 1 0 0 1-1-1v-9H1l10.327-9.388a1 1 0 0 1 1.346 0L23 11h-3v9a1 1 0 0 1-1 1m-6-2h5V9.157l-6-5.454-6 5.454V19h5v-6h2z"/></svg>',
    
    'logout' => ' <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M5 22a1 1 0 0 1-1-1V3a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v3h-2V4H6v16h12v-2h2v3a1 1 0 0 1-1 1H5zm13-6v-3h-7v-2h7V8l5 4-5 4z"/></svg>'
  }.freeze
end