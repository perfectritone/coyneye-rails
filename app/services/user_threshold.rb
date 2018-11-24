class UserThreshold
  @@acceleration = nil

  def self.acceleration
    @@acceleration
  end

  def self.acceleration=(value)
    @@max = value.to_f
  end

  def self.max
    max_record && max_record.amount
  end

  def self.max=(value)
    MaximumThreshold.create amount: value
  end

  def self.min
    min_record && min_record.amount
  end

  def self.min=(value)
    MinimumThreshold.create amount: value
  end

  def self.max_met!
    max_record.update_attributes(met: true)
  end

  def self.min_met!
    min_record.update_attributes(met: true)
  end

  protected

  def self.max_record
    MaximumThreshold.where(met: false).last
  end

  def self.min_record
    MinimumThreshold.where(met: false).last
  end
end
