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
end

