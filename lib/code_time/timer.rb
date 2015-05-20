class Timer
  attr_reader :start_time

  def start(duration)
    @start_time = Time.now
    duration <= 7_200 ? sleep(duration) : sleep(7_200)
  end
end
