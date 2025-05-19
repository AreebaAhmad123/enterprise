class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :consultant, null: false, foreign_key: { to_table: :users }
      t.string :status, default: 'scheduled'

      t.timestamps
    end
  end
end