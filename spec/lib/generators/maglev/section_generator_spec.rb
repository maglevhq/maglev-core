# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/section_generator'

BLOCK_SETTINGS = %w[
  title:text
  pre_title:text
  call_to_action:link
  block:item:title
  block:item:image:image
  block:item:description
].freeze

describe Maglev::SectionGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  arguments %w[showcase --theme=simple --category=features --settings] + BLOCK_SETTINGS

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates the YAML file to describe the section and its HTML/ERB template' do
    assert_file 'app/theme/sections/features/showcase.yml', /name: "Showcase"/
    assert_file 'app/views/theme/sections/features/showcase.html.erb'
  end

  it 'provides default link' do
    assert_file 'app/theme/sections/features/showcase.yml', /default: { text: "Link", href: "#" }/
  end

  it 'provides sample link' do
    assert_file 'app/theme/sections/features/showcase.yml', /call_to_action: { text: "Link", href: "#" }/
  end
end
