
require_relative "../strategies/ds_base_strategy"

class DSNonDrawInARowStrategy < DSBaseStrategy

  def initialize(since)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def strategyName
    if (@since == 999999999)
      return super
    else
      return super + "Since"
    end
  end

  def execute


    game_date = @game.game_date
    home_team_games_in_range = @file_reader.getAllGamesFor(@game.home_team, game_date - @since, game_date)
    away_team_games_in_range = @file_reader.getAllGamesFor(@game.away_team, game_date - @since, game_date)

    home_team_max_draws = max_non_draws_for_team(home_team_games_in_range)
    away_team_max_draws = max_non_draws_for_team(away_team_games_in_range)
    max_draws = [home_team_max_draws, away_team_max_draws].max
    DSHelpers.reverse_normalize_value(max_draws,0,15.0,100.0)
  end

  def max_non_draws_for_team(games_in_range)
    max_draws = 0
    index = 0
    games_in_range.each do |current_game|

      if (current_game.isDraw())
        if (max_draws <= index)
          max_draws = index
        end

        index = 0
      else
        index += 1
      end
    end
    max_draws
  end

end