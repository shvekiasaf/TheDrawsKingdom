require_relative "../strategies/ds_base_strategy"

class DSBet365DrawOddsStrategy < DSBaseStrategy

  def initialize(since)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def getGrade

    odds_summary  = 0
    game_index    = 0
    odds_avg      = 999999999

    @all_team_games.each do |current_game|

      if (current_game.game_date.to_datetime > Date.today-@since)

        if (not current_game.b365_draw_odds.nil?)

          game_index += 1
          odds_summary += current_game.b365_draw_odds.to_f
        end
      end
    end

    if (game_index != 0)
      odds_avg = odds_summary  / game_index
    end

    return normalizeGrade(odds_avg, 8.0)
  end

  def normalizeGrade(grade, range)
    normalizeGrade = super(grade, range)

    return (normalizeGrade - 100) * -1
  end

end