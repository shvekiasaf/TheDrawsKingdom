require_relative "ds_base_strategy"

class DSDrawsInSeasonTimeWindowStrategy < DSBaseStrategy
  MINIMUM_GAMES_IN_HISTORY = 2
  HALF_OF_PERIOD = 15

  def execute
    previous_games = gamesInRangeSameTeams

    return 0 if previous_games.size < MINIMUM_GAMES_IN_HISTORY
    number_of_games_ended_in_draw = previous_games.select { |game| game.isDraw }.size
    proportion = number_of_games_ended_in_draw.to_f/previous_games.size
    DSHelpers.normalize_value(proportion,0,1.0)
  end


  def game_in_date_range(game_date)
    # date.mjd is the interval of time in days and fractions of a day since January 1, 4713 BC Greenwich noon
    # then take the modulus of 365 to get rid of the difference in years
    days_between_game_dates = (game_date.mjd - @due_to_date.mjd).abs % 365
    days_between_game_dates <= HALF_OF_PERIOD
  end

  private :game_in_date_range
end