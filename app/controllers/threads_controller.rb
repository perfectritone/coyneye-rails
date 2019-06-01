class ThreadsController < ApplicationController
  def reset
    PoloniexFeedSubscriber.reset

    redirect_to root_path
  end
end
