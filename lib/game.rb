# frozen_string_literal: true
require_relative 'board'
require_relative 'player'
require_relative '../settings'

class Game

  attr_accessor :over

  def initialize(row, column)
    @row = row
    @column = column
  end

  # start the game
  def start
    over = false
    board = Board.new(@row, @column)
    p1 = Player.new(board, ConnectFour::RED)
    p2 = Player.new(board, ConnectFour::WHITE)

    counter = 0
    while counter < ConnectFour::MAX_MOVES

      p1_result = p1.play
      if p1_result.nil?
        break
      elsif p1_result == ConnectFour::RESULT[:GAME_OVER]
        over = true
        winner = p1.mark
        break
      else
        puts "player_1 played - counter: #{counter}"
      end

      p2_result = p2.play

      if p2_result.nil?
        break
      elsif p2_result == ConnectFour::RESULT[:GAME_OVER]
        over = true
        winner = p2.mark
        break
      else
        puts "player_2 played - counter: #{counter}"
      end

      counter += 1
    end

    if over
      (0...6).each do |i|
        p board.cells[i].map(&:colour)
      end
      puts "GAME OVER! -- Winner is #{winner}"
    else
      puts 'Game has no winner!'
    end
  end

end