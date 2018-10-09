class DownPayment
  include Service

  FIRST_DOWN_PAYMENT_PERCENTAGE = 0.05
  SECOND_DOWN_PAYMENT_PERCENTAGE = 0.10
  FIRST_DOWN_PAYMENT = 500_000

  MIN_DOWN_PAYMENT = 0.05
  LOW_DOWN_PAYMENT = 0.0999
  MID_DOWN_PAYMENT = 0.1499
  MAX_DOWN_PAYMENT = 0.1999

  MIN_DOWN_INSURANCE_RATE = 0.0315
  LOW_DOWN_INSURANCE_RATE = 0.024
  MID_DOWN_INSURANCE_RATE = 0.018


  attribute :down_payment, Money
  attribute :asking_price, Money

  def create!
    raise InvalidDownPayment if !valid_down_payment?
    down_payment + mortgage_insurance_cost
  end

  private

  def valid_down_payment?
    return (asking_price * FIRST_DOWN_PAYMENT) > down_payment.to_f if asking_price <= FIRST_DOWN_PAYMENT

    first_down_payment = FIRST_DOWN_PAYMENT * FIRST_DOWN_PAYMENT_PERCENTAGE
    second_down_payment = (asking_price - FIRST_DOWN_PAYMENT) * SECOND_DOWN_PAYMENT_PERCENTAGE

    down_payment >= (first_down_payment + second_down_payment)
  end

  def mortgage_insurance_cost
    rate = down_payment / asking_price
    return asking_price * MIN_DOWN_INSURANCE_RATE if rate <= LOW_DOWN_PAYMENT && rate >= MIN_DOWN_PAYMENT
    return asking_price * LOW_DOWN_INSURANCE_RATE if rate <= MID_DOWN_PAYMENT
    return asking_price * MID_DOWN_INSURANCE_RATE if rate <= MAX_DOWN_PAYMENT
    0
  end

  class InvalidDownPayment < StandardError; end
end
