class LevelsController < ActionController::Base
  def increase
    threshold = params[:level].to_f

    Poloniex.maximum_threshold = threshold

    current_value = Poloniex.current_value

    if threshold < current_value
      LevelNotifier.notify(:greater_than, threshold, current_value)
    else
      LevelNotifier.subscribe(:greater_than, threshold)
    end

    redirect_to "/"
  end
end
