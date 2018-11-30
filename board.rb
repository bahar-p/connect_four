# frozen_string_literal: true
# this class represents the game board
class Board

  # @param [Integer] number of board rows
  # @param [Integer] number of board columns
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
  def mark_cell(value, mark)
    r = played_row(value)
    c = played_col(value)
    if cells[r][c] == '0'
      cells[r][c] = mark
    else
      ConnectFour::Specs::FAILED_ATTEMPT
    end
  end

  # @return [Boolean] True if four cosecutive marks found in a row
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
    connect_four
  end

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
    connect_four
  end

  def scan_left_diameter(r,c, mark)
    mark_count = 0
    connect_four = false
    min = [r, c].min
    max = [@rows - (r + 1), @cols - (c + 1)].max
    start_row = r - min
    start_col = c - min
    end_row = r + max
    end_row = end_row > @rows - 1 ? r : end_row
    end_col = c + max
    end_col = end_col > @cols - 1 ? c : end_col
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

    connect_four
  end

  # TODO: calculation does not work, figure out the formula
  def scan_right_diameter(r,c,mark)
    mark_count = 0
    connect_four = false
    max = [@rows - (r + 1), @cols - (c + 1)].max
    start_row = r - max
    start_row = start_row < 0 ? r : start_row
    start_col = c + max
    end_row = r + max
    end_col = c - max
    end_col = end_col < 0 ? c : end_col
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