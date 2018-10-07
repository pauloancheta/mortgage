Rails.application.routes.draw do
  get "/payment-amount" => "amount#payment"
  get "/mortgage-amount" => "amount#mortgage"
  patch "/interest-rate" => "amount#update_interest_rate"
end
