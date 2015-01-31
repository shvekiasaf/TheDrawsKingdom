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

    filtered_games_array = allGamesSinceDate(gamesInRangeAtLeastOneTeamExists, @since)

    return 0 if (filtered_games_array.empty? || filtered_games_array.size < 15)

    games_with_draw = filtered_games_array.select { |current_game| (not current_game.isDraw.nil?) and current_game.isDraw }.size
    draw_proportion = games_with_draw.to_f / filtered_games_array.size

    return draw_proportion
  end
end