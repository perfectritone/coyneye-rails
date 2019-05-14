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
    @from_currency ||= Currency.find_or_create_by(symbol: CurrencyPair::FROM)
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
    Price.delete_all

    Price.create!(
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
      elsif under_minimum_threshold?
        UserThreshold.min_met!
        direction = "below"
      else
        return
      end

      notify!(direction)
    end
  end

  def to_currency
    @to_currency ||= Currency.find_or_create_by(symbol: CurrencyPair::TO)
  end

  def under_minimum_threshold?
    UserThreshold.min && price <= UserThreshold.min
  end
end
