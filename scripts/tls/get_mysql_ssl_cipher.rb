#!/usr/bin/env ruby

require 'json'
require 'mysql2'
require 'tempfile'

path_to_connection_file = ARGV[0]
path_to_cipher_file = ARGV[1]

raise "Argument required: </path/to/credentials.json>" if path_to_connection_file.nil?
raise "Argument required: </path/to/cipher>" if path_to_cipher_file.nil?

raise "Connection file #{path_to_connection_file} does not exist" unless File.exists?(path_to_connection_file)

temp_dir = Dir.tmpdir
puts "DEBUG: temp_dir=#{temp_dir}"

credentials = JSON.parse(File.read(path_to_connection_file))
ca_certificate_file = File.new(File.join(temp_dir, 'ca_certificate'), 'w')
ca_certificate_file.write(credentials['ca_certificate'])
ca_certificate_file.close

client = Mysql2::Client.new(
  :host => credentials['hostname'],
  :username => credentials['username'],
  :port => credentials['port'].to_i,
  :password => credentials['password'],
  :database => credentials['name'],
  :sslca => ca_certificate_file.path,
  :sslverify => true
)

query = client.query("select variable_value from information_schema.session_status where variable_name='ssl_cipher'")
cipher = query.first['variable_value']
client.close

cipher_file = File.new(path_to_cipher_file, 'w+')
cipher_file.write(cipher)
cipher_file.close
