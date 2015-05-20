class SessionRepository
  attr_reader :adapter, :session_factory

  def initialize(adapter, session_factory)
    @adapter = adapter
    @session_factory = session_factory
  end

  def all
    sessions = adapter.all
    return [] if sessions.empty?
    sessions.map do |session_attributes|
      session_factory.make(session_attributes)
    end
  end

  def store(session)
    adapter.save(session)
  end

  def find_by_length(seconds)
    sessions = adapter.find_by_length(seconds)
    sessions.map do |session_attributes|
      session_factory.make(session_attributes)
    end
  end
end
