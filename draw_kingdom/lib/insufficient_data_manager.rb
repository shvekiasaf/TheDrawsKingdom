require 'singleton'
# holds the context for games with insufficient data.
# The context is held throughout a simulation, and holds the
# list of strategies that could not execute because of insufficient data per game
class InsufficientDataManager
  include Singleton

  def initialize
    # hash [game -> array[strategy ids]]
    @insufficient_games_hash = Hash.new
  end

  def increment_insufficient_game(game,strategy)
    if @insufficient_games_hash.key?game
      @insufficient_games_hash[game].push(strategy)
    else
      @insufficient_games_hash[game] = [strategy]
    end
  end

  def get_number_of_insufficient_grades(game)
    if @insufficient_games_hash.key?game
      return @insufficient_games_hash[game].uniq.size
    else
      return 0
    end
  end

  def clean
    @insufficient_games_hash = Hash.new
  end
end