class SessionRepository
  attr_reader :adapter

  def initialize(adapter)
    @adapter = adapter
  end

  def all
    adapter.all
  end

  def store(session)
    adapter.save(session)
  end

  def find_by_length(seconds)
    adapter.find_by_length(seconds)
  end
end
