class Maglev::Turbo::Streams::TagBuilder < ::Turbo::Streams::TagBuilder
  def console_log(message)
    turbo_stream_action_tag :console_log, message: message
  end
end