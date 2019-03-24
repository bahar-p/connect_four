require_relative 'app/app'

use Rack::Reloader, 1
run App.new
