class StaticPagesController < ActionController::Base
  layout "application"

  def index
    PoloniexFeedSubscriber.reset
    @price_view_collection = PriceViewCollection.new

    CURRENCY_PAIRS.each do |currency_pair|
      @price_view_collection.new_price_view currency_pair: currency_pair
    end
  end
end
