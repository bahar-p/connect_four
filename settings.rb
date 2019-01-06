# frozen_string_literal: true
# Game settings
module ConnectFour
  module Settings
    RED = 'R'
    WHITE = 'W'
    RESULT = { FAILED: 0, GAME_OVER: 1, CONTINUE: 2 }.freeze
    MAX_MOVES = 43
    EMPTY_VALUE = '0'
  end
end