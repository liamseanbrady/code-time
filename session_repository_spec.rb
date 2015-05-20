require './lib/code_time/session_repository'

class SessionDouble
  attr_reader :length, :description, :created_at

  def initialize(length:, description:, created_at:)
    @length = length
    @description = description
    @created_at = created_at
  end

  def attributes
    { length: length, description: description, created_at: created_at }
  end
end

class SessionFactoryDouble
  def make(attributes)
    SessionDouble.new(length: attributes[:length], description: attributes[:description], created_at: attributes[:created_at])
  end
end

class AltAdapterDouble
  def sessions
    @sessions ||= []
  end

  def save(session_data)
    @id ||= 1
    sessions << { id: @id }.merge(session_data)
    @id += 1
  end

  def all
    sessions
  end

  def find_by_length(seconds)
    sessions.reject { |session| session.fetch(:length) != seconds }
  end
end

describe 'SessionRepository' do
  describe '#all' do
    it 'returns an empty array if there are no sessions stored' do
      session_repo = SessionRepository.new(AltAdapterDouble.new, SessionFactoryDouble.new)

      expect(session_repo.all).to eq([])
    end

    it 'returns an array containing one session if one session is stored' do
      adapter = AltAdapterDouble.new
      session_repo = SessionRepository.new(adapter, SessionFactoryDouble.new)

      session_one = { id: 1, length: 5, description: 'Ruby is good', created_at: Time.now.to_s }

      expect(adapter).to receive(:all) { [session_one] }
      
      expect(session_repo.all.last.length).to eq(5)
    end

    it 'returns an array containing many sessions if many sessions are stored' do
      adapter = AltAdapterDouble.new
      session_repo = SessionRepository.new(adapter, SessionFactoryDouble.new)

      session_one = { id: 1, length: 5, description: 'Ruby is good', created_at: Time.now.to_s }
      session_two = { id: 2, length: 10, description: 'Ruby is bad', created_at: Time.now.to_s }

      expect(adapter).to receive(:all) { [session_one, session_two] }
      
      expect(session_repo.all.last.length).to eq(10)
    end
  end

  describe '#store' do
    it 'stores a single session' do
      session_repo = SessionRepository.new(AltAdapterDouble.new, SessionFactoryDouble.new)
      session_one = { length: 5, description: 'Ruby is good', created_at: Time.now.to_s }

      session_repo.store(session_one)

      expect(session_repo.all.count).to eq(1)
    end

    it 'stores a second session to a non-empty repository' do
      session_repo = SessionRepository.new(AltAdapterDouble.new, SessionFactoryDouble.new)
      session_one = { length: 5, description: 'Ruby is good', created_at: Time.now.to_s }
      session_two = { length: 1, description: 'TDD is good', created_at: Time.now.to_s }

      session_repo.store(session_one)
      session_repo.store(session_two)

      expect(session_repo.all.count).to eq(2)
    end
  end

  describe '#find_by_length' do
    it 'returns an empty array if no session matches' do
      session_repo = SessionRepository.new(AltAdapterDouble.new, SessionFactoryDouble.new)

      expect(session_repo.find_by_length(10)).to eq([])
    end

    it 'returns a single session in an array if one session matches' do
      adapter = AltAdapterDouble.new
      session_repo = SessionRepository.new(adapter, SessionFactoryDouble.new)
      all_sessions = [
        { id: 1, length: 10, description: 'Ruby is good', created_at: Time.now.to_s },
        { id: 2, length: 20, description: 'TDD is good', created_at: Time.now.to_s },
      ]

      allow(adapter).to receive(:sessions).and_return(all_sessions)
     
      expect(session_repo.find_by_length(10).first.description).to eq('Ruby is good')
    end

    it 'returns many sessions in an array if many sessions match' do
      adapter = AltAdapterDouble.new
      session_repo = SessionRepository.new(adapter, SessionFactoryDouble.new)
      all_sessions = [
        { id: 1, length: 10, description: 'Ruby is good', created_at: Time.now.to_s },
        { id: 2, length: 20, description: 'TDD is good', created_at: Time.now.to_s },
        { id: 3, length: 10, description: 'Ruby is bad', created_at: Time.now.to_s },
        { id: 4, length: 20, description: 'TDD is bad', created_at: Time.now.to_s }
      ]

      allow(adapter).to receive(:sessions).and_return(all_sessions)
     
      expect(session_repo.find_by_length(10).map(&:description)).to match_array(['Ruby is good', 'Ruby is bad'])
    end
  end
end
