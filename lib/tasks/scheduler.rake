require 'net/http'

desc "This task is called by the Heroku scheduler add-on"
task :reset_threads => :environment do
  root_url = ENV.fetch('APP_URL')
  endpoint = '/reset_threads'
  uri = URI(root_url + endpoint)

  Net::HTTP.post(uri, {}.to_json)
end
