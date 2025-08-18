class ActiveRecord::Migration
  def mysql?
    connection.adapter_name.downcase == 'mysql2'
  end
end