require_relative 'cell'
require_relative 'board'
require_relative 'game_error'
require_relative 'scanner'
require_relative 'player'
require 'logger'

# frozen_string_literal: true
# this class represents the game board
class Game

  attr_reader :rows
  attr_reader :columns

  # @param rows [Integer] number of board rows
  # @param columns [Integer] number of board columns
  def initialize(rows:, columns:, logger: nil)
    @rows = rows
    @columns = columns
    @logger = logger || Logger.new(STDOUT)
    @game_board = Board.new(rows, columns, logger: @logger)
  end

  # TODO: refactor to be shorter, this method is doing too much currently
  # TODO: refactor and modify loop - game end conditions can be all in one method/clause
  # start the game
  def start(auto: true)
    player1 = Player.new(@game_board, ConnectFour::Settings::RED, number: '1', logger: @logger)
    player2 = Player.new(@game_board, ConnectFour::Settings::WHITE, number: '2', logger: @logger)

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
    @scanner ||= Scanner.new(@game_board, logger: @logger)
  end

  def start_auto_mode(player1, player2)

    counter = 0
    loop do
      counter += 1
      break if counter >= ConnectFour::Settings::MAX_MOVES

      # player1 turn
      cell = player1.auto_play

      if move_result(cell, player1.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player1)
        exit
      else
        @logger.debug "player#{player1.number} played - continue"
      end

      # player2 turn
      cell = player2.auto_play

      if move_result(cell, player2.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player2)
        exit
      else
        @logger.debug "player#{player2.number} played - continue"
      end
    end

  end

  def start_manual_mode(player1, player2)

    counter = 0
    loop do
      counter += 1
      break if counter >= ConnectFour::Settings::MAX_MOVES

      # player1 turn
      print_board
      puts 'Player1 turn: enter the column number to play'
      column_to_play = STDIN.gets.chomp.to_i
      cell = player1.manual_play(column_to_play)

      if move_result(cell, player1.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player1)
        exit
      else
        @logger.debug "player#{player1.number} played - continue"
      end

      # player2 turn
      print_board
      puts 'Player2 turn: Enter the column number to play'
      column_to_play = STDIN.gets.chomp.to_i
      cell = player2.manual_play(column_to_play)

      if move_result(cell, player2.colour) == ConnectFour::Settings::RESULT[:GAME_OVER]
        announce_winner(player2)
        exit
      else
        @logger.debug "player#{player2.number} played - continue"
      end
    end


  end

  def announce_winner(player)
    print_board
    @logger.info "GAME OVER! -- Winner is Player##{player.number} - Colour: #{player.colour}"
  end

  def print_board
    (0...@rows).each do |i|
      p @game_board[i].map(&:colour)
    end
  end

end

