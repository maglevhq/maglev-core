# frozen_string_literal: true

# Stand-in for Maglev::Editor::Combobox::PagesController so Lookbook combobox previews
# can perform remote search without mounting the full editor or a real site.
class LookbookComboboxPagesController < ApplicationController
  layout false

  def index
    query = params[:query].to_s.strip.downcase
    @pages = mock_pages.select { |page| query.present? && page.label.downcase.include?(query) }
    response.set_header("X-Select-Options-Size", @pages.size)

    respond_to do |format|
      format.turbo_stream { render :index }
      format.all { head :not_acceptable }
    end
  end

  private

  def mock_pages
    [
      MockPage.new(1, "Home page"),
      MockPage.new(2, "About us"),
      MockPage.new(3, "Contact")
    ]
  end

  class MockPage
    attr_reader :id, :label

    def initialize(id, label)
      @id = id
      @label = label
    end

    def title
      label
    end

    def default_title
      label
    end
  end
end
