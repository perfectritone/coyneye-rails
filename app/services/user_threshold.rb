class UserThreshold
  @@max = nil

  def self.max
    @@max
  end

  def self.max=(value)
    @@max = value.to_f
  end
end
