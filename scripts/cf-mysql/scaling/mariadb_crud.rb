require 'optparse'
require 'mysql2'

class DBTable
  attr_reader :db_name, :table_name, :client

  def initialize(ip, port, db_name, table_name)
    @db_name = db_name
    @table_name = table_name
    @client = Mysql2::Client.new(host: ip, port: port, username: 'root', password: 'password')

    client.query("create database if not exists #{db_name};")
    client.query("use #{db_name};")
    client.query("create table if not exists #{table_name} (my_val int);")
  end

  def insert_values(count)
   count.times do |value|
     client.query("insert into #{table_name} values (#{value});")
   end
  end

  def select_count
    client.query("select count(*) from #{table_name};", as: :array).first
  end

  def delete_from_table
    client.query("delete from #{table_name};")
  end
end

options = {
  host: "localhost",
  port: 3306
}

OptionParser.new do |opts|
  opts.banner = <<-HEREDOC
    Usage:
      select [--host HOST] [--port PORT]
      insert COUNT [--host HOST] [--port PORT]
      delete [--host HOST] [--port PORT]
  HEREDOC

  opts.on("-h host", "--host host", "hostname of mysql server") do |host|
    options[:host] = host
  end

  opts.on("-p port", "--port port", "port") do |port|
    options[:port] = port
  end
end.parse!

command = ARGV[0]
count = ARGV[1].to_i

db_table = DBTable.new(options[:host], options[:port], 'donor_test_db', 'donor_test')

case command
when 'insert'
  db_table.insert_values(count)
when 'delete'
  db_table.delete_from_table
when 'select'
  puts db_table.select_count
end

