# frozen_string_literal: true

module Maglev
  class Site < ApplicationRecord
    ## validations ##
    validates :name, presence: true

    ## methods ##

    def home_page_id
      @home_page_id ||= Maglev::Page.where(path: 'index').pick(:id)
    end

    def theme
      @theme ||= Maglev::Theme.default
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
            page.assign_section_ids
            page.save!
          end
        end
      end
    end
  end
end
