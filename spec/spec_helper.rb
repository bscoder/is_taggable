$:.unshift File.expand_path('../lib', __FILE__)

require 'is_taggable'

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

  conf.before(:all, :with_active_record) do |example|
    require 'support/active_record'
  end
  conf.around(:each, :with_active_record) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
