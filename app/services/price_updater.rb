class PriceUpdater

  def self.perform price
    new.perform price
  end

  def perform price
    record! price
    send_notifications! price
  end

  def notify!(direction, current_value)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} threshold (#{current_value})"
    Pushover.new.notify message
  end

  def notify_thresholds?
    Sleep.awake?
  end

  def record!(price)
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

  private

  def from_currency
    @from_currency ||= Currency.find_by(symbol: from_currency_symbol)
  end

  def from_currency_symbol
    "USDT"
  end

  def over_maximum_threshold?(current_value)
    UserThreshold.max && current_value >= UserThreshold.max
  end

  def send_notifications!(price)
    if notify_thresholds?
      if over_maximum_threshold?(price)
        UserThreshold.max_met!
        direction = "above"
      end

      if under_minimum_threshold?(price)
        UserThreshold.min_met!
        direction = "below"
      end

      notify!(direction, price)
    end
  end

  def to_currency
    @to_currency ||= Currency.find_by(symbol: to_currency_symbol)
  end

  def to_currency_symbol
    "ETH"
  end

  def under_minimum_threshold?(current_value)
    UserThreshold.min && current_value <= UserThreshold.min
  end
end
