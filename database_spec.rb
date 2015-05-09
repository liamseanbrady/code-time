require_relative 'database'

describe 'Database' do
  describe '#new' do
    after do
      name = Database::NAME
      if File.exist?("/tmp/#{name}_database.sqlite3")
        IO.popen("rm /tmp/#{name}_database.sqlite3")
      end
    end

    it 'creates a new database file' do
      Database.new

      expect(File.exist?('/tmp/code_time_database.sqlite3')).to eq(true)
    end
  end

  describe '#add_table' do
    it 'adds a table if it does not already exist' do
      db = Database.new

      table_name = 'sessions'
      db.add_table(table_name)

      expect(db.table?(table_name)).to eq(true)
    end

    it 'adds a table with primary keys only if no schema is given'
    it 'does raises an error if the table already exists'
  end

  describe '#drop_table' do
   it 'drops the table if it exists' do
     db = Database.new
     table_name = 'sessions'
     db.add_table(table_name)

     db.drop_table(table_name)

     expect(db.table?(table_name)).to eq(false)
   end

   #it 'does not attempt to drop the table if table already exists'
  end

  describe '#table?' do
    it 'returns true if the table exists in the database' do
      db = Database.new

      table_name = 'test_table'
      db.connection.execute("CREATE TABLE #{table_name} (number INT)")
      
      expect(db.table?(table_name)).to eq(true)
      db.connection.execute("DROP TABLE #{table_name}")
    end

    it 'returns false if the table does not exist in the database' do
      db = Database.new

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
    it 'returns the an array for the given name if it exists' do
      db = Database.new
      table_name = 'sessions'
      db.add_table(table_name)
      db.connection.execute('INSERT INTO sessions (id, length, created_at, description) VALUES (?, ?, ?, ?)', [db.next_id, 100, Time.now.to_s, 'hello'])
     
      expect(db.all_rows(table_name)).to be_a Hash
      expect(db.all_rows(table_name).keys).to include('length')
    end
    it 'returns nil if no table exists for the given name'
  end

  describe '#insert' do
    it 'inserts a new blank row into a table with the given name' do
    # db = Database.new
    # table_name = 'sessions'
    # db.add_table(table_name)
    # db.insert(table_name)

    # expect(db.table(table_name).size).to eq(1)
    end
    it 'inserts a new full row into a table with the given name and keywords'
  end

  describe '#where_id' do
  # it 'returns a hash from the database for the row with a given id' do
  #   db = Database.new
  #   table_name = 'sessions'
  #   db.add_table(table_name)
  #   db.
  # end
  # it 'returns an empty array if no row matches the given id'
  end
end
