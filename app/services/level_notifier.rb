class LevelNotifier
  def self.notify(direction, threshold, current_value)
    direction = direction.to_s.humanize

    message = "USDT/ETH is #{direction} #{threshold} (#{current_value})"
    Pushover.new.notify message
  end
end
