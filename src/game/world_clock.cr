class WorldClock
  @@clock = SF::Clock.new

  def self.elapsed_time
    @@clock.elapsed_time
  end

  def self.milliseconds
    @@clock.elapsed_time.as_milliseconds
  end

  def self.seconds
    @@clock.elapsed_time.as_seconds
  end
end
