# converted to support one game only

require_relative "../strategies/ds_base_strategy"

class DSBet365DrawOddsStrategy < DSBaseStrategy

  def initialize(since)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def execute

    odds_summary  = 0
    game_index    = 0

    games_in_range = @all_team_games.select{|current_game| current_game.game_date.to_datetime > Date.today-@since }

    games_in_range.each do |current_game|

      if (not current_game.b365_draw_odds.nil?)

        game_index += 1
        odds_summary += current_game.b365_draw_odds.to_f
      end
    end

    if (game_index == 0)
      return 0
    else

      odds_avg = odds_summary / game_index

      return normalizeGrade(odds_avg, 8.0)
    end
  end

  def normalizeGrade(grade, range)
    normalizeGrade = super(grade, range)

    return (normalizeGrade - 100).abs
  end

end