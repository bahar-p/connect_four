# frozen_string_literal: true
require_relative 'board'
require_relative 'player'
require_relative 'specs'

class Game

  attr_accessor :over

  # implement connect_four game start
  def start
    board = Board.new(6,7)
    puts "board size: #{board.size} -- cells: #{board.cells}"
    p1 = Player.new(board, ConnectFour::Specs::RED)
    p2 = Player.new(board, ConnectFour::Specs::WHITE)
    counter = 0
    while counter < ConnectFour::Specs::MAX_MOVES && !over?

      p1_play = p1.play
      if !p1_play
        break
      elsif p1_play.match?(/#{ConnectFour::Specs::GAME_OVER}/)
        @over = true
        winner = p1.mark
        break
      else
        puts "player_1 played - board: #{board.cells} - counter: #{counter}"
      end

      p2_play = p2.play
      if !p2_play
        break
      elsif p2_play.match?(/#{ConnectFour::Specs::GAME_OVER}/)
        @over = true
        winner = p2.mark
        break
      else
        puts "player_2 played - board: #{board.cells} - counter: #{counter}"
      end

      counter += 1
    end

    if over?
      puts "GAME OVER! -- board: #{board.cells} -- Winner is #{winner}"
    else
      puts 'No winner'
    end
  end

  # if a player wins
  def over?
    @over || false
  end

end

game = Game.new
game.start