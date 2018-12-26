require_relative 'lib/connect_four'

namespace :connect_four do

  desc 'Start connect four game'
  task :start, [:row, :col] do |_t, args|
    puts "args: #{args}"
    connect_four = ConnectFour.new(args[:row].to_i, args[:col].to_i)
    connect_four.start
  end
end
