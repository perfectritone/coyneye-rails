class Sleep < ApplicationRecord
  def self.awake?
    none?
  end

  def self.go_to_sleep
    create
  end

  def self.wake_up
    delete_all
  end
end
