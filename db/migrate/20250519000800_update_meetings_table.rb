class UpdateMeetingsTable < ActiveRecord::Migration[7.2]
  def change
    change_table :meetings do |t|
      t.remove :end_time if column_exists?(:meetings, :end_time)
      t.integer :duration unless column_exists?(:meetings, :duration)
      t.string :status, default: 'scheduled' unless column_exists?(:meetings, :status)
      t.references :client, null: false, foreign_key: { to_table: :users } unless column_exists?(:meetings, :client_id)
      t.references :consultant, null: false, foreign_key: { to_table: :users } unless column_exists?(:meetings, :consultant_id)
      t.text :cancellation_reason unless column_exists?(:meetings, :cancellation_reason)
    end

    change_table :users do |t|
      t.boolean :acting_as_admin, default: false unless column_exists?(:users, :acting_as_admin)
    end
  end
end