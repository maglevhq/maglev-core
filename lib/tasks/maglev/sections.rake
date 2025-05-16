# frozen_string_literal: true

namespace :maglev do
  namespace :sections do
    desc 'Rename a section type across the site and its pages (args: old_type new_type)'
    task rename: :environment do
      site = Maglev::Site.first
      theme = Maglev.local_themes&.first

      unless site
        puts "[Error] You don't seem to have an existing site. 🤔"
        return
      end

      unless theme
        puts '[Error] No theme found. 🤔'
        return
      end

      # without this, rake will run the ARGV arguments as if they were rake tasks
      # rubocop:disable Style/BlockDelimiters
      ARGV.each { |a| task a.to_sym => :environment do; end }
      # rubocop:enable Style/BlockDelimiters

      old_type, new_type = ARGV[1..2]

      if old_type.nil? || new_type.nil?
        puts '[Error] Please provide both old_type and new_type arguments. Example: rake maglev:sections:rename hero banner'
        return
      end

      begin
        Maglev::RenameSectionType.call(
          site: site,
          theme: theme,
          old_type: old_type,
          new_type: new_type
        )
        puts "Successfully renamed all '#{old_type}' sections to '#{new_type}' 🎉"
      rescue StandardError => e
        puts "[Error] #{e.message}"
      end
    end

    desc 'Remove a section type across the site and its pages (args: type)'
    task remove: :environment do
      site = Maglev::Site.first

      unless site
        puts "[Error] You don't seem to have an existing site. 🤔"
        return
      end

      # without this, rake will run the ARGV arguments as if they were rake tasks
      # rubocop:disable Style/BlockDelimiters
      ARGV.each { |a| task a.to_sym => :environment do; end }
      # rubocop:enable Style/BlockDelimiters

      type = ARGV[1]

      if type.nil?
        puts '[Error] Please provide the section type to remove. Example: rake maglev:sections:remove hero'
        return
      end

      begin
        removed_count = Maglev::RemoveSectionType.call(
          site: site,
          type: type
        )
        puts "Successfully removed #{removed_count} section#{'s' if removed_count != 1} of type '#{type}' 🎉"
      rescue StandardError => e
        puts "[Error] #{e.message}"
      end
    end
  end
end
