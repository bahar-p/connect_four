# frozen_string_literal: true

require_relative 'board'
require 'logger'

module ConnectFour
  # class that implements scanner for connected four game
  class Scanner

    # @param board [Board] 2D board representing the game board
    def initialize(board:, logger: nil)
      raise 'board cells should respond to colour' unless board.all? { |a| a.map(&:colour) }

      @board = board
      @logger = logger || Logger.new(STDOUT)
    end


    # scan the diameter, row and column the cell belong to in the board for connected_vfour
    def found_connected_four?(cell, colour)
      row = cell.row_number
      column = cell.column_number
      scan_row(row, colour) || scan_column(column, colour) || \
        scan_negative_diameter(row, column, colour) || \
        scan_positive_diameter(row, column, colour)
    end

    private

    # scan column of the board
    # @param row [Integer] played row
    # @param mark [String] player's mark
    # @return [Boolean] result of scan for connected four in the row
    def scan_row(row, mark)
      has_connected_four?(@board[row], mark)
    end

    # scan column of the board
    # @param played_column [Integer] played column
    # @param mark [String] player's mark
    # @return [Boolean] result of scan for connected four in the column
    def scan_column(played_column, mark)

      mirrored_array = Array.new(@board.rows)
      @board.each_with_index do |row, index|
        mirrored_array[index] = row[played_column].colour
      end

      has_connected_four?(mirrored_array, mark)
    end

    # scan positive diameter of the board
    # @param played_row [Integer] played row
    # @param played_column [Integer] played column
    # @param mark [String] player's mark
    # @return [Boolean] True if four consecutive marks found in the diameter
    def scan_positive_diameter(played_row, played_column, mark)

      mirrored_array = Array.new(@board.rows)

      column = played_column
      played_row.downto(0) do |row|
        mirrored_array[row] = @board[row][column].colour
        column < @board.columns - 1 ? column += 1 : break
      end

      column = played_column
      (played_row...@board.rows).each do |row|
        mirrored_array[row] = @board[row][column].colour
        column > 0 ? column -= 1 : break
      end

      has_connected_four?(mirrored_array, mark)
    end

    # scan negative diameter of the board
    # @param played_row [Integer] played row
    # @param played_column [Integer] played column
    # @param mark [String] player's mark
    # @return [Boolean] True if four consecutive marks found in the diameter
    def scan_negative_diameter(played_row, played_column, mark)

      mirrored_array = Array.new(@board.rows)

      column = played_column
      played_row.downto(0) do |row|
        mirrored_array[row] = @board[row][column].colour
        column > 0 ? column -= 1 : break
      end

      column = played_column
      (played_row...@board.rows).each do |row|
        mirrored_array[row] = @board[row][column].colour
        column < @board.columns - 1 ? column += 1 : break
      end

      has_connected_four?(mirrored_array, mark)
    end


    # scan whether array has four consecutive mark
    # @param [Array] array to scan
    # @param [String] mark to scan for
    def has_connected_four?(array, mark)
      connected_four = false
      mark_count = 0

      (0...array.length).each do |i|
        if array[i] == mark || (array[i].respond_to?(:colour) && array[i].colour == mark)
          mark_count += 1
          if mark_count == 4
            connected_four = true
            break
          end
        else
          # reset
          mark_count = 0
        end
      end
      connected_four
    end

  end
end