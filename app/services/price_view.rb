class PriceView
  def self.current
    eth = Currency.find_by(symbol: "ETH")
    usdt = Currency.find_by(symbol: "USDT")

    price = Price.where(
      from_currency: usdt,
      to_currency: eth,
    ).first

    price&.amount
  end
end
