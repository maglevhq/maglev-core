# frozen_string_literal: true

namespace :maglev do
  namespace :icons do
    desc 'Generate FontAwesome icon configuration for Maglev'
    task fontawesome: :environment do
      require 'net/http'
      require 'uri'

      puts 'Fetching FontAwesome icons from CDN...'

      # Fetch the all.css file from FontAwesome CDN
      uri = URI('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.css')
      response = Net::HTTP.get(uri)

      # Extract icon classes using regex
      icon_classes = []

      # Match .fa-* classes that define content
      response.scan(/\.(fa-[^:]+):before/).each do |match|
        class_name = match[0]
        next if class_name.include?('{') || class_name.include?('}') # Skip utility classes

        # Add each style variant
        %w[fa-solid fa-regular fa-light fa-thin fa-brands].each do |style|
          # Extract the icon name without fa- prefix
          icon_name = class_name.sub('fa-', '')
          icon_classes << "#{style} fa-#{icon_name}"
        end
      end

      # Remove duplicates and sort
      icon_classes.uniq!
      icon_classes.sort!

      puts "Found #{icon_classes.size} icon variations"

      # Generate the icons YAML content in a single line
      icons_yaml = ['', '', '# FontAwesome icons', "icons: [#{icon_classes.map { |i| %("#{i}") }.join(', ')}]"]
      icons_yaml = icons_yaml.join("\n")

      # Append to theme.yml
      theme_file = Rails.root.join('app/theme/theme.yml')

      if File.exist?(theme_file)
        # Read the current content
        content = File.read(theme_file)

        # Check if icons are already defined
        if content.match?(/^icons:/)
          puts "Warning: 'icons' section already exists in #{theme_file}"
          puts "Please remove the existing 'icons' section first"
          puts 'You can add the following content to your theme.yml file:'
          puts icons_yaml
        else
          # Append the icons section
          File.write(theme_file, [content.rstrip, icons_yaml, "\n"].join)
          puts "Updated #{theme_file} with FontAwesome icons"
        end
      else
        puts "Warning: #{theme_file} not found. Please create a theme first."
        puts 'You can add the following content to your theme.yml file:'
        puts icons_yaml
      end
    end

    desc 'Generate Remixicon icon configuration for Maglev'
    task remixicon: :environment do
      require 'net/http'
      require 'uri'

      puts 'Fetching Remixicon icons from CDN...'

      # Fetch the remixicon.css file from CDN
      uri = URI('https://cdn.jsdelivr.net/npm/remixicon@3.7.0/fonts/remixicon.css')
      response = Net::HTTP.get(uri)

      # Extract icon classes using regex
      icon_classes = []

      # Match .ri-* classes that define content
      response.scan(/\.(ri-[^:]+):before/).each do |match|
        class_name = match[0]
        next if class_name.include?('{') || class_name.include?('}') # Skip utility classes

        icon_classes << class_name
      end

      icon_classes.uniq!
      icon_classes.sort!

      puts "Found #{icon_classes.size} Remixicon icons"

      # Generate the icons YAML content in a single line
      icons_yaml = ['', '', '# Remixicon icons', "icons: [#{icon_classes.map { |i| %("#{i}") }.join(', ')}]"]
      icons_yaml = icons_yaml.join("\n")

      # Append to theme.yml
      theme_file = Rails.root.join('app/theme/theme.yml')

      if File.exist?(theme_file)
        # Read the current content
        content = File.read(theme_file)

        # Check if icons are already defined
        if content.match?(/^icons:/)
          puts "Warning: 'icons' section already exists in #{theme_file}"
          puts "Please remove the existing 'icons' section first"
          puts 'You can add the following content to your theme.yml file:'
          puts icons_yaml
        else
          # Append the icons section
          File.write(theme_file, [content.rstrip, icons_yaml, "\n"].join)
          puts "Updated #{theme_file} with Remixicon icons"
        end
      else
        puts "Warning: #{theme_file} not found. Please create a theme first."
        puts 'You can add the following content to your theme.yml file:'
        puts icons_yaml
      end
    end
  end
end
