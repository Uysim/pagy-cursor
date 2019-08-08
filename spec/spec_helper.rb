ENV["RAILS_ENV"] = "test"

require "dummy/config/environment"
require "rails/test_help"

require "pagy_cursor"

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
