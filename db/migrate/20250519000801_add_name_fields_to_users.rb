class AddNameFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    
    # Migrate existing name data if present
    User.where.not(name: nil).find_each do |user|
      name_parts = user.name.split(' ', 2)
      user.update_columns(
        first_name: name_parts[0],
        last_name: name_parts[1] || ''
      )
    end
    
    # Remove the old name column
    remove_column :users, :name, :string
  end
end 