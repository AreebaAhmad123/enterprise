class AddActingAsAdminFlag < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :acting_as_admin)
      add_column :users, :acting_as_admin, :boolean, default: false
    end
  end
end 