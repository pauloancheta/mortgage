class Compute::Payment
  include Service

  PAYMENT_SCHEDULES = ["weekly", "bi-weekly", "monthly"]

  MIN_AMORTIZATION_PERIOD = 5
  MAX_AMORTIZATION_PERIOD = 25
  MONTHS_IN_A_YEAR = 12

  FIRST_DOWN_PAYMENT_PERCENTAGE = 0.05
  SECOND_DOWN_PAYMENT_PERCENTAGE = 0.10
  FIRST_DOWN_PAYMENT = 500_000

  attribute :asking_price, Integer
  attribute :down_payment, Integer
  attribute :amortization_period, Integer
  attribute :payment_schedule, String
  attribute :interest_rate, Float, default: proc { InterestRate.current_rate }

  def call
    raise InvalidPaymentSchedule if !valid_payment_schedule?
    raise InvalidAmortizationPeriod if !valid_amortization_period?
    raise InvalidDownPayment if !valid_down_payment?

    # P = L [c(1 + c)^n] / [(1+c)^n - 1]

    # i = (1 + c)^n
    interest = ((1 + monthly_interest_rate) ** amortization_in_months)

    # L[c * i]
    first = loan_amount * monthly_interest_rate * interest

    # i - 1
    second = interest - 1

    (first / second).round(2)
  end

  private

  def loan_amount
    asking_price - down_payment
  end

  def amortization_in_months
    amortization_period * MONTHS_IN_A_YEAR
  end

  def monthly_interest_rate
    (interest_rate / MONTHS_IN_A_YEAR) / 100
  end

  def valid_payment_schedule?
    PAYMENT_SCHEDULES.include?(payment_schedule)
  end

  def valid_amortization_period?
    amortization_period.between?(MIN_AMORTIZATION_PERIOD, MAX_AMORTIZATION_PERIOD)
  end

  def valid_down_payment?
    return (asking_price * FIRST_DOWN_PAYMENT) > down_payment if asking_price <= FIRST_DOWN_PAYMENT

    first_down_payment = FIRST_DOWN_PAYMENT * FIRST_DOWN_PAYMENT_PERCENTAGE
    second_down_payment = (asking_price - FIRST_DOWN_PAYMENT) * SECOND_DOWN_PAYMENT_PERCENTAGE

    (first_down_payment + second_down_payment) <= down_payment
  end

  class InvalidPaymentSchedule < StandardError; end
  class InvalidAmortizationPeriod < StandardError; end
  class InvalidDownPayment < StandardError; end
end
