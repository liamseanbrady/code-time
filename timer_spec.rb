require_relative 'lib/code_time/timer'

describe 'Timer' do
  describe '#start' do
    it 'records the time at which the timer begins' do
      timer = Timer.new
      expect(timer).to receive(:sleep).with(5)

      timer.start(5)

      expect(timer.start_time.sec).to be_within(1).of(Time.now.sec)
    end

    it 'limits the total duration of the timer to 2 hours maximum' do
      timer = Timer.new
      expect(timer).to receive(:sleep).with(7_200)

      timer.start(7_500)
    end
  end

  describe '#end' do
    it 'records the time at which the session ended' do
      timer = Timer.new
      expect(timer).to receive(:sleep).with(20)

      timer.end

      expect(timer.end_time).to be_within(1).of(
    end
  end
end
