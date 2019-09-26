desc "This task is called by the Heroku scheduler add-on"
task :reset_threads => :environment do
  PoloniexFeedSubscriber.reset
end
