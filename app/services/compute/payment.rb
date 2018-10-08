class Compute::Payment
  include Service

  PAYMENT_SCHEDULES = ["weekly", "bi-weekly", "monthly"]
  MIN_AMORTIZATION_PERIOD = 5
  MAX_AMORTIZATION_PERIOD = 25
  MIN_DOWNPAYMENT_PERCENTAGE = 0.05

  attribute :asking_price, Integer
  attribute :down_payment, Integer
  attribute :amortization_period, Integer
  attribute :payment_schedule, String

  def call
    raise InvalidPaymentSchedule if !valid_payment_schedule?(payment_schedule)
    raise InvalidAmortizationPeriod if !valid_amortization_period?(amortization_period)
    raise InvalidDownPayment if !valid_down_payment?(down_payment)

    2
  end

  private

  def valid_payment_schedule?(schedule)
    PAYMENT_SCHEDULES.include?(schedule)
  end

  def valid_amortization_period?(period)
    period.between?(MIN_AMORTIZATION_PERIOD, MAX_AMORTIZATION_PERIOD)
  end

  def valid_down_payment?(payment)
    (asking_price * MIN_DOWNPAYMENT_PERCENTAGE) <= down_payment
  end

  class InvalidPaymentSchedule < StandardError; end
  class InvalidAmortizationPeriod < StandardError; end
  class InvalidDownPayment < StandardError; end
end
