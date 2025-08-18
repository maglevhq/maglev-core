# frozen_string_literal: true

module DatabaseConnectionHelper
  extend ActiveSupport::Concern

  included do
    before(:each) do
      ensure_database_connection
    end
  end

  private

  def ensure_database_connection
    return unless mysql_database?

    # Check if connection is still alive
    unless ActiveRecord::Base.connection.active?
      ActiveRecord::Base.connection.reconnect!
    end
  rescue ActiveRecord::StatementInvalid, ActiveRecord::ConnectionNotEstablished
    # If reconnection fails, try to establish a new connection
    ActiveRecord::Base.establish_connection
  end

  def mysql_database?
    ActiveRecord::Base.connection.adapter_name.downcase == 'mysql2'
  end
end

RSpec.configure do |config|
  config.include DatabaseConnectionHelper
end
