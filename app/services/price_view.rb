class PriceView
  attr_reader :currency_pair

  def initialize(currency_pair:)
    @currency_pair = currency_pair
  end

  def formatted_currency_pair
    "#{currency_pair.from}/#{currency_pair.to}"
  end

  def current
    price&.amount
  end

  def time_updated
    price&.updated_at
  end

  def price
    @price ||= Price.get(
      from: from_record,
      to: to_record,
    )
  end

  def from
    currency_pair.from
  end

  def to
    currency_pair.to
  end

  protected

  def from_record
    @from_record ||= Currency.find_by(symbol: currency_pair.from)
  end

  def to_record
    @to_record ||= Currency.find_by(symbol: currency_pair.to)
  end
end
