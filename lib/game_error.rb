# connect four custom error on failed play attempt
class GameError < StandardError

  def initialize(msg = 'Game Error')
    super
  end
end