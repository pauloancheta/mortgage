class PaymentSchedule < Virtus::Attribute
  PAYMENT_SCHEDULES = ["weekly", "bi-weekly", "monthly"]

  def coerce(schedule)
    raise InvalidPaymentSchedule if !PAYMENT_SCHEDULES.include?(schedule)
    schedule
  end

  class InvalidPaymentSchedule < StandardError; end
end
