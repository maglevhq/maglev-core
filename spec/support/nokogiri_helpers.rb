# frozen_string_literal: true

require 'nokogiri'

module NokogiriHelpers
  # Parse HTML string into a Nokogiri document fragment
  def parse_html(html_string)
    Nokogiri::HTML::DocumentFragment.parse(html_string)
  end

  # Validate that an element has the expected attributes
  def expect_element_attributes(element, expected_attributes)
    expected_attributes.each do |attr_name, expected_value|
      expect(element[attr_name]).to eq(expected_value)
    end
  end

  # Find an element by CSS selector and validate its presence
  def expect_element_present(doc, selector, message = nil)
    element = doc.at_css(selector)
    expect(element).to be_present, message || "Expected to find element with selector: #{selector}"
    element
  end

  # Find multiple elements by CSS selector and validate count
  def expect_elements_count(doc, selector, expected_count, message = nil)
    elements = doc.css(selector)
    default_message = "Expected #{expected_count} elements with selector '#{selector}', found #{elements.length}"
    expect(elements.length).to eq(expected_count), message || default_message
    elements
  end

  # Validate element text content
  def expect_element_text(element, expected_text, message = nil)
    actual_text = element.text.strip
    expect(actual_text).to eq(expected_text),
                           message || "Expected text '#{expected_text}', got '#{actual_text}'"
  end

  # Find element by text content within a parent element
  def find_element_by_text(parent, selector, text)
    parent.css(selector).find { |element| element.text.strip == text }
  end
end

# Include the module in RSpec configuration
RSpec.configure do |config|
  config.include NokogiriHelpers
end
