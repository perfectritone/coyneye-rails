class PoloniexFeedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PoloniexFeedSubscriber.new.perform
  end
end
