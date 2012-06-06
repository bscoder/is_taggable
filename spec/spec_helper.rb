$:.unshift File.expand_path('../lib', __FILE__)

require 'active_record'
require 'is_taggable'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |conf|
  conf.formatter = :documentation
  conf.color_enabled = true
  conf.treat_symbols_as_metadata_keys_with_true_values = true
  conf.expect_with :rspec, :stdlib
  conf.mock_with :mocha
  conf.fail_fast = false
  conf.filter_run :focus  => true
  conf.filter_run_excluding :broken => true
  conf.run_all_when_everything_filtered = true
end
