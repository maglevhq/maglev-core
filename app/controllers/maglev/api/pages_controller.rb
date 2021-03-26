# frozen_string_literal: true

module Maglev
  module API
    class PagesController < ::Maglev::APIController
      def index
        @pages = if params[:q]
                   Maglev::Page.search(params[:q])
                 else
                   Maglev::Page.all
                 end
      end

      def show
        @page = Maglev::Page.find(params[:id])
      end

      def create
        page = Maglev::Page.create!(page_params)
        head :created, location: api_page_path(page)
      end

      def destroy
        Maglev::Page.destroy(params[:id])
        head :no_content
      end

      def update
        @page = Maglev::Page.find(params[:id])
        @page.update!(page_params)
        head :ok
      end

      private

      def page_params
        params.require(:page).permit(:title, :path).tap do |whitelisted|
          whitelisted[:sections] = params[:page].to_unsafe_hash[:sections] unless params.dig(:page, :sections).nil?
        end
      end
    end
  end
end
