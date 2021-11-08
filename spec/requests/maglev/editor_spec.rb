# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::EditorController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) do
    Maglev::GenerateSite.call(theme: theme)
  end

  describe 'GET /maglev/editor' do
    it 'redirects to the index page in the default site locale' do
      get '/maglev/editor'
      expect(response).to redirect_to('/maglev/editor/en/index')
    end
  end

  describe 'GET /maglev/editor/:locale/(*path)' do
    it 'renders the editor UI' do
      get '/maglev/editor/en/index'
      expect(response.body).to include('My simple theme')
      expect(response.body).to include('window.baseUrl = "/maglev/editor"')
      expect(response.body).to include('window.apiBaseUrl = "/maglev/api"')
      expect(response.body).to include('window.site = {')
      expect(response.body).to include('window.theme = {')
      expect(response.body).to include('"nbRows":6')
    end

    describe 'the developer changed the UI locale' do
      let(:config) do
        Maglev::Config.new.tap do |config|
          config.ui_locale = ui_locale
          config.primary_color = '#7E6EDB'
        end
      end

      before { allow_any_instance_of(Maglev::EditorController).to receive(:maglev_config).and_return(config) }

      context 'by using a string as the UI locale' do
        let(:ui_locale) { 'fr' }
        it 'renders the editor in the defined locale' do
          get '/maglev/editor/en/index'
          expect(response.body).to include('<html class="h-full" lang="fr">')
        end
      end

      context 'by using a method of the main app returning the UI locale' do
        let(:ui_locale) { :exotic_locale }
        it 'renders the editor in the defined locale' do
          get '/maglev/editor/en/index'
          expect(response.body).to include('<html class="h-full" lang="fr">')
        end
      end

      context 'by using a Proc returning the UI locale' do
        let(:ui_locale) { ->(_current_site) { 'fr' } }
        it 'renders the editor in the defined locale' do
          get '/maglev/editor/en/index'
          expect(response.body).to include(%(<html class="h-full" lang="fr">))
        end
      end
    end
  end

  describe 'GET /maglev/leave_editor' do
    let(:config) do
      Maglev::Config.new.tap do |config|
        config.back_action = back_action
      end
    end

    before { allow_any_instance_of(Maglev::EditorController).to receive(:maglev_config).and_return(config) }

    context 'no back_action defined' do
      let(:back_action) { nil }
      it 'redirects to the root path of the application' do
        get '/maglev/leave_editor'
        expect(response).to redirect_to('/')
      end
    end
    context 'a static url has been set for the back_action' do
      let(:back_action) { '/foo/bar' }
      it 'redirects to the static url' do
        get '/maglev/leave_editor'
        expect(response).to redirect_to('/foo/bar')
      end
    end
    context 'a route path has been set for the back_action' do
      let(:back_action) { :nocoffee_path }
      it 'redirects to the route path' do
        get '/maglev/leave_editor'
        expect(response).to redirect_to('/nocoffee_site')
      end
    end
    context 'a Proc has been set for the back_action' do
      let(:back_action) { ->(current_site) { redirect_to "/somewhere-#{current_site.id}" } }
      it 'redirects to the url returned by the Proc' do
        get '/maglev/leave_editor'
        expect(response).to redirect_to("/somewhere-#{site.id}")
      end
    end
  end
end
