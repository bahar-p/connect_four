require_relative 'cell'
require_relative 'game_error'
require_relative 'scanner'

# frozen_string_literal: true
# this class represents the game board
class Game

  attr_reader :size

  # @param row [Integer] number of board rows
  # @param col [Integer] number of board columns
  def initialize(row, col)
    @rows = row
    @cols = col
    @size = @rows * @cols
  end

  # @return [Array<Cells>] board cells
  def board
    @board ||= init_board
  end

  # initialize game board
  def init_board
    Array.new(@rows) { Array.new(@cols) { Cell.new } }
  end


  # mark board's cell with players colour
  # @param num [Integer] cell number played by player
  # @param [Object] colour
  # @return [String] result of the play
  def play(num, colour)
    r = played_row(num)
    c = played_col(num)
    cell = board[r][c]

    if cell.marked?
      raise GameError, ConnectFourSettings::RESULT[:FAILED]
    else
      cell.mark(colour)
      if connected_four?(r, c, colour)
        ConnectFourSettings::RESULT[:GAME_OVER]
      else
        ConnectFourSettings::RESULT[:CONTINUE]
      end

    end

  end

  # checks if player has won
  # @param row [Integer] played row number
  # @param col [Integer] played column number
  # @param mark [String] players mark on board
  # @return [Boolean] true|false depending on whether player made the last move has won
  def connected_four?(row, col, mark)
    scanner = Scanner.new(board)
    scanner.scan_row(row, mark) || scanner.scan_column(col, mark) || \
      scanner.scan_negative_diameter(row, col, mark) || \
      scanner.scan_positive_diameter(row, col, mark)
  end


  @private

  # @return [Integer] row number for the player's move
  def played_row(value)
    value / @cols
  end

  # @return [Integer] column number for the player's move
  def played_col(value)
    value % @cols
  end


end
