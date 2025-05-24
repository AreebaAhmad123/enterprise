class AddFirstAndLastNameToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :first_name)
      add_column :users, :first_name, :string, null: false, default: ""
    end
    unless column_exists?(:users, :last_name)
      add_column :users, :last_name, :string, null: false, default: ""
    end
    if column_exists?(:users, :name)
      # Split existing `name` into `first_name` and `last_name`
      reversible do |dir|
        dir.up do
          User.find_each do |user|
            if user.name.present?
              names = user.name.split(" ", 2)
              user.update!(
                first_name: names[0] || "",
                last_name: names[1] || ""
              )
            end
          end
          remove_column :users, :name, :string
        end
        dir.down do
          add_column :users, :name, :string
          User.find_each do |user|
            user.update!(name: "#{user.first_name} #{user.last_name}".strip)
          end
        end
      end
    end
  end
end