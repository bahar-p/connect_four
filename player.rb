# frozen_string_literal: true
require_relative 'board'
require_relative 'specs'

# this class represent connect_four game player
class Player

  attr_reader :mark

  # @param board [Board] game board
  # @param mark [Integer] player's color on the board. Either R|W
  def initialize(board, mark)
    raise 'player must have the game board' if board.nil?
    raise 'board be an instance of Board' unless board.instance_of?(Board)

    @board = board
    @mark = mark

  end

  # play action or nil if no move made
  def play
    attempts = 0
    move_result = ConnectFour::Specs::FAILED_ATTEMPT
    while move_result =~ /#{ConnectFour::Specs::FAILED_ATTEMPT}/ && attempts < ConnectFour::Specs::MAX_MOVES
      move_result = @board.mark_cell(move, @mark)
      attempts += 1
    end
    if attempts >= ConnectFour::Specs::MAX_MOVES && move_result =~ /#{ConnectFour::Specs::FAILED_ATTEMPT}/
      puts "player couldn't make any move"
      return false
    else
      move_result
    end
  end

  def move
    rand(@board.size)
  end
end