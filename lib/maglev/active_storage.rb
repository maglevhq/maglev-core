# frozen_string_literal: true

require_relative 'active_storage/serving_blob'

module Maglev
  module ActiveStorage
    extend ActiveSupport::Concern

    included do
      has_one_attached :file

      # NOTE: the metadata can only be extracted once Active Storage has uploaded the file,
      # which also happens in an after_commit callback (registered by has_one_attached above).
      # So this callback has to run after that one:
      # - with the legacy (reverse) order, it has to be prepended.
      # - with `run_after_transaction_callbacks_in_order_defined` (load_defaults 7.1+),
      #   it has to be appended. Since Rails 8.1.4, `prepend: true` really runs it first
      #   (before the upload), raising ActiveStorage::FileNotFoundError.
      after_commit :save_metadata_now, on: :create,
                                       prepend: !::ActiveRecord.run_after_transaction_callbacks_in_order_defined

      delegate :url, :download, to: :file
    end

    private

    # rubocop:disable Metrics/AbcSize
    def save_metadata_now
      file.analyze if file.attached?
      update(
        filename: file.filename.to_s,
        content_type: file.content_type,
        byte_size: file.byte_size,
        height: file.metadata['height'],
        width: file.metadata['width']
      )
    end
    # rubocop:enable Metrics/AbcSize

    module ClassMethods
      def optimized
        all.with_attached_file
      end
    end
  end
end
