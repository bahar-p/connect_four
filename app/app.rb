# frozen_string_literals: true
require 'json'
require_relative '../lib/game'
require_relative '../lib/file_io'

# implements connect four application
class App
  STATUS = {
      'OK' => 200,
      'NOT FOUND' => 404,
      'BAD REQUEST' => 400,
      'SERVER ERROR' => 500
  }.freeze

  CONNECTFOUR_BASE_PATH = '/connectfour/games/'

  ROUTES = {
      '/' => :root,
      '/env' => :inspect_env,
      '/params' => :params,
      '/connectfour/games/create' => :create_game,
      # '/connectfour/games/:id/update' => :update_game
      # %r{/connectfour/games/(?<id>[A-Za-z0-9-_]*)/update} => :update_game
  }.freeze

  attr_reader :response, :request, :env, :action

  def call(env)
    @env = env
    @response = Rack::Response.new
    @request = Rack::Request.new(env)

    if ROUTES.key?(@request.path)
      send(ROUTES[@request.path])
    elsif @request.path.start_with?(CONNECTFOUR_BASE_PATH)
      begin
        game_id, @action = fetch_id_and_action_from_url

        if @action == 'update'
          update_game_status(game_id)
        elsif @action.nil?
          fetch_game_status(game_id)
        else
          not_found
        end
      rescue => e # TODO: implement custom error for game/action not found
        puts "stacktrace: \n#{e.backtrace}\n\nmessage: \n#{e.message}"
        bad_request(e.message) # should return "not found"
      end
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

  def create_game
    game = ConnectFour::Game.new(logger: Logger.new(STDOUT, level: Logger::INFO))
    FileIO.write(game.id, game.to_json)
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/plain')
    response.write("Your ConnectFour Game ID: #{game.id}")
  end

  def fetch_game_status(game_id)
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/plain')
    begin
      response.write(FileIO.read(game_id))
    rescue => e
      not_found
    end
  end


  # TODO: To be completed
  # Problem: I need a way to keep the same game instance between between http sessions
  # or store the game board status somewhere for each game
  def update_game_status(game_id)
    column_to_play = request.params['column']
    game_hash = JSON.load(FileIO.read(game_id))
    game = ConnectFour::Game.from_hash(game_hash)
    player = game.players.find { |player| player.colour == request.params['colour'] }
    game_status = game.play_web(player, column_to_play.to_i)
    response.status = STATUS['OK']
    response.set_header('Content-Type', 'text/plain')
    response.write(game_status)
  end

  def fetch_id_and_action_from_url
    url_path = @request.path.sub(CONNECTFOUR_BASE_PATH, '')
    url_parts = url_path.split('/')
    action = url_parts.length > 1 ? url_parts.last : nil
    id = url_parts.first

    if UUID.is_valid_uuid?(id) && FileIO.exist?(id)
      return id, action
    else
      raise "Invalid game id #{id}"
    end
  end

  def bad_request(message)
    response.status = STATUS['BAD REQUEST']
    response.set_header('Content-Type', 'text/plain')
    response.write("Bad Request\n\nError: #{message}")
  end

end
