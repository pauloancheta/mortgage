require 'test_helper'

class Mortgage < ActiveSupport::TestCase
  def call_service(attributes = {})
    defaults = {
      payment_amount: 1_000,
      down_payment: 20_000,
      amortization_period: 5,
      payment_schedule: "weekly"
    }.merge(attributes)

    Compute::Mortgage.call(defaults)
  end

  test "ensures that payments are formatted correctly" do
    assert_equal call_service.to_s.split(".").size, 2
  end

  test "provides principal without down payment" do
    assert_not_nil call_service(down_payment: 0)
  end

  test "provides principal mortgage" do
    assert_equal call_service, 264167.56
  end
end
