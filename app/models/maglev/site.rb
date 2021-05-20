# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## validations ##
    validates :name, presence: true

    ## methods ##

    def pages
      Maglev::Page.all
    end

    def home_page_id
      @home_page_id ||= Maglev::Page.where(path: 'index').pick(:id)
    end

    def theme
      @theme ||= Maglev.theme
    end

    def self.generate!
      ActiveRecord::Base.transaction do
        if Maglev::Site.first
          STDOUT.puts 'A Maglev Site exists already'
          return
        end

        create(name: 'default').tap do |site|
          site.theme&.pages&.each do |attributes|
            page = Maglev::Page.new(attributes)
            page.prepare_sections
            page.save!
          end
        end
      end
    end

    def find_section(type)
      sections.find { |section| section['type'] == type }
    end

    def add_section(section)
      sections.delete_if { |site_section| site_section['type'] == section['type'] }
      sections.push(section)
    end
  end
end
