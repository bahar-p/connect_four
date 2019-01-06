# frozen_string_literal: true
require_relative 'game'
require_relative '../settings'
require 'logger'

# this class represent connect_four game player
class Player

  attr_reader :colour
  attr_reader :number

  # @param game [Board] game board
  # @param colour [Integer] player's color on the game. Either R|W
  def initialize(board, colour, number: '1', logger: nil)
    raise 'player must have the game board' if board.nil?

    @board = board
    @colour = colour
    @number = number
    @logger = logger || Logger.new(STDOUT)
  end


  # play action
  def auto_play
    move_result = ConnectFour::Settings::RESULT[:FAILED]
    attempts = 0
    begin
      move_result = @board.colour(column_to_play, @colour)
    rescue GameError
      attempts += 1
      retry if attempts <= ConnectFour::Settings::MAX_MOVES
    ensure
      move_result
    end
  end

  def manual_play(column)
    move_result = ConnectFour::Settings::RESULT[:FAILED]
    begin
      move_result = @board.colour(column, @colour)
    rescue GameError
      @logger.warn 'cell is already coloured'
    ensure
      move_result
    end
  end

  private
  # column to play in
  # @return [Integer] a random number in range of size of the game game
  def column_to_play
    rand(@board.columns) % @board.columns
  end
end