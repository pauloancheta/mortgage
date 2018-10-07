class AmountController < ApplicationController
  MORTGAGE_INTEREST_RATE = 2.5

  # @params
  # asking_price
  # down_payment
  #   - must be at least 5% of the first 500k plus 10% of any amount above 500k (50k on a 750k)
  # amortization_period
  #   - min 5 years maximum of 25 years
  # payment_schedule
  #   - weekly, bi-weekly or monthly
  # @return
  # Payment amount per scheduled payment
  def payment
    val = "hello world"
    render json: {"mortgage-amount" => val}
  end

  # @params
  # payment_amount
  # down_payment (optional)
  #   - if included, it's value should be added to the maximum mortgage returned
  # payment_schedule
  #   - weekly, bi-weekly or monthly
  # mortization_period
  #   - min 5 years maximum of 25 years
  # @return
  # Maximum mortgage that can be taken out
  def mortgage
    val = "hello world"
    render json: {"mortgage-amount" => val}
  end

  # Change interest rate used by the application
  def update_interest_rate
    @interest_rate ||= MORTGAGE_INTEREST_RATE
  end

  private
end
