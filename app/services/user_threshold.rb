class UserThreshold
  @@max = nil

  def self.max
    @@max
  end

  def self.max=(value)
    @@max = value.to_f
  end

  def self.reset_max
    @@max = nil
  end
end
