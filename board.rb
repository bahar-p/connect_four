# frozen_string_literal: true
# this class represents the game board
class Board

  # @param row [Integer] number of board rows
  # @param col [Integer] number of board columns
  def initialize(row, col)
    @rows = row
    @cols = col
  end

  # @return [Integer] game board size
  def size
    @size ||= @rows * @cols
  end

  def cells
    @cell ||= init_cells
  end

  def init_cells
    array = []
    (0...@rows).each do
      array << Array.new(@cols, '0')
    end
    array
  end

  # check the cell with specified mark
  def mark_cell(move, mark)
    r = played_row(move)
    c = played_col(move)
    if cells[r][c] == '0'
      cells[r][c] = mark
      result = win?(r, c, mark) ? ConnectFour::Specs::GAME_OVER : ConnectFour::Specs::CONTINUE
      puts "result: #{result}"
      return result
    else
      ConnectFour::Specs::FAILED_ATTEMPT
    end
  end


  # checks if player has won
  # @param row [Integer] played row number
  # @param col [Integer] played column number
  # @param mark [String] players mark on board
  # @return [Boolean] true|false depending on whether player made the last move has won
  def win?(row, col, mark)
    scan_row(row, mark) || scan_column(col, mark) || \
      scan_negative_diameter(row, col, mark) || \
      scan_positive_diameter(row, col, mark)
  end

  # scan column of the board
  # @param row [Integer] played row
  # @param mark [String] player's mark
  # @return [Boolean] result of scan for connected four
  # @return [Boolean] True if four consecutive marks found in the row
  def scan_row(row, mark)
    mark_count = 0
    connect_four = false
    (0...@cols).each do |c|
      if cells[row][c] == mark
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
    puts "Row scan result #{connect_four}"
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
      if cells[r][col] == mark
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
    puts "Column scan result #{connect_four}"
    connect_four
  end

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
    if col > @cols - 1
      end_col = @cols - 1
      end_row = (end_col - c - r).abs
    else
      end_col = col
    end

    i = start_row
    j = start_col
    while i >= end_row && j <= end_col
      if cells[i][j] == mark
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
    puts "Pos Dia scan result #{connect_four}"

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
    if col > @cols - 1
      end_col = @cols - 1
      end_row = (-start_col + c - r).abs
    else
      end_col = col
    end

    i = start_row
    j = start_col
    while i <= end_row && j <= end_col
      if cells[i][j] == mark
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

    puts "Neg Dia scan result #{connect_four}"
    connect_four
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