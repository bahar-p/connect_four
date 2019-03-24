require 'json'
module ConnectFour
  # class that implements a cell in the board
  class Cell

    attr_accessor :colour
    attr_reader :row_number
    attr_accessor :column_number

    def initialize(row_number:, column_number:, colour: ConnectFour::Settings::EMPTY_VALUE)
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
    def marked?
      @colour != ConnectFour::Settings::EMPTY_VALUE
    end

    def as_json
      {
        colour: colour,
        row: row_number,
        column: column_number
      }
    end

    def self.from_hash(cell_hash)
      Cell.new(row_number: cell_hash['row'], column_number: cell_hash['column'], colour: cell_hash['colour'])
    end

    # def print_colour
    #   if colour == ConnectFour::Settings::RED
    #     'R'.red
    #   elsif colour == ConnectFour::Settings::WHITE
    #     'W'.white
    #   else
    #     colour
    #   end
    # end

  end
end