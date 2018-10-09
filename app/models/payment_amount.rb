class PaymentAmount
  include Virtus.model

  MONTHS_IN_A_YEAR = 12
  WEEKS_IN_A_YEAR = 52
  BI_WEEKS_IN_A_YEAR = 26

  attribute :amount, Float
  attribute :interval, PaymentSchedule, default:  "monthly"

  def weekly
    return amount if interval == "weekly"
    payment_round(weekly_amount)
  end

  def bi_weekly
    return amount if interval == "bi-weekly"
    bi_weekly_amount = yearly_amount / BI_WEEKS_IN_A_YEAR
    payment_round(bi_weekly_amount)
  end

  def monthly
    return amount if interval == "monthly"
    monthly_amount = yearly_amount / MONTHS_IN_A_YEAR
    payment_round(monthly_amount)
  end

  private

  def weekly_amount
    return amount * MONTHS_IN_A_YEAR / WEEKS_IN_A_YEAR  if interval == "monthly"
    return amount / 2 if interval == "bi-weekly"
    return amount if interval == "weekly"
    raise
  end

  def yearly_amount
    weekly_amount * WEEKS_IN_A_YEAR
  end

  def payment_round(payment)
    payment.round(2)
  end
end
