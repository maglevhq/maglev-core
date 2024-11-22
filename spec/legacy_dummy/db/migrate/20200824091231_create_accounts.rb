# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
