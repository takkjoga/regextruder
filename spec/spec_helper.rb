require 'spork'
require 'coveralls'
Coveralls.wear!

Spork.prefork do
  require 'rspec'
  RSpec.configure do |config|
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir["./spec/support/**/*.rb"].each do |f|
    require f
  end
end
