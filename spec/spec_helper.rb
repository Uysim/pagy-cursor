ENV["RAILS_ENV"] = "test"
ENV["DB"] ||= "sqlite3"
require 'rails'
require "pagy_cursor"
require "dummy/config/environment"

ActiveRecord::Migration.verbose = false
ActiveRecord::Tasks::DatabaseTasks.drop_current 'test'
ActiveRecord::Tasks::DatabaseTasks.create_current 'test'
ActiveRecord::Migration.maintain_test_schema!


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


class TestController
  include Pagy::Backend

  attr_reader :params
end
