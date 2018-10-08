class InterestRate < ApplicationRecord
  def self.current_rate
    last.rate
  end

  def self.update_current_rate!(rate:)
    last.update!(rate: rate)
    last
  end
end
