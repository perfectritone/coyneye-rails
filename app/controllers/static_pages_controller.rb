class StaticPagesController < ActionController::Base
  layout "application"

  def index
    @price_view = PriceView.new
  end
end
