require 'sqlite3'

class Database
  NAME = 'code_time'

  attr_reader :connection

  def initialize
    @connection = SQLite3::Database.new(file_path, results_as_hash: true)
  end

  def add_table(table_name)
    @connection.execute("CREATE TABLE IF NOT EXISTS #{table_name} (id INT PRIMARY KEY, length INT, created_at DATETIME, description VARCHAR(255))")
  end

  def table?(table_name)
    @connection.table_info(table_name).empty?? false : true
  end

  def drop_table(table_name)
    @connection.execute("DROP TABLE IF EXISTS #{table_name}")
  end

  def eradicate
    %x(rm #{file_path})
  end

  def file_path
    "/tmp/#{NAME}_database.sqlite3"   
  end
end