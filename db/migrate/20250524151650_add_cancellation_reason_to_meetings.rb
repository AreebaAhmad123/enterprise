class AddCancellationReasonToMeetings < ActiveRecord::Migration[7.2]
  def change
    add_column :meetings, :cancellation_reason, :text
  end
end