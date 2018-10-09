class ThresholdsController < ActionController::Base
  def max
    max_threshold = params[:threshold].to_f

    UserThreshold.max = max_threshold

    redirect_to "/"
  end

  def min
    min_threshold = params[:threshold].to_f

    UserThreshold.min = min_threshold

    redirect_to "/"
  end

  def staggered
    price, deviance = ['price_on_load', 'deviance'].map { |k| params[k].to_f }

    UserThreshold.max = price + deviance
    UserThreshold.min = price - deviance

    redirect_to "/"
  end
end

