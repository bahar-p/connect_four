require 'json'
require_relative 'lib/game'

# implements connect four application
class App
  STATUS = {
      'OK' => 200,
      'NOT FOUND' => 404,
      'SERVER ERROR' => 500
  }.freeze

  ROUTES = {
    '/' => :root,
    '/env' => :inspect_env,
    '/params' => :params,
    '/connectfour' => :connect_four,
    '/connectfour/play' => :connect_four_play
  }.freeze

  attr_reader :response, :request, :env

  def call(env)
    @env = env
    @response = Rack::Response.new
    @request = Rack::Request.new(env)

    if ROUTES.key?(@request.path_info)
      send(ROUTES[@request.path_info])
    else
      not_found
    end

    @response
  end

  private

  def root
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/plain')
    response.write('Hello World')
  end

  def inspect_env
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'application/json')
    response.write(env.to_json)
  end

  def not_found
    response.status = STATUS['NOT FOUND']
    response.write('Not found')
  end

  def params
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'application/json')
    response.write(request.params.to_json)
  end

  def connect_four
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/html')
    response.write('<p style="color:olive;text-align:center;">welcome to connect four game</p>')
  end

  def connect_four_play
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/plain')
    auto_mode = request.params['auto'] || false
    game = ConnectFour::Game.new(logger: Logger.new(STDOUT, level: Logger::INFO))
    game.play(auto: auto_mode)
    data = game.read_game_result
    response.write(data)
  end

end
