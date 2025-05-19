class ChangeEndTimeToDurationInMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :duration, :integer
    Meeting.where.not(end_time: nil).each do |meeting|
      meeting.update(duration: ((meeting.end_time - meeting.start_time) / 60).to_i)
    end
    remove_column :meetings, :end_time, :datetime
  end
end