require_relative 'cell'
require_relative 'board'
require_relative 'game_error'
require_relative 'scanner'
require_relative 'player'
require_relative 'uuid'
require_relative 'file_io'
require 'logger'
# frozen_string_literal: true

module ConnectFour

  # class that implements connected four game stat
  class Game

    attr_reader :rows, :columns, :last_played_cell, :board, :turn
    attr_accessor :last_player, :move_counter, :game_over, :winner, :players, :id, :winner_message

    def initialize(id: nil, rows: 6, columns: 7, logger: nil, players_array: nil, board: nil, \
                   game_over: nil, move_counter: nil, turn: nil)
      @rows = rows
      @columns = columns
      @logger = logger || Logger.new(STDOUT)
      @board = board || Board.new(rows: rows, columns: columns, logger: @logger)
      @players = if players_array
                   add_players_from_array(players_array)
                 else
                   add_players
                 end
      @id = id || UUID.generate
      @game_over = game_over || false
      @move_counter = move_counter || 0
      @turn = turn || players_array.first['colour']
    end

    def self.from_hash(game_hash)
      Game.new(id: game_hash['id'], rows: game_hash['rows'], columns: game_hash['columns'], \
               board: ConnectFour::Board.from_hash(game_hash['board']), \
               players_array: game_hash['players'], turn: game_hash['turn'], game_over: game_hash['game_over'], \
               move_counter: game_hash['move_counter'])
    end

    def as_json
      {
        id: id,
        rows: rows,
        columns: columns,
        board: board.as_json,
        players: players.map(&:as_json),
        game_over: game_over,
        move_counter: move_counter,
        turn: turn
      }
    end

    def to_json
      JSON.pretty_generate(as_json)
    end

    def add_players
      players = []
      players << Player.new(board: @board, colour: ConnectFour::Settings::RED, logger: @logger)
      players << Player.new(board: @board, colour: ConnectFour::Settings::WHITE, logger: @logger)
      players
    end

    def add_players_from_array(players)
      players.map! do |player_hash|
        ConnectFour::Player.from_hash(player_hash, @board)
      end
      players
    end

    def play_web(player, column_to_play)
      column_to_play = column_to_play.to_i
      raise "please enter valid column in range: 0-#{columns}" if column_to_play.to_i > @columns
      raise 'Invalid player turn' if turn == player.colour
      raise 'This game is over' if game_over
      @move_counter += 1
      @last_player = player
      @turn = player.colour
      @last_played_cell = player.manual_play(column_to_play - 1)

      if game_over?
        @game_over = true
        @winner = player
        self.winner_message = announce_winner
      end
      @board = player.board
      update_status
    end

    # start the game
    def play(auto: true)
      if auto
        start_auto_mode
      else
        start_manual_mode
      end
      @logger.info 'Game had no winner!' unless game_over
    end

    # TODO: store board status
    def update_status
      game_hash = to_json
      FileIO.write(id, game_hash)
      display_status
    end

    def display_status
      string_io = StringIO.new
      @board.each do |row|
        string_io.puts(row.map(&:colour).join(' | '))
      end
      string_io.puts(winner_message) unless winner_message.nil?
      string_io.string
    end

    private

    # checks if player has won
    # @param cell [Integer] last cell played
    # @param colour [String] players colour on board
    # @return [Boolean] true|false depending on whether player made the last move has won
    def move_result(cell, colour)
      if scanner.found_connected_four?(cell, colour)
        ConnectFour::Settings::RESULT[:GAME_OVER]
      else
        ConnectFour::Settings::RESULT[:CONTINUE]
      end
    end

    def scanner
      @scanner ||= Scanner.new(board: @board, logger: @logger)
    end

    def start_auto_mode
      until game_over
        @move_counter += 1
        auto_play(players[0]) unless game_over
        auto_play(players[1]) unless game_over
      end
      announce_winner
    end

    def start_manual_mode
      until game_over
        @move_counter += 1
        manual_play(players[0]) unless game_over
        manual_play(players[1]) unless game_over
      end
      announce_winner
    end

    def auto_play(player)
      @last_player = player
      @last_played_cell = player.auto_play

      if game_over?
        @game_over = true
        @winner = player
      else
        @logger.debug "player#{player.colour} played - continue"
      end
    end

    def manual_play(player)
      update_status
      column_to_play = nil
      @last_player = player

      loop do
        puts "Player#{player.colour} turn: enter the column number to play (between 1 - #{@columns})"
        column_to_play = STDIN.gets.chomp.to_i
        column_to_play > @columns ? next : break
      end
      @last_played_cell = player.manual_play(column_to_play - 1)

      if game_over?
        @game_over = true
        @winner = player
      else
        @logger.debug "player#{player.colour} played - continue"
      end
    end

    # @param [Player] player
    def announce_winner
      "\nGAME OVER!\nWinner: Player##{winner.id} - Colour: #{winner.colour}"
    end

    def game_over?
      move_counter >= ConnectFour::Settings::MAX_MOVES || \
      move_result(last_played_cell, last_player.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
    end

    def get_status
      FileIO.read(id)
    end

  end
end

