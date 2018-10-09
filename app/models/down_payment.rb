class DownPayment
  include Service

  FIRST_DOWN_PAYMENT_PERCENTAGE = 0.05
  SECOND_DOWN_PAYMENT_PERCENTAGE = 0.10
  FIRST_DOWN_PAYMENT = 500_000

  attribute :down_payment, Float
  attribute :asking_price, Float

  def create!
    raise InvalidDownPayment if !valid_down_payment?
    down_payment
  end

  private

  def valid_down_payment?
    return (asking_price * FIRST_DOWN_PAYMENT) > down_payment if asking_price <= FIRST_DOWN_PAYMENT

    first_down_payment = FIRST_DOWN_PAYMENT * FIRST_DOWN_PAYMENT_PERCENTAGE
    second_down_payment = (asking_price - FIRST_DOWN_PAYMENT) * SECOND_DOWN_PAYMENT_PERCENTAGE

    (first_down_payment + second_down_payment) <= down_payment
  end

  class InvalidDownPayment < StandardError; end
end
