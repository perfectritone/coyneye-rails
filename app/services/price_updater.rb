class PriceUpdater
  cattr_accessor :last_price

  def self.perform price
    new(price).perform
  end

  def self.from_currency
    @from_currency ||= Currency.find_or_create_by(symbol: CURRENCY_PAIRS[0].from)
  end

  def self.to_currency
    @to_currency ||= Currency.find_or_create_by(symbol: CURRENCY_PAIRS[0].to)
  end

  def initialize(price)
    @price = price
  end

  attr_reader :price

  def perform
    return if price == self.class.last_price

    record!
    send_notifications!
  end

  private

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
    Price.delete_all

    Price.create!(
      from_currency: self.class.from_currency,
      to_currency: self.class.to_currency,
      amount: price,
    )

    self.class.last_price = price
  end

  def send_notifications!
    if notify_thresholds?
      if over_maximum_threshold?
        UserThreshold.max_met!
        direction = "above"
      elsif under_minimum_threshold?
        UserThreshold.min_met!
        direction = "below"
      else
        return
      end

      notify!(direction)
    end
  end

  def under_minimum_threshold?
    UserThreshold.min && price <= UserThreshold.min
  end
end
