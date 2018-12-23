# frozen_string_literal: true
require_relative 'board'
require_relative '../settings'

# this class represent connect_four game player
class Player

  attr_reader :mark

  # @param board [Board] game board
  # @param mark [Integer] player's color on the board. Either R|W
  def initialize(board, mark)
    raise 'player must have the game board' if board.nil?
    raise 'board be an instance of Board' unless board.respond_to?(:cells)

    @board = board
    @mark = mark

  end

  # play action or nil if no move made
  def play

    move_result = ConnectFour::RESULT[:FAILED]
    attempts = 0
    begin
      move_result = @board.mark_cell(move, @mark)
    rescue GameError
      attempts += 1
      retry if attempts <= ConnectFour::MAX_MOVES
    ensure
      move_result
    end
    # begin
    #   @attempts ||= 0
    #   move_result = @board.mark_cell(move, @mark)
    #   if move_result == ConnectFour::RESULT[:FAILED] && @attempts < ConnectFour::MAX_MOVES
    #     @attempts += 1
    #     retry
    #   elsif @attempts >= ConnectFour::Settings::MAX_MOVES && move_result == ConnectFour::RESULT[:FAILED]
    #     puts "player couldn't make any move"
    #     false
    #   else
    #     move_result
    #   end
    # end

    # while move_result =~ /#{ConnectFour::Settings::FAILED_ATTEMPT}/ && attempts < ConnectFour::Settings::MAX_MOVES
    #   move_result = @board.mark_cell(move, @mark)
    #   attempts += 1
    # end
    # if attempts >= ConnectFour::MAX_MOVES && move_result ==ConnectFour::RESULT[:FAILED]
    #   puts "player couldn't make any move"
    #   return false
    # else
    #   move_result
    # end
  end

  @private
  # cell number of the player's move
  # @return [Integer] a random number in range of size of the game board
  def move
    rand(@board.size)
  end
end