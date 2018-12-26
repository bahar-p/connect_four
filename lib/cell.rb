# class that implements a cell in the board
class Cell

  attr_accessor :colour

  def initialize
    @colour = ConnectFourSettings::DEFAULT_MARK
  end

  # set the colour of the cell
  # @param colour [String] colour to mark the cell with
  def mark(colour)
    @colour = colour
  end

  # checks whether the cell is already marked
  # @param cell [Cell] the cell object in the board
  def marked?
    @colour != ConnectFourSettings::DEFAULT_MARK
  end

end