class AddAuth0FieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :auth0_id, :string
    add_column :users, :nickname, :string
    add_column :users, :picture, :string
  end
end
