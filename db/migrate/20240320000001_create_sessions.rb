class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, null: false, default: 'pending'
      t.references :user, null: false, foreign_key: true
      t.references :consultant, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :sessions, [:consultant_id, :start_time, :end_time]
  end
end 