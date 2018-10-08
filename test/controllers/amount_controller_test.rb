require 'test_helper'

class AmountControllerTest < ActionDispatch::IntegrationTest
  test "passing params should be valid" do
    @params = {asking_price: 1, down_payment: 1, payment_schedule: "weekly"}.to_json
    get payment_path(@params), as: :json
    assert_response :success
  end

  test "should update interest rate" do
    new_interest_rate = 1
    patch interest_rate_path, params: { interest_rate: 1 }, as: :json
    assert_response 200
    assert_equal InterestRate.first.rate, new_interest_rate.to_f
  end

  test "strings should not update the interest rate" do
    new_interest_rate = "foo"
    patch interest_rate_path, params: { interest_rate: new_interest_rate }, as: :json
    assert_response 200
    assert_not_equal InterestRate.first.rate, 0.0
  end
end
