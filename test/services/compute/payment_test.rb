require 'test_helper'

class Payment < ActiveSupport::TestCase
  def call_service(attributes = {})
    defaults = {
      asking_price: Money.new(amount: 1_000_000),
      down_payment: Money.new(amount: 300_000),
      amortization_period: 5,
      payment_schedule: "weekly"
    }.merge(attributes)

    Compute::Payment.call(defaults)
  end

  test "payments schedule can be either weekly, bi-weekly or monthly" do
    %w|weekly bi-weekly monthly|.each do |schedule|
      assert_not_nil call_service(payment_schedule: schedule)
    end

    assert_raises(PaymentSchedule::InvalidPaymentSchedule) {
      call_service(payment_schedule: "foo")
    }
  end


  test "amortization period should be more than 5 and less than 25" do
    assert_not_nil call_service(amortization_period: 5)
    assert_not_nil call_service(amortization_period: 25)

    assert_raises(AmortizationPeriod::InvalidAmortizationPeriod) {
      call_service(amortization_period: 26)
    }
  end

  test "down payment has to be more than 5% of the asking price" do
    asking_price = Money.new(amount: 750_000)
    down_payment = Money.new(amount: 50_000)
    insufficient_down = Money.new(amount: 49_000)
    assert_not_nil call_service(asking_price: asking_price, down_payment: down_payment)

    assert_raises(DownPayment::InvalidDownPayment) {
      call_service(asking_price: asking_price, down_payment: insufficient_down)
    }
  end

  test "payment is calculated" do
    assert_equal call_service, 2866.88
  end
end
