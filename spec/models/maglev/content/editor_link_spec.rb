# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Content::EditorLink, type: :model do
  subject { described_class.new(link_type: 'url', href: 'https://www.google.com', open_new_window: true) }

  it { is_expected.to be_valid }

  it { expect(subject.open_new_window).to eq(true) }

  describe '#to_json' do
    it 'includes the attributes' do
      expect(subject.as_json['attributes'].symbolize_keys).to eq(
        { link_type: 'url', link_id: nil, href: 'https://www.google.com', open_new_window: true } 
      )
    end
  end
end