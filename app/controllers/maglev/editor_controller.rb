# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::FetchersConcern
    include Maglev::BackActionConcern
    include Maglev::UiLocaleConcern

    def show
      fetch_maglev_page_content
      @home_page_id = ::Maglev::Page.home.pick(:id)
      render layout: nil
    end

    def destroy
      call_back_action
    end

    private

    def default_leave_url
      main_app.root_path
    rescue StandardError
      '/'
    end
  end
end
