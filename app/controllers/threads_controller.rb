class ThreadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reset
    PoloniexFeedSubscriber.reset

    redirect_to root_path
  end
end
