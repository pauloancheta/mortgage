class Money
  include ActionView::Helpers::NumberHelper
  include Virtus.model
  include Comparable

  MoneyCoercer = ->(amount) { [0, amount.to_f].max }

  attribute :amount, Float, coercer: MoneyCoercer

  def to_f
    amount.round(2)
  end

  def to_s
    "$#{delimited_number}"
  end

  def inspect
    delimited_number
  end

  def delimited_number
    number_with_delimiter(to_f, delimiter: ",")
  end

  def /(val)
    self.to_f / val.to_f
  end

  def *(val)
    self.to_f * val.to_f
  end

  def +(val)
    self.to_f + val.to_f
  end

  def -(val)
    self.to_f - val.to_f
  end

  def <=>(val)
    to_f <=> val.to_f
  end
end
