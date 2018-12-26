require_relative 'game'
require_relative 'player'
require_relative '../settings'

class ConnectFour

  def initialize(row, column)
    @row = row
    @column = column
  end

  # start the game
  def start
    over = false
    game = Game.new(@row, @column)
    p1 = Player.new(game, ConnectFourSettings::RED, number: '1')
    p2 = Player.new(game, ConnectFourSettings::WHITE, number: '2')

    counter = 0
    while counter < ConnectFourSettings::MAX_MOVES

      p1_result = p1.play
      if p1_result.nil?
        break
      elsif p1_result == ConnectFourSettings::RESULT[:GAME_OVER]
        over = true
        winner = p1.number
        break
      else
        puts "player##{p1.number} - counter: #{counter}"
      end

      p2_result = p2.play

      if p2_result.nil?
        break
      elsif p2_result == ConnectFourSettings::RESULT[:GAME_OVER]
        over = true
        winner = p2.number
        break
      else
        puts "player##{p2.number} played - counter: #{counter}"
      end

      counter += 1
    end

    if over
      (0...6).each do |i|
        p game.board[i].map(&:colour)
      end
      puts "GAME OVER! -- Winner is Player##{winner}"
    else
      puts 'Game has no winner!'
    end
  end

end