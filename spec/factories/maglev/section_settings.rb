# frozen_string_literal: true

FactoryBot.define do
  factory :section_setting, class: 'Maglev::Section::Setting' do
    id { 'title' }
    label { 'Title' }
    type { 'text' }
    default { 'Hello world' }
    options { { html: true } }

    trait :link do
      id { 'link' }
      label { 'Link' }
      type { 'link' }
      options { { with_text: true } }
    end

    trait :simple_text do
      id { 'test_simple_text' }
      label { 'Simple Text 🍔' }
      options { { html: false } }
    end

    trait :richtext do
      id { 'test_richtext' }
      label { 'Richtext 🍔' }
      options { { html: true } }
    end

    trait :textarea do
      id { 'test_textarea' }
      label { 'Textarea 🍔' }
      options { { nb_rows: 5 } }
    end

    trait :checkbox do
      id { 'test_checkbox' }
      label { 'Checkbox 🍔' }
      type { 'checkbox' }
    end

    trait :image do
      id { 'test_image' }
      label { 'Image 🍔' }
      type { 'image' }
    end

    trait :select do
      id { 'test_select' }
      label { 'Select 🍔' }
      type { 'select' }
      options do
        { select_options: [{ label: 'Option 1', value: 'option_1' }, { label: 'Option 2', value: 'option_2' }] }
      end
    end

    trait :divider do
      id { 'test_divider' }
      label { 'Divider 🍔' }
      type { 'divider' }
    end

    trait :hint do
      id { 'test_hint' }
      label { 'Hint 🍔' }
      type { 'hint' }
    end

    trait :icon do
      id { 'test_icon' }
      label { 'Icon 🍔' }
      type { 'icon' }
    end

    trait :collection_item do
      id { 'test_collection_item' }
      label { 'Collection Item 🍔' }
      type { 'collection_item' }
      options do
        { collection_id: 'products' }
      end
    end

    trait :color do
      id { 'test_color' }
      label { 'Color 🍔' }
      type { 'color' }
      options do
        { presets: ['#E5E7EB', '#FECACA', '#FDE68A', '#A7F3D0', '#BFDBFE'] }
      end
    end
  end
end
