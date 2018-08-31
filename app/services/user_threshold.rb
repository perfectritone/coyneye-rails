class UserThreshold
  @@acceleration = nil
  @@max = nil
  @@min = nil

  def self.acceleration
    @@acceleration
  end

  def self.acceleration=(value)
    @@max = value.to_f
  end

  def self.max
    @@max
  end

  def self.max=(value)
    @@max = value.to_f
  end

  def self.min
    @@min
  end

  def self.min=(value)
    @@min = value.to_f
  end

  def self.reset_max
    @@max = nil
  end

  def self.reset_min
    @@min = nil
  end
end
