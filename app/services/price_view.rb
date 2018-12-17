class PriceView
  def current
    price&.amount
  end

  def time_updated
    price&.updated_at
  end

  def price
    @price ||= Price.get(
      from: self.class.usdt_record,
      to: self.class.eth_record,
    )
  end

  protected

  def self.eth_record
    @@eth_record ||= Currency.find_by(symbol: "ETH")
  end

  def self.usdt_record
    @@usdt_record ||= Currency.find_by(symbol: "USDT")
  end
end
