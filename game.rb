# frozen_string_literal: true
require_relative 'board'
require_relative 'player'
require_relative 'settings'

class Game

  attr_accessor :over

  def initialize(row, column)
    @row = row
    @column = column
    @over = false
  end

  # implement connect_four game start
  def start

    board = Board.new(@row, @column)
    #puts "board size: #{board.size} -- cells: #{board.cells}"
    p1 = Player.new(board, ConnectFour::Settings::RED)
    p2 = Player.new(board, ConnectFour::Settings::WHITE)
    counter = 0
    while counter < ConnectFour::Settings::MAX_MOVES && !over?

      p1_play = p1.play
      if !p1_play
        break
      elsif p1_play.match?(/#{ConnectFour::Settings::GAME_OVER}/)
        @over = true
        winner = p1.mark
        break
      else
        puts "player_1 played - counter: #{counter}"
      end

      p2_play = p2.play
      if !p2_play
        break
      elsif p2_play.match?(/#{ConnectFour::Settings::GAME_OVER}/)
        @over = true
        winner = p2.mark
        break
      else
        puts "player_2 played - counter: #{counter}"
      end

      counter += 1
    end

    if over?
      (0...6).each do |i|
        p board.cells[i].map(&:colour)
      end
      puts "GAME OVER! -- Winner is #{winner}"
    else
      puts 'No winner!'
    end
  end

  # checks whether the game is over
  def over?
    @over
  end
end