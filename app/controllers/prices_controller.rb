class PricesController < ApplicationController
  def delete_all
    Price.delete_all
    PriceView.clear!

    redirect_to root_path
  end
end
