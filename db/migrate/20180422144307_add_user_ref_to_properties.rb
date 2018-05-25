class AddUserRefToProperties < ActiveRecord::Migration[5.0]
  def change
    add_reference :properties, :user, foreign_key: true
  end
end
