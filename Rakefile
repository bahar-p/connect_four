require_relative 'lib/game'

namespace :connect_four do

  desc 'Start connect four game'
  task :start, [:row, :col] do |_t, args|
    game = Game.new(args[:row].to_i, args[:col].to_i)
    game.start
  end
end
