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

            PriceUpdater.perform current_value
          end
        end
      end
    end
  end
end
