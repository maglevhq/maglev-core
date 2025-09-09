class Maglev::Turbo::Streams::TagBuilder < ::Turbo::Streams::TagBuilder
  def console_log(message)
    turbo_stream_action_tag :console_log, message: message
  end

  def dispatch_event(type, payload:)
    turbo_stream_action_tag :dispatch_event, type: type, payload: payload
  end
end