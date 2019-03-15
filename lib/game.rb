require_relative 'cell'
require_relative 'board'
require_relative 'game_error'
require_relative 'scanner'
require_relative 'player'
require 'logger'
# frozen_string_literal: true

module ConnectFour

  # class that implements connected four game stat
  class Game

    attr_reader :rows, :columns, :last_played_cell
    attr_accessor :last_player, :move_counter, :game_over, :winner

    # @param rows [Integer] number of board rows
    # @param columns [Integer] number of board columns
    def initialize(rows: 6, columns: 7, logger: nil)
      @rows = rows
      @columns = columns
      @logger = logger || Logger.new(STDOUT)
      @game_board = Board.new(rows: rows, columns: columns, logger: @logger)
      @game_result_file = 'game_result'
      @game_over = false
      @move_counter = 0
    end

    # start the game
    def play(auto: true)
      player1 = Player.new(board: @game_board, colour: ConnectFour::Settings::RED, id: '1', logger: @logger)
      player2 = Player.new(board: @game_board, colour: ConnectFour::Settings::WHITE, id: '2', logger: @logger)

      if auto
        start_auto_mode(player1, player2)
      else
        start_manual_mode(player1, player2)
      end
      @logger.info 'Game had no winner!' unless game_over
    end

    def read_game_result
      File.open(@game_result_file) do |file|
        file.seek(0)
        file.read
      end
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
      @scanner ||= Scanner.new(board: @game_board, logger: @logger)
    end

    def start_auto_mode(player1, player2)
      until game_over
        @move_counter += 1
        auto_play(player1) unless game_over
        auto_play(player2) unless game_over
      end
      announce_winner
    end

    def start_manual_mode(player1, player2)
      until game_over
        @move_counter += 1
        manual_play(player1) unless game_over
        manual_play(player2) unless game_over
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
        @logger.debug "player#{player.id} played - continue"
      end
    end

    def manual_play(player)
      write_game_result
      column_to_play = nil
      @last_player = player

      loop do
        puts "Player#{player.id} turn: enter the column number to play (between 1 - #{@columns})"
        column_to_play = STDIN.gets.chomp.to_i
        column_to_play > @columns ? next : break
      end
      @last_played_cell = player.manual_play(column_to_play - 1)

      if game_over?
        @game_over = true
        @winner = player
      else
        @logger.debug "player#{player.id} played - continue"
      end
    end

    # @param [Player] player
    def announce_winner
      write_game_result
      @logger.info "\nGAME OVER!\nWinner: Player##{winner.id} - Colour: #{winner.colour}"
    end

    def write_game_result
      result_file = File.new(@game_result_file, 'w')
      @game_board.each do |row|
        #puts(row.map(&:colour).join(' | '))
        result_file.puts(row.map(&:colour).join(' | '))
      end
      result_file.close
    end

    def game_over?
      move_counter >= ConnectFour::Settings::MAX_MOVES || \
      move_result(last_played_cell, last_player.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
    end

  end
end

