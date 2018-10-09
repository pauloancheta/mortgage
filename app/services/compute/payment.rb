# Computes Payment Amount of Mortgages
# The basic formula is:
#   P = L [c(1 + c)^n] / [(1+c)^n - 1]
#
# P = payment amount
# L = principal / asking_price (- downpayment)
# c = monthly_interest_rate
# n = amortization_in_months
class Compute::Payment
  include Service

  MONTHS_IN_A_YEAR = 12

  attribute :asking_price, Float
  attribute :down_payment, Float
  attribute :amortization_period, AmortizationPeriod
  attribute :payment_schedule, PaymentSchedule
  attribute :interest_rate, Float, default: proc { InterestRate.current_rate }

  def call
    # i = (1 + c)^n
    interest = ((1 + monthly_interest_rate) ** amortization_in_months)

    dividend = loan_amount * monthly_interest_rate * interest
    divisor = interest - 1

    (dividend / divisor).round(2)
  end

  private

  def loan_amount
    asking_price - sanitized_down_payment
  end

  def amortization_in_months
    amortization_period * MONTHS_IN_A_YEAR
  end

  def monthly_interest_rate
    (interest_rate / MONTHS_IN_A_YEAR) / 100
  end

  def sanitized_down_payment
    ::DownPayment.new(asking_price: asking_price, down_payment: down_payment).create!
  end
end
