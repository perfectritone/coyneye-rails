class PriceUpdater

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
end
