# frozen_string_literal: true

require 'rails_helper'
require 'generator_spec'
require 'generators/maglev/theme_generator'

describe Maglev::ThemeGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates the YAML file to describe the theme and its default HTML/ERB layout' do
    assert_file 'app/theme/theme.yml', /id: "theme"/
    assert_file 'app/views/theme/layout.html.erb'
  end
end
