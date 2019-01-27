# frozen_string_literal: true
require_relative 'game'
require_relative '../settings'
require 'logger'

module ConnectFour
  # this class implements the player in connect_four game
  class Player

    attr_reader :colour
    attr_reader :id

    # @param board [Board] game board
    # @param colour [Integer] player's color on the game. Either R|W
    # @param id [String] players identifier
    # @param logger [Logger] game logger
    def initialize(board:, colour:, id: '1', logger: nil)
      raise 'player must have the game board' if board.nil?

      @board = board
      @colour = colour
      @id = id
      @logger = logger || Logger.new(STDOUT)
    end


    # auto play action
    def auto_play
      attempts = 0
      begin
        played_cell = @board.colour(column_to_play, @colour)
      rescue GameError
        attempts += 1
        retry if attempts <= ConnectFour::Settings::MAX_MOVES
      ensure
        played_cell
      end
    end

    # manual play action
    # @param column [Integer] column to play
    def manual_play(column)
      @board.colour(column, @colour)
    # rescue GameError
    #   @logger.warn 'cell is already coloured'
    # ensure
    #   played_cell
    end

    private
    # column to play in
    # @return [Integer] a random number in range of size of the game game
    def column_to_play
      rand(@board.columns) % @board.columns
    end
  end
end