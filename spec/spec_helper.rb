require 'rubygems'
require 'spec'

# Prefer sibling libs when running tests
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../datapathy/lib')))
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../resourceful/lib')))

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'datapathy-rfj-adapter'

require 'pp'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module Helpers
  require 'uuidtools'
  def new_uuid
    UUIDTools::UUID.random_create.to_s
  end

  def test_adapter
    Datapathy.default_adapter
  end
end

opts = {
  :backend => 'rfj.localhost',
  :username => 'dev',
  :password => 'dev'
}
Datapathy.adapters[:rfj] = Datapathy::Adapters::RfjAdapter.new(opts)

Spec::Runner.configure do |config|

  config.include(Helpers)

end
