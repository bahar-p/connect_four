require_relative 'board'
require 'logger'

class Scanner

  # @param board [Board] 2D board representing the game board
  def initialize(board, logger: nil)
    raise 'board should have colour' unless board.all? { |a| a.map(&:colour) }

    @board = board
    @rows = board.count
    @columns = board[0].count
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
  # @return [Boolean] result of scan for connected four
  # @return [Boolean] True if four consecutive marks found in the row
  def scan_row(row, mark)
    mark_count = 0
    connect_four = false
    (0...@columns).each do |c|
      if @board[row][c].colour == mark
        mark_count += 1
        if mark_count == 4
          connect_four = true
          break
        end
      else
        # reset
        mark_count = 0
      end
    end
    @logger.debug "Row scan result #{connect_four}"
    connect_four
  end

  # scan column of the board
  # @param col [Integer] played column
  # @param mark [String] player's mark
  # @return [Boolean] True if four consecutive marks found in the column
  def scan_column(col, mark)
    mark_count = 0
    connect_four = false

    (0...@rows).each do |r|
      if @board[r][col].colour == mark
        mark_count += 1
        if mark_count == 4
          connect_four = true
          break
        end
      else
        # reset
        mark_count = 0
      end

    end
    @logger.debug "Column scan result #{connect_four}"
    connect_four
  end

  # TODO: seems not working on this condition. Review the math
  # TODO: rename variables r and c
  # scan positive diameter of the board
  # @param r [Integer] played row
  # @param c [Integer] played column
  # @param mark [String] player's mark
  # @return [Boolean] True if four consecutive marks found in the diameter
  def scan_positive_diameter(r, c, mark)
    mark_count = 0
    connect_four = false

    # start of scan
    start_row = @rows - 1
    # col = -(start_row) - (-r) + c
    col = -start_row + r + c
    if col < 0
      start_col = 0
      # abs(start_col - c - r)
      start_row = c + r
    else
      start_col = col
    end

    # end of scan
    # col = 0 + r + c
    col = r + c
    end_row = 0
    if col > @columns - 1
      end_col = @columns - 1
      end_row = (end_col - c - r).abs
    else
      end_col = col
    end

    i = start_row
    j = start_col
    while i >= end_row && j <= end_col
      if @board[i][j] == mark
        mark_count += 1
        if mark_count == 4
          connect_four = true
          break
        end
      else
        mark_count = 0
      end
      i -= 1
      j += 1
    end
    @logger.debug "Pos Dia scan result #{connect_four}"

    connect_four
  end

  # scan negative diameter of the board
  # @param r [Integer] played row
  # @param c [Integer] played column
  # @param mark [String] player's mark
  # @return [Boolean] True if four consecutive marks found in the diameter
  def scan_negative_diameter(r, c, mark)
    mark_count = 0
    connect_four = false

    # start of scan
    start_row = 0
    col = start_row - r + c
    if col.negative?
      start_col = 0
      # abs(-start_col + c - r)
      start_row = c - r
    else
      start_col = col
    end


    # end of scan
    end_row = @rows - 1
    col = end_row - r + c
    if col > @columns - 1
      end_col = @columns - 1
      end_row = (-start_col + c - r).abs
    else
      end_col = col
    end

    i = start_row
    j = start_col
    while i <= end_row && j <= end_col
      if @board[i][j].colour == mark
        mark_count += 1
        if mark_count == 4
          connect_four = true
          break
        end
      else
        mark_count = 0
      end
      i += 1
      j += 1
    end

    @logger.debug "Neg Dia scan result #{connect_four}"
    connect_four
  end

end