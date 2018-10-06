class SleepinessesController < ApplicationController
  def flip
    Sleep.awake? ? Sleep.go_to_sleep : Sleep.wake_up

    redirect_to "/"
  end
end
