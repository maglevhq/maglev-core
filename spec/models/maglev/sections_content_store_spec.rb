# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :integer          not null, primary key
#  container_type        :string
#  handle                :string           default("WIP"), not null
#  lock_version          :integer
#  published             :boolean          default(FALSE)
#  sections_translations :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#  maglev_page_id        :integer
#
# Indexes
#
#  index_maglev_sections_content_stores_on_handle          (handle)
#  index_maglev_sections_content_stores_on_maglev_page_id  (maglev_page_id)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published) UNIQUE
#  maglev_sections_content_stores_handle_and_page_id       (handle,maglev_page_id,published) UNIQUE
#
# Foreign Keys
#
#  maglev_page_id  (maglev_page_id => maglev_pages.id)
#
require 'rails_helper'

RSpec.describe Maglev::SectionsContentStore, type: :model do
  it 'has a valid factory' do
    expect(build(:sections_content_store)).to be_valid
  end
end
