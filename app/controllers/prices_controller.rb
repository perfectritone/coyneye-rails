class PricesController < ApplicationController
  def delete_all
    Price.delete_all
  end
end
