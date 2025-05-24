class RemoveConfirmationFieldsFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
  end
end