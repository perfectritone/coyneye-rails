class PriceView
  cattr_reader :price

  def self.current
    price&.amount
  end

  def self.clear!
    remove_class_variable(:@@price)
  end

  def self.time_updated
    price&.updated_at
  end

  def self.price
    @@price ||= begin
      eth = Currency.find_by(symbol: "ETH")
      usdt = Currency.find_by(symbol: "USDT")

      Price.where(
        from_currency: usdt,
        to_currency: eth,
      ).first
    end
  end
end
