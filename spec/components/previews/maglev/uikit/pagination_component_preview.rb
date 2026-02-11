# frozen_string_literal: true

require 'pagy/extras/array'

module Maglev
  module Uikit
    class PaginationComponentPreview < ViewComponent::Preview
      include Pagy::Backend

      # @param hidden_if_single_page toggle
      def none(hidden_if_single_page: false)
        pagy, = pagy_array([], limit: 5)
        render(Maglev::Uikit::PaginationComponent.new(pagy: pagy, hidden_if_single_page: hidden_if_single_page,
                                                      item_name: 'account'))
      end

      # @param hidden_if_single_page toggle
      def one(hidden_if_single_page: false)
        pagy, = pagy_array(accounts.take(1), limit: 5)
        render(Maglev::Uikit::PaginationComponent.new(pagy: pagy, hidden_if_single_page: hidden_if_single_page,
                                                      item_name: 'account'))
      end

      # @param hidden_if_single_page toggle
      # @param show_info toggle
      def many(hidden_if_single_page: false, show_info: true)
        pagy, = pagy_array(accounts, limit: 5)
        render(Maglev::Uikit::PaginationComponent.new(pagy: pagy, hidden_if_single_page: hidden_if_single_page,
                                                      item_name: 'account', show_info: show_info))
      end

      private

      def params
        {}
      end

      def accounts
        20.times.map do |i|
          MockedAccount.new(name: "John Doe #{i}", email: "john#{i}@doe.net", avatar_url: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80')
        end
      end

      class MockedAccount
        include ActiveModel::API
        attr_accessor :name, :email, :avatar_url
      end
    end
  end
end
