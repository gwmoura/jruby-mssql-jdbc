#!/usr/bin/env jruby

# include JDBC MSSQL adapter for ActiveRecord
require 'activerecord-jdbcmssql-adapter'

# include Microsoft JDBC Driver for SQL Server
require 'sqljdbc4.jar'

# define hash of connection properties
config = {
  url: 'jdbc:sqlserver://localhost;databaseName=test',
  adapter: 'jdbcmssql',
  username: 'sa',
  password: 'sql2008',
  driver: 'com.microsoft.sqlserver.jdbc.SQLServerDriver',
}

# establish connection
ActiveRecord::Base.establish_connection( config )

# define model and inherit from ActiveRecord Base
class Employer < ActiveRecord::Base
  # override table name as necessary
  self.table_name = 'empregadores'
  self.primary_key = 'id'
end

# query model table, examples:
employers = Employer.all

employers.each do |e|
  puts e.email
  puts "\n"
end

#puts e.nm_razao
=begin
Employer.where(nr_insc: '33829177000154')
=end
# fetch a list of tables form the database
sql = "SELECT * FROM information_schema.tables"
results = ActiveRecord::Base.connection.execute sql

# iterate over list and collect table names
table_list = results.each_with_object([]) do |r, obj|
  next unless r['TABLE_CATALOG'] == 'test'
  next unless r['TABLE_TYPE'] == 'BASE TABLE'
  obj << r['TABLE_NAME']
end

# iterate over tables and dynamically create an object that inherits from ActiveRecord::Base
table_list.each do |table|

  klass = Object.const_set table.capitalize, Class.new(ActiveRecord::Base)
  klass.class_eval {
    self.table_name = table
  }

end

sql = "SELECT * FROM empregadores"
results = ActiveRecord::Base.connection.execute sql

results.each do |r|
  puts r
  puts "\n"
end

=begin
# query model..
Employer.first
=end