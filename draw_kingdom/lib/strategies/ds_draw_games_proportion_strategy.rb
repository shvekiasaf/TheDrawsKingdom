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
    # todo why Date.today and not ???
    games_in_range = @all_team_games.select{|current_game| current_game.game_date.to_datetime > @due_to_date-@since }
    return 0 if games_in_range.empty?

    games_with_draw = games_in_range.select { |current_game| (not current_game.isDraw.nil?) and current_game.isDraw }.size
    draw_proportion = games_with_draw.to_f / games_in_range.size
    normalizeGrade(draw_proportion,1.0)
  end
end