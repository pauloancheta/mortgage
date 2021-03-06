class AmountController < ApplicationController

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
    asking_price = Money.new(amount: params.fetch(:asking_price))
    down_payment = Money.new(amount: params.fetch(:down_payment))
    val = Compute::Payment.call(
      asking_price: asking_price,
      down_payment: down_payment,
      amortization_period: params.fetch(:amortization_period),
      payment_schedule: params.fetch(:payment_schedule),
    )
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
    payment_amount = Money.new(amount: params.fetch(:payment_amount))
    down_payment = Money.new(amount: params.fetch(:down_payment, 0))
    val = Compute::Mortgage.call(
      payment_amount: payment_amount,
      down_payment: down_payment, # optional
      amortization_period: params.fetch(:amortization_period),
      payment_schedule: params.fetch(:payment_schedule),
    )
    render json: {"mortgage-amount" => val}
  end

  # Change interest rate used by the application
  def update_interest_rate
    rate = params[:interest_rate]
    current_rate = InterestRate.current_rate

    if rate.is_a?(Float) || rate.is_a?(Integer)
      updated_rate = InterestRate.update_current_rate!(rate: [rate.to_f, 0].max)
      render json: {"new_rate" => updated_rate.rate, "old_rate" => current_rate}
    else
      render json: {"error" => "Parameter rate is not a number. Use a whole number or a decimal. For example: 2.5"}
    end
  end
end
