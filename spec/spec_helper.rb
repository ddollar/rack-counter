require 'rubygems'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rack-counter'
require 'spec'
require 'spec/autorun'

require 'json'
require 'rack/test'

class BlankApplication
  def call(env)
    return 200, {}, ['']
  end
end

Spec::Runner.configure do |config|
  
end
