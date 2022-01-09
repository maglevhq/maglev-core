module Maglev
  class PreviewConstraint
    def matches?(request)
      request.format == :html
    end
  end
end