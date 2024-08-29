# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maglev::EditorController', type: :request do
  let(:theme) { build(:theme, :predefined_pages) }
  let!(:site) { Maglev::GenerateSite.call(theme: theme) }

  context 'the editor is not authenticated' do
    before do
      Maglev.configure do |config|
        config.is_authenticated = ->(_site) { false }
      end
    end

    describe 'GET /maglev/editor' do
      it 'redirects to a path defined by the ApplicationController of the main app' do
        get '/maglev/editor'
        expect(flash[:error]).to eq('You\'re not authorized to access the Maglev editor!')
        expect(response).to redirect_to('http://www.example.com/nocoffee_site')
      end
    end
  end

  context 'the editor is authenticated' do
    before do
      Maglev.configure do |config|
        config.primary_color = '#040712'
        config.is_authenticated = ->(_site) { true }
      end
    end

    describe 'GET /maglev/editor' do
      it 'redirects to the index page in the default site locale' do
        get '/maglev/editor'
        expect(response).to redirect_to('/maglev/editor/en/index')
      end

      it 'redirects to the index page in the specified locale' do
        get '/maglev/editor/fr'
        expect(response).to redirect_to('/maglev/editor/fr/index')
      end
    end

    describe 'GET /maglev/editor/:locale/(*path)' do
      it 'renders the editor UI' do
        get '/maglev/editor/en/index'
        expect(response.body).to include('My simple theme')
        expect(response.body).to include('window.baseUrl = "/maglev/editor"')
        expect(response.body).to include('window.apiBaseUrl = "/maglev/api"')
        expect(response.body).to include('window.site = {')
        expect(response.body).to include('window.page = {')
        expect(response.body).to include('window.theme = {')
        expect(response.body).to include('"nbRows":6')
      end

      describe 'Given the content editor had the sections tab opened in the UI' do
        it 'renders the editor UI' do
          get '/maglev/editor/en/about-us/_/editSettings'
          expect(response.body).to include('My simple theme')
          expect(response.body).to include('About us')
          expect(response.body).to include('window.site = {')
          expect(response.body).to include('window.page = {')
        end
      end

      describe 'Given the developer defined another UI locale' do
        before do
          Maglev.configure do |config|
            config.ui_locale = ui_locale
            config.primary_color = '#040712'
            config.is_authenticated = ->(_site) { true }
          end
        end

        context 'Given the developer defines it as a string' do
          let(:ui_locale) { 'fr' }

          it 'renders the editor in the defined locale' do
            get '/maglev/editor/en/index'
            expect(response.body).to include('<html class="h-full" lang="fr">')
          end
        end

        context 'Given the developer defines it using a method in the main app' do
          let(:ui_locale) { :exotic_locale }

          it 'renders the editor in the defined locale' do
            get '/maglev/editor/en/index'
            expect(response.body).to include('<html class="h-full" lang="fr">')
          end
        end

        context 'Given the developer defines it by using a Proc' do
          let(:ui_locale) { ->(_current_site) { 'fr' } }

          it 'renders the editor in the defined locale' do
            get '/maglev/editor/en/index'
            expect(response.body).to include(%(<html class="h-full" lang="fr">))
          end
        end
      end
    end

    describe 'GET /maglev/leave_editor' do
      before do
        Maglev.configure do |config|
          config.is_authenticated = ->(_site) { true }
          config.back_action = back_action
        end
      end

      context 'no back_action defined' do
        let(:back_action) { nil }

        it 'redirects to the root path of the application' do
          get '/maglev/leave_editor'
          expect(response).to redirect_to('/')
        end

        it 'clears the maglev_site_id from the session' do
          get '/maglev/leave_editor'
          expect(session[:maglev_site_id]).not_to eq nil
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
        let(:back_action) do
          lambda { |current_site|
            session[:maglev_site_id] = nil
            redirect_to "/somewhere-#{current_site.id}"
          }
        end

        it 'redirects to the url returned by the Proc' do
          get '/maglev/leave_editor'
          expect(response).to redirect_to("/somewhere-#{site.id}")
          expect(session[:maglev_site_id]).to eq nil
        end
      end
    end
  end
end
