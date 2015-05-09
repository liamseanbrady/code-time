class CodeTime
  HELP_OPTIONS = { titles: ['start', 'help', 'history', 'timer', 
                            'pause', 'resume', 'end'],
                   descriptions: ['start a codetime session',
                       'view these options',
                       'view session history',
                       'enter your desired codetime session length',
                       'pause the current session',
                       'resume a paused session',
                       'exit the current session'] }

  attr_reader :description, :session_length, :database

  def initialize(database = Database.new)
    @database = database
  end

  def timer(duration_in_seconds)
    raise ArgumentError, 'should be a number' unless duration_in_seconds.is_a?(Numeric)
    self.session_length = duration_in_seconds
    timer_started_notification(duration_in_seconds)
    start_timer(duration_in_seconds)
  end

  def show_help
    display_help_menu
  end

  def add_description(description)
    @description = description.empty?? 'No description provided' : description
  end

  def display_session_end_message
    puts 'Summary'
    puts "Code time: #{total_session_time}"
  end

  def save(table_name)
    database.insert(table_name, id: database.next_id(table_name), length: session_length, created_at: Time.now.to_s, description: description)
  end

  private 

  attr_writer :session_length

  def total_session_time
    return "0" unless session_length >= 1

    hours, minutes_and_seconds = session_length.divmod(3600)
    minutes, seconds = minutes_and_seconds.divmod(60)

    hours = pluralize(hours, 'hour')
    minutes = pluralize(minutes, 'minute')
    seconds = pluralize(seconds, 'second')
    "#{hours} #{minutes} #{seconds}".strip
  end

  def pluralize(number, word)
    zero = Proc.new { |number| number.zero? }
    one = Proc.new { |number| number == 1 }
    many = Proc.new { |number| number > 1 }

    result =
      case number
      when zero then ''
      when one then "#{number} #{word}"
      when many then "#{number} #{word}s"
      end

    result
  end

  def to_hours(time)
    time / 60 / 60
  end

  def start_timer(duration_in_seconds)
    sleep(duration_in_seconds)
  end

  def timer_started_notification(duration_in_seconds)
    puts "The timer has started. Enjoy your #{total_session_time} of code time."
    puts "We will let you know when when the session has ended!"
    puts "You are now in a code time session (type <end> or <^c> to exit the session)"
  end

  def display_help_menu
    puts 'codetime has the following options'
    options = HELP_OPTIONS
    longest_string_length = options.values.map(&:size).max
    left_just_spaces = longest_string_length + 3
    formatted_titles = options[:titles].map { |title| title.ljust(left_just_spaces) }
    descriptions = options[:descriptions]
    help_menu = formatted_titles.zip(descriptions).map(&:join)
    puts help_menu.join("\n")
  end
end
