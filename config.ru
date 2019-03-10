require_relative 'app'

use Rack::Reloader, 1
run App.new
