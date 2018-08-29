require 'net/http'
require 'uri'

class Poloniex
  include ActiveSupport::Configurable

  def self.maximum_threshold=(max)
    @@max = max
  end

  def self.maximum_threshold
    @@max ||= nil
  end

  def self.current_value
    response = Net::HTTP.get URI('https://poloniex.com/public?command=returnTicker')
    json = JSON.parse(response)
    json["USDT_ETH"]["last"].to_f
  end

  def self.currency_pair
    "USDT_ETH"
  end
end
