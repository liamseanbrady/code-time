class CodeTime
  def timer(duration_in_seconds)
    raise ArgumentError, 'should be a number' unless duration_in_seconds.is_a?(Numeric)
    @start_time = Time.now
    loop do
      break if (Time.now - @start_time) == duration_in_seconds
    end
  end
end
