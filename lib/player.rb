# frozen_string_literal: true
require_relative 'game'
require_relative '../settings'

# this class represent connect_four game player
class Player

  attr_reader :colour
  attr_reader :number

  # @param game [Game] game game
  # @param colour [Integer] player's color on the game. Either R|W
  def initialize(game, colour, number: '1')
    raise 'player must have the game game' if game.nil?
    raise 'game must have a board' unless game.respond_to?(:board)
    @game = game
    @colour = colour
    @number = number
  end

  # play action or nil if no move made
  def play
    move_result = ConnectFourSettings::RESULT[:FAILED]
    attempts = 0
    begin
      move_result = @game.play(move, @colour)
    rescue GameError
      attempts += 1
      retry if attempts <= ConnectFourSettings::MAX_MOVES
    ensure
      move_result
    end

  end

  @private
  # played number on the game
  # @return [Integer] a random number in range of size of the game game
  def move
    rand(@game.size)
  end
end