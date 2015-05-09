require_relative 'database'

describe 'Database' do
  describe '#new' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'creates a new database file' do
      Database.new

      expect(File.exist?('/tmp/code_time_database.sqlite3')).to eq(true)
    end
  end

  describe '#add_table' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'adds a table if it does not already exist' do
      table_name = 'sessions'
      db.add_table(table_name)

      expect(db.table?(table_name)).to eq(true)
    end

    it 'adds a table with primary keys only if no schema is given'
    it 'does raises an error if the table already exists'
  end

  describe '#drop_table' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'drops the table if it exists' do
      table_name = 'sessions'
      db.add_table(table_name)

      db.drop_table(table_name)

      expect(db.table?(table_name)).to eq(false)
    end

   #it 'does not attempt to drop the table if table already exists'
  end

  describe '#table?' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'returns true if the table exists in the database' do
      table_name = 'test_table'
      db.connection.execute("CREATE TABLE #{table_name} (number INT)")
      
      expect(db.table?(table_name)).to eq(true)
      db.connection.execute("DROP TABLE #{table_name}")
    end

    it 'returns false if the table does not exist in the database' do
      table_name = 'test_table'
      
      expect(db.table?(table_name)).to eq(false)
    end
  end

  describe '#eradicate' do
    it 'removes the database file from the system' do
      db = Database.new
      db.eradicate

      expect(File.exist?(db.file_path)).to eq(false)
    end
  end

  describe '#all_rows' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'returns a hash inside an array for the given name if there is only one row' do
      table_name = 'sessions'
      db.add_table(table_name)
      db.connection.execute('INSERT INTO sessions (id, length, created_at, description) VALUES (?, ?, ?, ?)', [db.next_id(table_name), 100, Time.now.to_s, 'test'])
     
      expect(db.all_rows(table_name)).to be_a Array
      expect(db.all_rows(table_name).first.keys).to include('length')
    end

    it 'returns a multiple hashes inside an array for the given name when multiple rows are present' do
      table_name = 'sessions'
      db.add_table(table_name)
      db.connection.execute('INSERT INTO sessions (id, length, created_at, description) VALUES (?, ?, ?, ?)', [db.next_id(table_name), 100, Time.now.to_s, 'test'])
      db.connection.execute('INSERT INTO sessions (id, length, created_at, description) VALUES (?, ?, ?, ?)', [db.next_id(table_name), 200, Time.now.to_s, 'test two'])
     
      expect(db.all_rows(table_name)).to be_a Array
      expect(db.all_rows(table_name).size).to eq(2)
    end

    it 'returns an empty array if the table exists but has now rows' do
      table_name = 'sessions'
      db.add_table(table_name)

      expect(db.all_rows(table_name)).to eq([])
    end

    it 'returns nil if no table exists for the given name' do
      table_name = 'sessions'
     
      expect(db.all_rows(table_name)).to be_nil
    end
  end

  describe '#insert' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'inserts a new blank row into a table with the given name' do
      table_name = 'sessions'
      db.add_table(table_name)
      db.insert(table_name)

      expect(db.all_rows(table_name)).not_to be_empty
    end

    it 'persists the session data to the database' do
      table_name = 'sessions'
      db.add_table(table_name)
      db.insert(table_name, id: db.next_id(table_name), length: 100, created_at: Time.now.to_s, description: 'Test session')

      expect(db.row_for_id(table_name, 1)['description']).to eq('Test session')
    end

    it 'inserts a new full row into a table with the given name and keywords' do

    end
  end

  describe '#row_for_id' do
    let(:db) { Database.new }
    after do
      db.eradicate
    end

    it 'returns a hash from the database for the row with a given id' do
      table_name = 'sessions'
      db.add_table(table_name)
      db.connection.execute('INSERT INTO sessions (id, length, created_at, description) VALUES (?, ?, ?, ?)', [db.next_id('sessions'), 200, Time.now.to_s, 'test'])
      
      expect(db.row_for_id(table_name, 1)).to be_a Hash
      expect(db.row_for_id(table_name, 1).keys).to include('length')
    end

    it 'returns nil if no row matches the given id' do
      table_name = 'sessions'
      db.add_table(table_name)
      
      expect(db.row_for_id(table_name, 0)).to be_nil
    end
  end
end
