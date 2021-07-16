# frozen_string_literal: true

module Maglev
  class EditorController < ApplicationController
    include Maglev::FetchersConcern

    def show
      fetch_page_content
      @home_page_id = ::Maglev::Page.home.pick(:id)
      render layout: nil
    end

    def destroy
      case maglev_config.back_action
      when nil
        redirect_to default_leave_url
      when String
        redirect_to maglev_config.back_action
      when Symbol
        redirect_to main_app.send(maglev_config.back_action)
      when Proc
        instance_exec(fetch_site, &maglev_config.back_action)
      end
    end

    private

    def default_leave_url
      main_app.root_path
    rescue StandardError
      '/'
    end
  end
end
