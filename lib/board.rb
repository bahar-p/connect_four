require_relative 'cell'

# frozen_string_literal: true
module ConnectFour
  # class that implements connect four game board
  class Board
    include Enumerable

    attr_reader :columns
    attr_reader :rows

    # @param rows [Integer] number of board rows
    # @param columns [Integer] number of board columns
    def initialize(rows:, columns:, logger: nil, board_array: nil)
      @rows = rows
      @columns = columns
      @board =  if board_array
                  init_cells_from_array(board_array)
                else
                  init
                end
      @logger = logger || Logger.new(STDOUT)
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

    def each_cell
      board.each do |row|
        row.each do |cell|
          yield(cell)
        end
      end
    end

    def self.from_hash(board_hash)
      Board.new(rows: board_hash['rows'], columns: board_hash['columns'], \
                board_array: board_hash['cells'])
    end

    def as_json
      {
          rows: rows,
          columns: columns,
          cells: board.map { |row| row.map(&:as_json) }
      }
    end

    def to_json
      JSON.pretty_generate(as_json)
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

    # initialize game board
    def init
      Array.new(@rows) do |row|
        Array.new(@columns) do |col|
          Cell.new(row_number: row, column_number: col)
        end
      end
    end

    def init_cells_from_array(baord_array)
      baord_array.each do |row|
        row.map! do |cell_hash|
          Cell.from_hash(cell_hash)
        end
      end
      baord_array
    end

    # not used
    # def print_coloured(row)
    #   row.each do |cell|
    #     if cell.colour == ConnectFour::Settings::RED
    #       p 'R'.red
    #     elsif cell.colour == ConnectFour::Settings::WHITE
    #       p 'R'.white
    #     else
    #       p cell.colour
    #     end
    #   end
    #
    # end

  end
end