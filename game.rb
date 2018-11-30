# frozen_string_literal: true
require_relative 'board'
require_relative 'player'
require_relative 'specs'

class Game

  def start
    board = Board.new(6,7)
    puts "board size: #{board.size} -- cells: #{board.cells}"
    p1 = Player.new(board, ConnectFour::Specs::RED)
    p2 = Player.new(board, ConnectFour::Specs::WHITE)
    counter = 0
    while counter < ConnectFour::Specs::MAX_MOVES && !over

      red = p1.play
      puts "player_1 played #{red} - new board: #{board.cells}"

      white = p2.play
      puts "player_2 played #{white} - new board: #{board.cells}"
      counter += 1
    end
  end

  # if a player wins
  def over
    false
  end

end

game = Game.new
game.start