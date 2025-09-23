# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SectionComponent do
  let(:theme) { build(:theme) }
  let(:page) { build(:page, :with_navbar).tap { |page| page.prepare_sections(theme) } }
  let(:config) { instance_double('MaglevConfig', asset_host: 'https://assets.maglev.local') }
  let(:page_component) { instance_double('PageCommponent', page: page, config: config) }
  let(:attributes) { page.sections[1].deep_symbolize_keys }
  let(:definition) { build(:section, category: 'headers') }
  let(:view_context) { FooController.new.view_context }
  let(:templates_root_path) { 'theme' }
  let(:component) do
    described_class.new(
      parent: page_component,
      attributes: attributes,
      definition: definition,
      templates_root_path: templates_root_path,
      rendering_mode: :preview
    ).tap { |c| c.view_context = view_context }
  end

  describe '#dom_data' do
    subject { component.dom_data }

    it 'returns a HTML formatted data attribute' do
      is_expected.to eq %w[
        data-maglev-section-id="def"
        data-maglev-section-type="jumbotron"
        data-maglev-section-lock-version="0"
      ].join(' ').strip
    end
  end

  describe '#render' do
    subject { pretty_html(component.render) }

    context 'using low-level tags (ex: jumbotron)' do
      it 'returns a valid HTML' do
        actual_doc = parse_html(subject)

        # Check the main container div
        main_div = expect_element_present(actual_doc, 'div[data-maglev-section-id="def"]')
        expect_element_attributes(main_div, { "data-maglev-section-type": 'jumbotron' })

        # # Check the container div
        # container_div = expect_element_present(main_div, 'div.container')

        # Check the h1 element
        h1_element = expect_element_present(main_div, 'h1[data-maglev-id="def.title"]')
        expect_element_text(h1_element, 'Hello world')

        # Check the body div
        body_div = expect_element_present(main_div, 'div[data-maglev-id="def.body"]')

        # Check the paragraph
        paragraph = expect_element_present(body_div, 'p')
        expect_element_text(paragraph, 'Lorem ipsum')
      end
    end

    context 'using the fancy Maglev tags (ex: navbar)' do
      let(:attributes) { page.sections[0].deep_symbolize_keys }
      let(:definition) { build(:section, :navbar) }

      before { create(:site) }

      it 'returns a valid HTML' do
        actual_doc = parse_html(subject)

        # Check the main navbar div
        navbar_div = expect_element_present(actual_doc, 'div[data-maglev-section-id="abc"]')
        expect_element_attributes(navbar_div, { id: 'section-abc', "data-maglev-section-type": 'navbar' })

        # Check the logo link and image
        logo_link = expect_element_present(navbar_div, 'a[href="/"]')
        logo_img = expect_element_present(logo_link, 'img[data-maglev-id="abc.logo"]')
        expect_element_attributes(logo_img, { src: 'logo.png' })

        # Check the navigation
        nav_element = expect_element_present(navbar_div, 'nav')

        # Check the main menu items
        menu_items = expect_elements_count(nav_element, 'div.navbar-item', 2)

        # Check first menu item (Home)
        home_item = menu_items[0]
        expect_element_attributes(home_item, {
                                    id: 'block-menu-item-0',
                                    "data-maglev-block-id": 'menu-item-0'
                                  })
        home_link = expect_element_present(home_item, 'a[data-maglev-id="menu-item-0.link"]')
        expect_element_attributes(home_link, { href: '/' })
        home_label = expect_element_present(home_link, 'span[data-maglev-id="menu-item-0.label"]')
        expect_element_text(home_label, 'Home')

        # Check second menu item (About us) with nested items
        about_item = menu_items[1]
        expect_element_attributes(about_item, {
                                    id: 'block-menu-item-1',
                                    "data-maglev-block-id": 'menu-item-1'
                                  })
        about_link = expect_element_present(about_item, 'a[data-maglev-id="menu-item-1.link"]')
        expect_element_attributes(about_link, { href: '/about-us' })
        about_label = expect_element_present(about_link, 'span[data-maglev-id="menu-item-1.label"]')
        expect_element_text(about_label, 'About us')

        # Check nested menu items
        nested_items = expect_elements_count(about_item, 'li.navbar-nested-item', 2)

        # Check first nested item (Our team)
        team_item = nested_items[0]
        expect_element_attributes(team_item, {
                                    id: 'block-menu-item-1-1',
                                    "data-maglev-block-id": 'menu-item-1-1'
                                  })
        team_link = expect_element_present(team_item, 'a[data-maglev-id="menu-item-1-1.link"]')
        expect_element_attributes(team_link, {
                                    class: 'navbar-link',
                                    href: '/about-us/team'
                                  })
        team_label = expect_element_present(team_link, 'span[data-maglev-id="menu-item-1-1.label"]')
        expect_element_text(team_label, 'Our team')

        # Check second nested item (Our office)
        office_item = nested_items[1]
        expect_element_attributes(office_item, {
                                    id: 'block-menu-item-1-2',
                                    "data-maglev-block-id": 'menu-item-1-2'
                                  })
        office_link = expect_element_present(office_item, 'a[data-maglev-id="menu-item-1-2.link"]')
        expect_element_attributes(office_link, {
                                    class: 'navbar-link',
                                    href: '/about-us/office',
                                    target: '_blank'
                                  })
        office_label = expect_element_present(office_link, 'span[data-maglev-id="menu-item-1-2.label"]')
        expect_element_text(office_label, 'Our office')

        # Check language links
        lang_div = expect_element_present(navbar_div, '.locales')
        expect_elements_count(lang_div, 'a', 2)

        english_link = find_element_by_text(lang_div, 'a', 'English')
        expect(english_link).to be_present
        expect_element_attributes(english_link, {
                                    "data-active": 'true',
                                    href: 'http://www.example.com/empty'
                                  })

        french_link = find_element_by_text(lang_div, 'a', 'Français')
        expect(french_link).to be_present
        expect_element_attributes(french_link, {
                                    "data-active": 'false',
                                    href: 'http://www.example.com/fr/empty'
                                  })
      end
    end
  end
end

class FooController < ::ApplicationController
  include Maglev::StandaloneSectionsConcern

  helper_method :request

  private

  def maglev_site_root_fullpath
    '/'
  end

  def request
    ActionDispatch::Request.new(
      Rack::MockRequest.env_for('http://www.example.com', params: { path: '/' })
    )
  end

  def maglev_page_fullpaths
    { en: '/empty', fr: '/fr/empty' }
  end
end
