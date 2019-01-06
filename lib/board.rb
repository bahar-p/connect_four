require_relative 'cell'

# frozen_string_literal: true
class Board
  include Enumerable

  attr_reader :columns
  attr_reader :rows

  # @param rows [Integer] number of board rows
  # @param columns [Integer] number of board columns
  def initialize(rows, columns, logger: nil)
    @rows = rows
    @columns = columns
    @logger = logger || Logger.new(STDOUT)
  end

  # initialize game board
  def init
    Array.new(@rows) { |row| Array.new(@columns) { |col| Cell.new(row, col) } }
  end

  # @return [Cell] coloured cell
  def colour(column, colour)
    raise GameError, ConnectFour::Settings::RESULT[:FAILED] unless has_empty_cell?(column)

    row = lowest_empty_cell(column)
    cell = board[row][column]
    cell.mark(colour)

    cell
  end

  # @return [Array<Array>] board array
  def to_a
    board.dup
  end

  def [](index)
    board[index].dup
  end

  def each
    board.each do |row|
      yield(row)
    end
  end

  private

  # enough to check last row - first row in the array
  def has_empty_cell?(column)
    board[0][column].colour == ConnectFour::Settings::EMPTY_VALUE
  end

  # finds the lowerst empty cell to drop the colour  in the board
  # @return row [Integer] row number of the lowest empty cell
  def lowest_empty_cell(column)
    (@rows - 1).downto(0) do |row|
      cell = board[row][column]
      return row unless cell.marked?
    end
  end

  # @return [Array<Cells>] board cells
  def board
    @board ||= init
  end


end