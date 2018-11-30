# frozen_string_literal: true
require_relative 'board'
require_relative 'specs'

# this class represent connect_four game player
class Player

  # @param [Board] game board
  # @param [Integer] player's color on the board. Either R|W
  def initialize(board, mark)
    raise 'player must have the game board' if board.nil?
    raise 'board be an instance of Board' unless board.instance_of?(Board)

    @board = board
    @mark = mark

  end

  def play
    attempts = 0
    puts @board.mark_cell(move, @mark)
    while @board.mark_cell(move, @mark) =~ /ConnectFour::Specs::FAILED_ATTEMPT/ && attempts < ConnectFour::Specs::MAX_MOVES
      @board.mark_cell(move, @mark)
      attempts += 1
    end
  end

  def move
    rand(@board.size)
  end




end