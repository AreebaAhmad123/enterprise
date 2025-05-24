class AddConsultantRoleToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :consultant_role, :boolean
  end
end
