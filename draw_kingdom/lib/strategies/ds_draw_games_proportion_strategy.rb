# converted to support one game only

require_relative "../strategies/ds_base_strategy"

class DSDrawGamesProportionStrategy < DSBaseStrategy

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
      return super + "Since " + @since.to_s
    end
  end

  def execute

    games_in_range_same_teams = gamesInRangeSameTeams
    return 0 if games_in_range_same_teams.empty?
    games_with_draw = games_in_range_same_teams.select { |current_game| (not current_game.isDraw.nil?) and current_game.isDraw }.size
    draw_proportion = games_with_draw.to_f / games_in_range_same_teams.size
    DSHelpers.normalize_value(draw_proportion,0,1.0)
  end
end