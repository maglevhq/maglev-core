# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :integer          not null, primary key
#  locales               :json
#  lock_version          :integer
#  name                  :string
#  published_at          :datetime
#  sections_translations :json
#  style                 :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
module Maglev
  class Site < ApplicationRecord
    ## concerns ##
    include Maglev::Site::LocalesConcern
    include Maglev::Translatable

    ## force JSON columns for MariaDB ##
    attribute :style, :json
    attribute :sections_translations, :json

    ## translations ##
    translates :sections

    ## validations ##
    validates :name, presence: true

    ## methods ##

    def published?
      published_at.present?
    end
  end
end
