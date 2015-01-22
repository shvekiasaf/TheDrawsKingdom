# converted to support one game only

require_relative "../strategies/ds_base_strategy"

# todo what does this strategy return? it currently returns (sum of draw odds for team) / (number of games)
# todo why not just return the value of current_game.b365_draw_odds
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

    # todo why?? aren't we already getting this from @all_team_games?
    # todo why Date.today??
    # games_in_range = @all_team_games.select{|current_game| current_game.game_date.to_datetime > Date.today-@since }

    # todo if anything, the query should be
    games_in_range = @all_team_games.select{|current_game|(not current_game.b365_draw_odds.nil?) and (current_game.b365_draw_odds.to_f.zero?)}
    games_in_range.each do |current_game|
      game_index += 1
      odds_summary += current_game.b365_draw_odds.to_f
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