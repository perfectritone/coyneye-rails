class PriceUpdater

  def self.perform price
    new(price).perform
  end

  attr_reader :price

  def initialize(price)
    @price = price
  end

  def perform
    record!
    send_notifications!
  end

  private

  def from_currency
    @from_currency ||= Currency.find_by(symbol: from_currency_symbol)
  end

  def from_currency_symbol
    "USDT"
  end

  def notify!(direction)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} threshold (#{price})"
    Pushover.new.notify message
  end

  def notify_thresholds?
    Sleep.awake?
  end

  def over_maximum_threshold?
    UserThreshold.max && price >= UserThreshold.max
  end

  def record!
    Price.first.update_attributes(
      amount: price,
    )
  rescue NoMethodError
    Price.create(
      from_currency: from_currency,
      to_currency: to_currency,
      amount: price,
    )
  end

  def send_notifications!
    if notify_thresholds?
      if over_maximum_threshold?
        UserThreshold.max_met!
        direction = "above"
      end

      if under_minimum_threshold?
        UserThreshold.min_met!
        direction = "below"
      end

      notify!(direction)
    end
  end

  def to_currency
    @to_currency ||= Currency.find_by(symbol: to_currency_symbol)
  end

  def to_currency_symbol
    "ETH"
  end

  def under_minimum_threshold?
    UserThreshold.min && price <= UserThreshold.min
  end
end
