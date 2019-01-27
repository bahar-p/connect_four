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

    attr_reader :rows
    attr_reader :columns

    # @param rows [Integer] number of board rows
    # @param columns [Integer] number of board columns
    def initialize(rows:, columns:, logger: nil)
      @rows = rows
      @columns = columns
      @logger = logger || Logger.new(STDOUT)
      @game_board = Board.new(rows: rows, columns: columns, logger: @logger)
    end

    # start the game
    def start(auto: true)
      player1 = Player.new(board: @game_board, colour: ConnectFour::Settings::RED, id: '1', logger: @logger)
      player2 = Player.new(board: @game_board, colour: ConnectFour::Settings::WHITE, id: '2', logger: @logger)

      if auto
        start_auto_mode(player1, player2)
      else
        start_manual_mode(player1, player2)
      end

      @logger.info 'Game had no winner!'

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

      counter = 0
      loop do

        counter += 1
        break if counter >= ConnectFour::Settings::MAX_MOVES

        auto_play(player1)
        auto_play(player2)
      end

    end

    def start_manual_mode(player1, player2)

      counter = 0
      loop do
        counter += 1
        break if counter >= ConnectFour::Settings::MAX_MOVES

        manual_play(player1)
        manual_play(player2)
      end


    end

    def auto_play(player)
      cell = player.auto_play

      if move_result(cell, player.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player)
        exit
      else
        @logger.debug "player#{player.id} played - continue"
      end
    end

    def manual_play(player)

      print_board
      column_to_play = nil
      loop do
        puts "Player#{player.id} turn: enter the column number to play (between 1 - #{@columns})"
        column_to_play = STDIN.gets.chomp.to_i
        column_to_play > @columns ? next : break
      end
      cell = player.manual_play(column_to_play - 1)

      if move_result(cell, player.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player)
        exit
      else
        @logger.debug "player#{player.id} played - continue"
      end
    end

    # @param [Player] player
    def announce_winner(player)
      print_board
      @logger.info "GAME OVER! -- Winner is Player##{player.id} - Colour: #{player.colour}"
    end

    def print_board
      @game_board.each do |row|
        p row.map(&:colour)
      end
    end
  end
end

