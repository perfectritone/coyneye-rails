class PriceViewCollection
  attr_reader :price_views

  def initialize
    @price_views = []
  end

  delegate :each, to: :price_views

  def <<(price_view)
    price_views << price_view
  end

  def new_price_view(currency_pair:)
    self.<< PriceView.new(currency_pair: currency_pair)
  end
end
