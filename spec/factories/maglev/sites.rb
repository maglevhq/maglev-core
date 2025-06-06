# frozen_string_literal: true

FactoryBot.define do
  factory :site, class: 'Maglev::Site' do
    name { 'My awesome site' }
    locales { [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }] }

    trait :with_style do
      style do
        [
          { type: 'color', id: 'primary_color', value: '#ff00ff' },
          { type: 'text', id: 'font_name', value: 'roboto' }
        ]
      end
    end
  end
end

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :bigint           not null, primary key
#  locales               :jsonb
#  lock_version          :integer
#  name                  :string
#  sections_translations :jsonb
#  style                 :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
