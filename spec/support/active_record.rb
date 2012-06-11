require 'active_record'

ActiveRecord::Migration.verbose = false

#ActiveRecord::Base.establish_connection(:adapter => defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3', :database => ':memory:')
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

load 'support/schema.rb'
