# frozen_string_literal: true

module Maglev
  module Assets
    class ActiveStorageProxyController < ::ActiveStorage::Blobs::ProxyController
      include Maglev::ResourceIdConcern

      private

      def set_blob
        @blob = Maglev::Asset.find(resource_id).file
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end
    end
  end
end
