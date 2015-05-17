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
      session_repo = SessionRepository.new(AdapterDouble.new)
      session = double('session')

      session_repo.store(session)

      expect(session_repo.all.first).to eq(session)
    end
  end

  describe '#find_by_length' do
    it 'returns an empty array if no session matches' do
      session_repo = SessionRepository.new(AdapterDouble.new)

      expect(session_repo.find_by_length(10)).to eq([])
    end

    it 'returns a single session in an array if one session matches' do
      session_repo = SessionRepository.new(AdapterDouble.new)
      matching_session = double('session')
      non_matching_session = double('session')
      allow(matching_session).to receive(:length) { 10 }
      allow(non_matching_session).to receive(:length) { 20 }
      session_repo.store(matching_session)
      session_repo.store(non_matching_session)

      expect(session_repo.find_by_length(10)).to eq([matching_session])
    end

    it 'returns many sessions in an array if many sessions match' do
      session_repo = SessionRepository.new(AdapterDouble.new)
      matching_session_one = double('session')
      non_matching_session_one = double('session')
      matching_session_two = double('session')
      non_matching_session_two = double('session')

      allow(matching_session_one).to receive(:length) { 10 }
      allow(non_matching_session_one).to receive(:length) { 20 }
      allow(matching_session_two).to receive(:length) { 10 }
      allow(non_matching_session_two).to receive(:length) { 40 }
      session_repo.store(matching_session_one)
      session_repo.store(non_matching_session_one)
      session_repo.store(matching_session_two)
      session_repo.store(non_matching_session_two)

      expect(session_repo.find_by_length(10)).to match_array([matching_session_one, matching_session_two])
    end
  end
end
