class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :consultant, null: false, foreign_key: { to_table: :users }
      t.string :status, default: "pending"

      t.timestamps
      belongs_to :client, class_name: "User"
      belongs_to :consultant, class_name: "User"
      validates :title, :start_time, :end_time, :client_id, :consultant_id, presence: true
      validates :status, inclusion: { in: %w[pending confirmed cancelled paid] }

      scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
      scope :past, -> { where("start_time <= ?", Time.current).order(:start_time) }

    end
  end
end