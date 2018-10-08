Rails.application.routes.draw do
  get "/payment-amount" => "amount#payment", as: :payment
  get "/mortgage-amount" => "amount#mortgage", as: :mortgage
  patch "/interest-rate" => "amount#update_interest_rate", as: :interest_rate
end
