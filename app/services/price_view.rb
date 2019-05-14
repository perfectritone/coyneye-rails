class PriceView
  def currency_pair
    "#{CurrencyPair::FROM}/#{CurrencyPair::TO}"
  end

  def current
    price&.amount
  end

  def time_updated
    price&.updated_at
  end

  def price
    @price ||= Price.get(
      from: self.class.from_record,
      to: self.class.to_record,
    )
  end

  protected

  def self.from_record
    @@from_record ||= Currency.find_by(symbol: CurrencyPair::FROM)
  end

  def self.to_record
    @@to_record ||= Currency.find_by(symbol: CurrencyPair::TO)
  end
end
