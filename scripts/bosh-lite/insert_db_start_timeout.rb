#!/usr/bin/env ruby

require 'yaml'
filename = ARGV.first
manifest = YAML::load_file(filename)
manifest['properties']['cf_mysql']['mysql']['database_startup_timeout'] = 600
File.open(filename, 'w'){|f| f.write(YAML::dump(manifest))}
