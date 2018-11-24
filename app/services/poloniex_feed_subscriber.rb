require 'faye/websocket'
require 'eventmachine'

class PoloniexFeedSubscriber
  def perform
    Thread.new do
      EventMachine.run do
        ws = Faye::WebSocket::Client.new('wss://api2.poloniex.com')

        ws.on :open do |event|
          ws.send({ command: "subscribe", channel: "1002"}.to_json)
          p [:open_now]
        end

        ws.on :message do |event|
          data = JSON.parse(event.data)

          if data[2] && data[2][0] == 149
            current_value = data[2][1].to_f
          else
            next
          end

          record_current_value(current_value)

          send_notifications!(current_value)
        end
      end
    end
  end

  private

  def from_currency
    @from_currency ||= Currency.find_by(symbol: from_currency_symbol)
  end

  def from_currency_symbol
    "USDT"
  end

  def notify(direction, current_value)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} threshold (#{current_value})"
    Pushover.new.notify message
  end

  def notify_thresholds?
    Sleep.awake?
  end

  def over_maximum_threshold?(current_value)
    UserThreshold.max && current_value >= UserThreshold.max
  end

  def record_current_value(current_value)
    updated_records = Price.update_all(
      "amount = #{current_value}"
    )

    if updated_records == 0
      Price.create(
        from_currency: from_currency,
        to_currency: to_currency,
        amount: current_value,
      )
    end
  end

  def send_notifications!(current_value)
    if notify_thresholds?
      if over_maximum_threshold?(current_value)
        UserThreshold.max_met
        notify("above", current_value)
      end

      if under_minimum_threshold?(current_value)
        UserThreshold.min_met
        notify("below", current_value)
      end
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
