# class that implements a cell in the board
class Cell

  attr_accessor :colour
  attr_reader :row_number
  attr_accessor :column_number

  def initialize(row_number, column_number, colour: ConnectFour::Settings::EMPTY_VALUE)
    @colour = colour
    @row_number = row_number
    @column_number = column_number
  end

  # set the colour of the cell
  # @param colour [String] colour to mark the cell with
  def mark(colour)
    @colour = colour
  end

  # checks whether the cell is already marked
  # @param cell [Cell] the cell object in the board
  def marked?
    @colour != ConnectFour::Settings::EMPTY_VALUE
  end

end