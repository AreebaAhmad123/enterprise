class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :meeting, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :currency, null: false, default: 'usd'
      t.string :status, null: false
      t.string :stripe_payment_intent_id, null: false
      t.string :stripe_refund_id
      t.string :card_brand
      t.string :card_last4
      t.datetime :refunded_at
      t.text :error_message

      t.timestamps
    end

    add_index :payments, :stripe_payment_intent_id, unique: true
    add_index :payments, :stripe_refund_id, unique: true
  end
end 