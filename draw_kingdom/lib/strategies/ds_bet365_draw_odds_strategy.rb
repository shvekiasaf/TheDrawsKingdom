# converted to support one game only

require_relative "../strategies/ds_base_strategy"

class DSBet365DrawOddsStrategy < DSBaseStrategy

  def initialize(since, shouldCheckAllGames)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

    if (shouldCheckAllGames.nil?)
      @shouldCheckAllGames = true
    else
      @shouldCheckAllGames = shouldCheckAllGames
    end

  end

  def execute

    odds_summary  = 0
    game_index    = 0

    games_array = @shouldCheckAllGames ? gamesInRangeAtLeastOneTeamExists : gamesInRangeSameTeams

    filtered_game_array = allGamesSinceDate(games_array, @since)

    return insufficient_data_for_strategy if (filtered_game_array.empty? || filtered_game_array.size < 10)

    filtered_game_array.each do |current_game|

      if (not current_game.b365_draw_odds.nil?)

        game_index += 1
        odds_summary += current_game.b365_draw_odds.to_f
      end
    end

    if (game_index == 0)
      return insufficient_data_for_strategy
    else

      odds_avg = odds_summary / game_index

      return odds_avg
    end
  end

  def shouldReverseNormalization
    true
  end

  def strategyName
    super + "_all_games_" + @shouldCheckAllGames.to_s
  end
end