# frozen_string_literal: true

require_relative 'active_storage/serving_blob'

module Maglev
  module ActiveStorage
    extend ActiveSupport::Concern

    included do
      has_one_attached :file

      # Must run *after* Active Storage's own after_commit callback (registered
      # by has_one_attached above), which is what actually writes the file:
      # upstream prepended it and hits ActiveStorage::FileNotFoundError on any
      # Rails version that defers the upload to after_commit (8.1).
      after_commit :save_metadata_now, on: :create

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
