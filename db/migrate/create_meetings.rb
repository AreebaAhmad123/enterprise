class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.integer :duration
      t.string :status, default: 'scheduled'
      t.timestamps
    end
  end
end
class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meeting, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :meeting, null: false, foreign_key: true
      t.string :stripe_charge_id
      t.decimal :amount
      t.string :card_brand
      t.string :card_last4
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end