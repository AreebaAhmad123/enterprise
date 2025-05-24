class AddActingAsAdminToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :acting_as_admin, :boolean, default: false
  end
end 