class SessionRepository
  attr_reader :adapter, :session_factory

  def initialize(adapter, session_factory)
    @adapter = adapter
    @session_factory = session_factory
  end

  def all
    build_session_collection(all_sessions)
  end

  def store(session)
    adapter.save(session)
  end

  def find_by_length(duration)
    sessions = find_sessions_by_length(duration)
    build_session_collection(sessions)
  end

  private
  
  def all_sessions
    adapter.all
  end

  def find_sessions_by_length(duration)
    adapter.find_by_length(duration)
  end

  def build_session_collection(sessions)
    sessions.map do |session_attributes|
      build_session_with_attributes(session_attributes)
    end
  end

  def build_session_with_attributes(attributes)
    session_factory.make(attributes)
  end
end
