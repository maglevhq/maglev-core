# frozen_string_literal: true

module Maglev
  class ReservedPaths < ::Array
    def include?(value)
      each do |path|
        return true if path == value ||
                       (path.include?('*') && value && File.fnmatch(path, value))
      end
      false
    end
  end
end
