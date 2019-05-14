require 'faye/websocket'
require 'eventmachine'

class PoloniexFeedSubscriber
  CURRENCY_PAIR_IDS = {
    'USDT' => {
      'ETH' => 149,
    },
    'USDC' => {
      'ETH' => 225,
    },
  }

  def perform
    Thread.new do
      EventMachine.run do
        ws = Faye::WebSocket::Client.new('wss://api2.poloniex.com')

        ws.on :open do |event|
          ws.send({ command: "subscribe", channel: "1002"}.to_json)
        end

        ws.on :message do |event|
          data = JSON.parse(event.data)

          if data.dig(2, 0) == CURRENCY_PAIR_IDS[CurrencyPair::FROM][CurrencyPair::TO]
            current_value = data[2][1].to_f

            PriceUpdater.perform current_value
          end
        end
      end
    end
  end
end
