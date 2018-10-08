class AmortizationPeriod < Virtus::Attribute
  MIN_AMORTIZATION_PERIOD = 5
  MAX_AMORTIZATION_PERIOD = 25

  def coerce(period)
    period = period.to_i
    raise InvalidAmortizationPeriod if !period.between?(MIN_AMORTIZATION_PERIOD, MAX_AMORTIZATION_PERIOD)
    period
  end

  class InvalidAmortizationPeriod < StandardError; end
end
