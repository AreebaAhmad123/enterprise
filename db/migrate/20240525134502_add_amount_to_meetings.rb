class AddAmountToMeetings < ActiveRecord::Migration[7.2]
  def change
    add_column :meetings, :amount, :decimal, precision: 10, scale: 2, default: 50.00
  end
end 