class LevelsController < ActionController::Base
  def increase
    max_threshold = params[:level].to_f

    UserThreshold.max = max_threshold

    redirect_to "/"
  end
end
