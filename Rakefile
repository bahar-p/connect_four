require_relative 'lib/game'
require 'logger'

namespace :connect_four do

  desc 'Start connect four game'
  task :start, [:row, :col, :auto, :log_level] do |_t, args|
    args.with_defaults(auto: 'true', log_level: Logger::INFO)

    logger = Logger.new(STDOUT, level: args[:log_level])
    game = ConnectFour::Game.new(rows: args[:row].to_i, columns: args[:col].to_i, logger: logger)
    game.start(auto: args[:auto].to_bool)
  end
end

class String
  def to_bool
    if self =~ /\A\s*true\s*\z/
      true
    elsif self =~ /\A\s*false\s*\z/
      false
    end
  end
end