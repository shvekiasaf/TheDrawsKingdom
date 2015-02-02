require 'singleton'
class InsufficientDataManager
  include Singleton

  def initialize
    @insufficient_games_hash = Hash.new
  end

  def increment_insufficient_game(game,strategy)
    if insufficient_games_hash.key?game
      insufficient_games_hash[game].push(strategy)
    else
      insufficient_games_hash[game] = [strategy]
    end
  end

  def get_number_of_insufficient_grades(game)
    if insufficient_games_hash.key?game
      return insufficient_games_hash[game].size
    else
      return 0
    end
  end
end