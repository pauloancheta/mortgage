# Computes Payment Amount of Mortgages
# The basic formula is:
#   L = P * (i - 1) / c * i
#
# P = monthly payment amount
# L = principal / asking_price (- downpayment)
# c = monthly_interest_rate
# n = amortization_in_months
class Compute::Mortgage
  include Service

  MONTHS_IN_A_YEAR = 12

  attribute :payment_amount, Money
  attribute :down_payment, Money
  attribute :amortization_period, AmortizationPeriod
  attribute :payment_schedule, PaymentSchedule

  def call
    # i = (1 + c)^n
    interest = ((1 + monthly_interest_rate) ** amortization_in_months)

    dividend = payments.monthly * (interest - 1)
    divisor = interest * monthly_interest_rate

    down_payment + (dividend/divisor).round(2)
  end

  private

  def payments
    ::PaymentAmount.new(amount: payment_amount, interval: payment_schedule.underscore)
  end

  def amortization_in_months
    amortization_period * MONTHS_IN_A_YEAR
  end

  def monthly_interest_rate
    (interest_rate / MONTHS_IN_A_YEAR) / 100
  end

  def interest_rate
    ::InterestRate.current_rate
  end
end
