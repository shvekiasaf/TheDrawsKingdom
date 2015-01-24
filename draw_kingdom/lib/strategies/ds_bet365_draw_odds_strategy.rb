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



    gamesInRangeSameTeams.each do |current_game|

      if (not current_game.b365_draw_odds.nil?)

        game_index += 1
        odds_summary += current_game.b365_draw_odds.to_f
      end
    end

    if (game_index == 0)
      return 0
    else

      odds_avg = odds_summary / game_index

      DSHelpers.reverse_normalize_value(odds_avg,8.0,100.0)
    end
  end

end