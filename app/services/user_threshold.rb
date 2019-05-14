class UserThreshold
  @@acceleration = nil

  def self.acceleration
    @acceleration
  end

  def self.acceleration=(value)
    @max = value.to_f
  end

  def self.max
    @max ||= max_record&.amount
  end

  def self.max=(value)
    @max_record = MaximumThreshold.create! amount: value

    @max = value
  end

  def self.min
    @min ||= min_record&.amount
  end

  def self.min=(value)
    @min_record = MinimumThreshold.create! amount: value

    @min = value
  end

  def self.max_met!
    max_record.update_attributes(met: true)

    @max = nil
    @max_record = nil
  end

  def self.min_met!
    min_record.update_attributes(met: true)

    @min = nil
    @min_record = nil
  end

  protected

  def self.max_record
    @max_record ||= MaximumThreshold.where(met: false).last
  end

  def self.min_record
    @min_record ||= MinimumThreshold.where(met: false).last
  end
end
