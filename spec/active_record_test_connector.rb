# Contents of this file adapted from will_paginate
# 
# Copyright (c) 2009 Mislav Marohnić
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of 
# this software and associated documentation files (the "Software"), to deal in 
# the Software without restriction, including without limitation the rights to 
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
# the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'active_record'
require 'extlib'

class ActiveRecordTestConnector
  cattr_accessor :able_to_connect
  cattr_accessor :connected

  FIXTURES_PATH = File.expand_path('fixtures', File.dirname(__FILE__))

  # Set our defaults
  self.connected = false
  self.able_to_connect = true

  def self.setup
    unless self.connected || !self.able_to_connect
      setup_connection
      load_schema
      self.connected = true
    end
  rescue Exception => e  # errors from ActiveRecord setup
    $stderr.puts "\nSkipping ActiveRecord tests: #{e}\n\n"
    self.able_to_connect = false
  end

  private

  def self.setup_connection
    db = ENV['DB'].to_s.empty? ? 'sqlite3' : ENV['DB']

    configurations = YAML.load_file(File.expand_path('database.yml', File.dirname(__FILE__)))
    raise "no configuration for '#{db}'" unless configurations.key? db
    configuration = configurations[db]

    if $0 == 'irb'
      require 'logger'
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      puts "using #{configuration['adapter']} adapter"
    end

    ActiveRecord::Base.configurations = { db => configuration }
    ActiveRecord::Base.establish_connection(db)
  end

  def self.load_schema
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      load File.join(FIXTURES_PATH, 'schema.rb')
    end
  end
end
