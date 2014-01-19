RSpec.configure do |config|
  # The DB will be truncated after each test run
  # This means the database tables are cleaned using the SQL TRUNCATE TABLE command. 
  # This will simply empty the table immidiately, without deleting the table structure itself.
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
  
end