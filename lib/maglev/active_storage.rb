# frozen_string_literal: true

module Maglev
  module ActiveStorage
    extend ActiveSupport::Concern

    included do
      has_one_attached :file

      after_commit :save_metadata_now, on: :create, prepend: true

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
