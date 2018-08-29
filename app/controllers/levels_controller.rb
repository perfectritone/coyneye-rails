class LevelsController < ActionController::Base
  def increase
    threshold = params[:level].to_f

    Poloniex.maximum_threshold = threshold

    current_value = Poloniex.current_value

    if threshold < current_value
      LevelNotifier.notify(:greater_than, threshold, current_value)
    else
      # start subscribing
    end

    redirect_to "/"
  end
end
