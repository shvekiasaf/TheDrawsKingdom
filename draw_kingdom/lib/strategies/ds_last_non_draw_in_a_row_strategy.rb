require_relative "../strategies/ds_base_strategy"

class DSLastNonDrawInARowStrategy < DSBaseStrategy

  def execute

    home_team_previous_games = @file_reader.getAllGamesFor(@game.home_team, nil, @game.game_date)
    away_team_previous_games = @file_reader.getAllGamesFor(@game.away_team, nil, @game.game_date)

    home_team_non_draw_count = get_non_draw_streak(home_team_previous_games)
    away_team_non_draw_count = get_non_draw_streak(away_team_previous_games)

    avg_streak = (home_team_non_draw_count + away_team_non_draw_count).to_f/2
    return DSHelpers.normalize_value(avg_streak,0, 10.0)
  end

  def get_non_draw_streak(games)
    non_draw_index = 0
    games.each do |current_game|

      if (current_game.isDraw())
        break
      else
        non_draw_index += 1
      end
    end
    non_draw_index
  end
end