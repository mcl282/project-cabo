class CreatePlaidCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :plaid_credentials do |t|
      t.references :user, foreign_key: true
      t.string :access_token
      t.string :item_id

      t.timestamps
    end
  end
end
