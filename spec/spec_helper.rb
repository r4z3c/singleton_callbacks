require 'active_record'
require 'simplecov'
require 'support/database_connection'
require 'model_builder'

SimpleCov.start

require 'singleton_callbacks'

RSpec.configure do |config|
  config.before :all do
    Spec::Support::DatabaseConnection.establish_sqlite_connection
  end

  config.after :each do
  	ModelBuilder.clean
  end
end