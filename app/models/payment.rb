validates :amount, numericality: { greater_than: 0 }

class Payment < ApplicationRecord
  belongs_to :meeting
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending completed failed refunded] }
  validates :stripe_payment_intent_id, presence: true, uniqueness: true
  validates :card_brand, presence: true
  validates :card_last4, presence: true, length: { is: 4 }

  before_validation :set_defaults, on: :create
  after_create :create_stripe_payment_intent
  after_update :handle_status_change

  def process_payment(payment_method_id)
    return false unless pending?

    begin
      payment_intent = Stripe::PaymentIntent.retrieve(stripe_payment_intent_id)
      payment_intent = Stripe::PaymentIntent.confirm(
        payment_intent.id,
        payment_method: payment_method_id
      )

      if payment_intent.status == 'succeeded'
        update!(
          status: 'succeeded',
          paid_at: Time.current,
          card_brand: payment_intent.charges.data.first.payment_method_details.card.brand,
          card_last4: payment_intent.charges.data.first.payment_method_details.card.last4
        )
        true
      else
        false
      end
    rescue Stripe::StripeError => e
      update(status: 'failed')
      false
    end
  end

  def refund
    return false if refunded?
    
    begin
      refund = Stripe::Refund.create(
        payment_intent: stripe_payment_intent_id,
        reason: 'requested_by_customer'
      )
      
      update(
        status: 'refunded',
        refunded_at: Time.current,
        stripe_refund_id: refund.id
      )
      true
    rescue Stripe::StripeError => e
      errors.add(:base, "Refund failed: #{e.message}")
      false
    end
  end

  def refunded?
    status == 'refunded'
  end

  private

  def set_defaults
    self.currency ||= 'usd'
    self.status ||= 'pending'
  end

  def create_stripe_payment_intent
    return if stripe_payment_intent_id.present?

    begin
      payment_intent = Stripe::PaymentIntent.create(
        amount: (amount * 100).to_i, # Convert to cents
        currency: currency,
        customer: user.stripe_customer_id,
        metadata: {
          session_id: session_id,
          user_id: user_id
        }
      )

      update!(stripe_payment_intent_id: payment_intent.id)
    rescue Stripe::StripeError => e
      update!(status: 'failed')
    end
  end

  def handle_status_change
    if saved_change_to_status? && status == 'succeeded'
      PaymentMailer.payment_confirmation(self).deliver_later
    end
  end
end