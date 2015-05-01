require_relative 'code_time'

describe 'CodeTime' do
  describe '#timer' do
    it 'runs a timer for the given time' do
      code_time = CodeTime.new
      start_time = Time.now
      code_time.timer(3)
      end_time = Time.now
      timer_length = end_time - start_time
      expect(timer_length).to be_within(1.0).of(3.0)
    end

    it 'sets a default timer of 30 minutes if no input is given'

    it 'raises an error if the input is non numeric' do
      code_time = CodeTime.new
      expect { code_time.timer('5') }.to raise_error(ArgumentError)
    end

    it 'notifies the user that the timer has started and prints the duration of timer' do
    # output = File.new('/tmp/code_timer_message.txt', 'w+')
    # $stdout = output
    # code_time = CodeTime.new
    # timer_duration = 3
    # code_time.timer(timer_duration)
    # File.open('/tmp/code_timer_message.txt', 'r') do |file|
    # end
    # expect(output.join).to eq("The timer has started. Enjoy your 0.003 hours of code time.\nWe will let you know when when the session has ended!\nYou are now in a code time session (type <end> or <^c> to exit the session)")
    end

    it 'uses the correct pluralization if the duration is exactly 1 hour' do
    # code_time = CodeTime.new
    # one_hour_in_seconds = 60 * 60

    # code_time.timer(one_hour_in_seconds)
    end
  end

  describe '#pause' do
    it 'pauses the timer if there is a timer running' do
    # code_time = CodeTime.new
    # start_time = Time.now
    # code_time.timer(2)
    # code_time.pause
    end
  end
end
