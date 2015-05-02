class CodeTime
  def timer(duration_in_seconds)
    raise ArgumentError, 'should be a number' unless duration_in_seconds.is_a?(Numeric)
      puts "The timer has started. Enjoy your 0.003 hours of code time."
      puts "We will let you know when when the session has ended!"
      puts "You are now in a code time session (type <end> or <^c> to exit the session)"
      
    @start_time= Time.now
    loop do
      break if (Time.now - @start_time) == duration_in_seconds
    end
  end
end
