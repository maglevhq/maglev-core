# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :bigint           not null, primary key
#  container_type        :string
#  published             :boolean          default(FALSE)
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#
# Indexes
#
#  index_maglev_sections_content_stores_on_published       (published)
#  maglev_sections_content_stores_container                (container_id,container_type)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published)
#
require 'rails_helper'

RSpec.describe Maglev::SectionsContentStore, type: :model do
  it 'has a valid factory' do
    expect(build(:sections_content_store)).to be_valid
  end
end
