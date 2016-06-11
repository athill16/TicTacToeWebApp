require_relative "../../app.rb"
 
require "capybara"
require "capybara/cucumber"
require "rspec"
 
Capybara.app = MyApp
class SomeWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end
 
World do
  SomeWorld.new
end