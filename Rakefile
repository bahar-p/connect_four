require_relative 'lib/game'
require 'logger'

namespace :connect_four do

  desc 'Start connect four game'
  task :start, [:row, :col, :auto, :log_level] do |_t, args|
    args.with_defaults(auto: 'true', log_level: Logger::INFO)

    logger = Logger.new(STDOUT)
    logger.level = args[:log_level]
    game = Game.new(rows: args[:row].to_i, columns: args[:col].to_i, logger: logger)
    game.start(auto: to_bool(args[:auto]))
  end
end

private

def to_bool(string)
  if string =~ /true/
    true
  elsif string =~ /false/
    false
  end
end
