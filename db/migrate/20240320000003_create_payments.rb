class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :currency, default: 'usd', null: false
      t.string :status, null: false
      t.string :stripe_payment_intent_id
      t.string :stripe_customer_id
      t.string :card_brand
      t.string :card_last4
      t.datetime :paid_at

      t.timestamps
    end

    add_index :payments, :stripe_payment_intent_id, unique: true
    add_index :payments, :stripe_customer_id
  end
end 