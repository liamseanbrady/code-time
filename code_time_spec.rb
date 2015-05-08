require_relative 'code_time'
require 'sqlite3'

class Output
  attr_reader :notification

  def write(input)
    @notification ||= []
    @notification << input
  end
end

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

    context 'with mock timer' do
      let(:output) { Output.new }
      let(:code_time) {CodeTime.new }
      before do
        class CodeTime
          def start_timer(duration)
          end
        end

        $stdout = output
      end

      it 'raises an error if the input is non numeric' do
        code_time = CodeTime.new

        expect { code_time.timer('5') }.to raise_error(ArgumentError)
      end

      it 'notifies the user that the timer has started' do
        timer_duration = 1.8

        code_time.timer(timer_duration)

        expect(output.notification.join).to eq("The timer has started. Enjoy your 1.8 seconds of code time.\nWe will let you know when when the session has ended!\nYou are now in a code time session (type <end> or <^c> to exit the session)\n")
      end

      it 'uses the correct pluralization if the duration is exactly 1 hour' do
        one_hour_in_seconds = 60 * 60

        code_time.timer(one_hour_in_seconds)

        expect(output.notification).to include('The timer has started. Enjoy your 1 hour of code time.')
      end

      it 'sets the session_length ivar' do
        timer_duration = 1.8
        code_time.timer(timer_duration)

        expect(code_time.session_length).to eq(1.8)
      end

      it 'uses the correct pluralization if the duration is between 1 and 2 hours' do
      # one_hour_in_seconds = 60 * 60
      # half_an_hour_in_seconds = 60 * 30

      # code_time.timer(one_hour_in_seconds + half_an_hour_in_seconds)

      # expect(output.notification).to include('The timer has started. Enjoy your 1.5 hours of code time.')
      end
    end
  end
  
  describe '#stop_timer' do
    let(:code_time) { CodeTime.new }

    before do
      class CodeTime
        def start_timer(duration)
        end
      end
    end

    it 'stops the timer and saves the 
  end

  describe '#pause' do
    let(:code_time) { CodeTime.new }

    before do
      class CodeTime
        def start_timer(duration)
        end
      end
    end

    it 'assigns the time passed in the current session to the start_time ivar' do
     #code_time.timer(2)
     #code_time.pause
     #
    end
    it 'assigns the time passed since pause in the current session to the pause_time ivar'
   #it 'pauses the timer if there is a timer running' do
   #  class CodeTime
   #    def start_timer(duration)
   #    end
   #  end

    # code_time = CodeTime.new
    # start_time = Time.now
    # code_time.timer(2)
    # code_time.pause
   #end
  end

  describe '#show_help' do
    let(:output) { Output.new }
    let(:code_time) {CodeTime.new }
    before do
      class CodeTime
        def start_timer(duration)
        end
      end

      $stdout = output
    end

    it 'shows the user a list of options for the CLI' do
      code_time.show_help
      options = []
      options << 'codetime has the following options'
      options << 'start     start a codetime session'
      options << 'help      view these options'
      options << 'history   view session history'
      options << 'timer     enter your desired codetime session length'
      options << 'pause     pause the current session'
      options << 'resume    resume a paused session'
      options << 'end       exit the current session'
      help_options = options.join("\n") << "\n"
      
      expect(output.notification.join).to eq(help_options)
    end
  end

  describe '#add_description' do
    it 'allows the user to add a description for their session' do
      code_time = CodeTime.new

      code_time.add_description('A good Ruby session')

      expect(code_time.description).to eq('A good Ruby session')
    end

    it 'sets a default description if given an empty string' do
      code_time = CodeTime.new

      code_time.add_description('')

      expect(code_time.description).to eq('No description provided')
    end
  end

  describe '#display_session_end_message' do
    let(:output) { Output.new }
    let(:code_time) {CodeTime.new }
    before do
      class CodeTime
        def start_timer(duration)
        end
      end

      $stdout = output
    end

    it 'displays a header' do
      timer_duration = 1.8
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Summary')
    end

    it 'displays 0 for the session length where the length is less than 1 second' do
      timer_duration = 0.8
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 0')
    end

    it 'displays the session length where the length is under a minute' do
      timer_duration = 1.8
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 1.8 seconds')
    end

    it 'displays the session length where the length is under an hour ' do
      timer_duration = 3580
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 59 minutes 40 seconds')
    end

    it 'displays the session length where the length is over an hour' do
      timer_duration = 3680
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 1 hour 1 minute 20 seconds')
    end

    it 'displays the session length where the length is 1 hour and multiple minutes and 0 seconds' do
      timer_duration = 3720
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 1 hour 2 minutes')
    end

    it 'displays the session length where the length is multiple hours and 1 minute and 0 seconds' do
      timer_duration = 7260
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 2 hours 1 minute')
    end

    it 'displays the session length where the length is multiple hours and minutes' do
      timer_duration = 7320
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 2 hours 2 minutes')
    end

    it 'displays the session length where the length is 1 hour 1 minute and 1 second' do
      timer_duration = 3661
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 1 hour 1 minute 1 second')
    end

    it 'displays the session length where the length is 1 hour multiple minutes and 1 second' do
      timer_duration = 3721
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 1 hour 2 minutes 1 second')
    end

    it 'displays the session length where the length is mulitple hours 1 minute and 1 second' do
      timer_duration = 7261
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 2 hours 1 minute 1 second')
    end

    it 'displays the session length where the length is multiple hours multiple minutes and 1 second' do
      timer_duration = 7321
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 2 hours 2 minutes 1 second')
    end

    it 'displays the session length where the length is multiple hours multiple minutes and multiple seconds' do
      timer_duration = 7322
      code_time.timer(timer_duration)

      code_time.display_session_end_message
      
      expect(output.notification).to include('Code time: 2 hours 2 minutes 2 seconds')
    end
  end

  describe '#save' do
    let(:output) { Output.new }
    let(:code_time) {CodeTime.new }
    before do
      class CodeTime
        def start_timer(duration)
        end
      end

      $stdout = output
      timer_duration = 1.8
      code_time.timer(timer_duration)
    end

    it 'persists the data for a session to the database' do
      db = SQLite3::Database.new('/tmp/codetime_db.sqlite3')
      db.execute('CREATE TABLE sessions (id INT PRIMARY KEY, length INT, created_at DATETIME, description VARCHAR(255))') if db.table_info('sessions').empty?

      code_time.add_description('Test')
      code_time.save(db)
      
      expect(db.execute('SELECT description FROM sessions WHERE _id = 1').flatten.first).to eq('Test')
      db.execute('DROP TABLE sessions') unless db.table_info('sessions').empty?
    end

    it 'persists the data for two sessions to the database' do
      db = SQLite3::Database.new('/tmp/codetime_db.sqlite3')
      db.execute('CREATE TABLE sessions (id INT PRIMARY KEY, length INT, created_at DATETIME, description VARCHAR(255))') if db.table_info('sessions').empty?

      code_time.add_description('Test')
      code_time.save(db)
      another_code_time = CodeTime.new
      timer_duration = 1.8
      another_code_time.timer(timer_duration)
      another_code_time.add_description('Test two')
      another_code_time.save(db)
      
      expect(db.execute('SELECT description FROM sessions WHERE _id = 1').flatten.first).to eq('Test')
      expect(db.execute('SELECT description FROM sessions WHERE _id = 2').flatten.first).to eq('Test two')
      db.execute('DROP TABLE sessions') unless db.table_info('sessions').empty?
    end
  end
end
