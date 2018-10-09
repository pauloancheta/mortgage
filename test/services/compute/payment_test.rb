require 'test_helper'

class Payment < ActiveSupport::TestCase
  def call_service(attributes = {})
    defaults = {
      asking_price: 1_000_000,
      down_payment: 300_000,
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
    assert_not_nil call_service(asking_price: 750_000, down_payment: 50_000)

    assert_raises(DownPayment::InvalidDownPayment) {
      call_service(asking_price: 750_000, down_payment: 49_000)
    }
  end

  test "payment is calculated" do
    assert_equal call_service, 12423.15
  end
end
