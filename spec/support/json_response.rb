# frozen_string_literal: true

module JsonResponse
  def json_response
    JSON.parse(response.body)
  end
end
