# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_assets
#
#  id           :bigint           not null, primary key
#  byte_size    :integer
#  content_type :string
#  filename     :string
#  height       :integer
#  width        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module Maglev
  class Asset < ApplicationRecord
    include ::Maglev.uploader

    ## validations ##
    validates :file, presence: true

    ## methods ##

    def to_param
      "#{id}-#{File.basename(filename, '.*').parameterize}#{File.extname(filename)}"
    end

    ## class methods ##

    def self.search(keyword, type)
      all
        .optimized
        .where(keyword.present? ? arel_table[:filename].matches("%#{keyword}%") : nil)
        .where(arel_table[:content_type].matches("%#{type}%"))
        .order(created_at: :desc)
    end
  end
end
