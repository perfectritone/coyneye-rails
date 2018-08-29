require 'net/https'

class Pushover
  def notify(message)
    req = Net::HTTP::Post.new(path)
    req.set_form_data(
      form_data.merge(message: message)
    )

    res = Net::HTTP.new(host, port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start { |http| http.request(req) }
  end

  private

  def form_data
    {
      token: ENV['PUSHOVER_TOKEN'],
      user: ENV['PUSHOVER_USER'],
    }
  end

  def host
    url.host
  end

  def path
    url.path
  end

  def port
    url.port
  end

  def url
    @url ||= URI.parse("https://api.pushover.net/1/messages.json")
  end
end
