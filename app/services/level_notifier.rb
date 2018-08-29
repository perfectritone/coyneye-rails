require 'faye/websocket'
require 'eventmachine'

class LevelNotifier
  def self.notify(direction, threshold, current_value)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} #{threshold} (#{current_value})"
    Pushover.new.notify message
  end

  def self.subscribe(direction_sym, threshold)
    direction = direction_map(direction_sym)

    EM.run {
      ws = Faye::WebSocket::Client.new('wss://api2.poloniex.com')

      ws.on :open do |event|
        ws.send({ command: "subscribe", channel: "149"}.to_json)
        p [:open_now]
      end
      ws.on :message do |event|
        data = JSON.parse(event.data)
        begin
          current_value = data[2][0][2].to_f or next
        rescue
          next
        end

        if current_value.send(direction, threshold)
          notify(direction_sym, threshold, current_value)
          ws.close
        end
      end
    }
  end

  protected

  def self.direction_map(direction_sym)
    case direction_sym
    when :greater_than
      :>
    end
  end
end
