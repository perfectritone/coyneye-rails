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

  def over_maximum_threshold?(current_value)
    UserThreshold.max && current_value >= UserThreshold.max
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
