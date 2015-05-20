require './lib/code_time/session_repository'

class AdapterDouble
  def sessions
    @sessions ||= []
  end

  def save(session)
    sessions << session
  end

  def all
    sessions
  end

  def find_by_length(seconds)
    sessions.reject { |session| session.length != seconds }
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
      session_repo = SessionRepository.new(AdapterDouble.new)

      expect(session_repo.all).to eq([])
    end

    it 'returns an array containing one session if one session is stored' do
      session_repo = SessionRepository.new(AdapterDouble.new)
      session = double('session')
      session_repo.adapter.save(session)
      
      expect(session_repo.all).to eq([session])
    end

    it 'returns an array containing many sessions if many sessions are stored' do
      session_repo = SessionRepository.new(AdapterDouble.new)
      session_one = double('session')
      session_two = double('session')
      session_repo.adapter.save(session_one)
      session_repo.adapter.save(session_two)
      
      expect(session_repo.all).to match_array([session_one, session_two])
    end
  end

  describe '#store' do
    it 'stores a single session' do
      session_repo = SessionRepository.new(AltAdapterDouble.new)
      session_data = { length: 5, description: 'Ruby is good', created_at: Time.now.to_s }

      session_repo.store(session_data)

      expect(session_repo.all.first).to eq({ id: 1 }.merge(session_data))
    end

    it 'stores a second session to a non-empty repository' do
      session_repo = SessionRepository.new(AltAdapterDouble.new)
      session_data_one = { length: 5, description: 'Ruby is good', created_at: Time.now.to_s }
      session_data_two = { length: 1, description: 'TDD is good', created_at: Time.now.to_s }

      session_repo.store(session_data_one)
      session_repo.store(session_data_two)

      results_collection = [{ id: 1 }.merge(session_data_one), 
                            { id: 2 }.merge(session_data_two)]

      expect(session_repo.all).to match_array(results_collection)
    end
  end

  describe '#find_by_length' do
    it 'returns an empty array if no session matches' do
      session_repo = SessionRepository.new(AltAdapterDouble.new)

      expect(session_repo.find_by_length(10)).to eq([])
    end

    it 'returns a single session in an array if one session matches' do
      session_repo = SessionRepository.new(AltAdapterDouble.new)
      matching_session = { length: 10, description: 'Ruby is good', created_at: Time.now.to_s }
      non_matching_session = { length: 20, description: 'TDD is good', created_at: Time.now.to_s }

      session_repo.store(matching_session)
      session_repo.store(non_matching_session)
     
      expect(session_repo.find_by_length(10)).to eq([{ id: 1 }.merge(matching_session)])
    end

    it 'returns many sessions in an array if many sessions match' do
      session_repo = SessionRepository.new(AltAdapterDouble.new)
      matching_session_one = { length: 10, description: 'Ruby is good', created_at: Time.now.to_s }
      non_matching_session_one = { length: 20, description: 'TDD is good', created_at: Time.now.to_s }
      matching_session_two = { length: 10, description: 'Ruby is bad', created_at: Time.now.to_s }
      non_matching_session_two = { length: 20, description: 'TDD is bad', created_at: Time.now.to_s }

      session_repo.store(matching_session_one)
      session_repo.store(non_matching_session_one)
      session_repo.store(matching_session_two)
      session_repo.store(non_matching_session_two)
     
     # Actually, we want to return a Session object here made by the SessionFactory
      expect(session_repo.find_by_length(10)).to eq([{ id: 1 }.merge(matching_session_one), { id: 3 }.merge(matching_session_two)])
    end
  end
end
