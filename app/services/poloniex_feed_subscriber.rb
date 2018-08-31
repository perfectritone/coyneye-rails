require 'faye/websocket'
require 'eventmachine'

class PoloniexFeedSubscriber
  def perform
    EM.run {
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

        if over_maximum_threshold?(current_value)
          UserThreshold.reset_max
          notify("above", current_value)
        end
      end
    }
  end

  private

  def notify(direction, current_value)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} threshold (#{current_value})"
    Pushover.new.notify message
  end

  def over_maximum_threshold?(current_value)
    UserThreshold.max && current_value > UserThreshold.max
  end
end
