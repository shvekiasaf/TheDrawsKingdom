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
      return super + "Since"
    end
  end

  def execute

    draw_index  = 0
    other_index = 0

    games_in_range = @all_team_games.select{|current_game| current_game.game_date.to_datetime > Date.today-@since }

    games_in_range.each do |current_game|

      is_draw = current_game.isDraw()
      if (!is_draw.nil?)
        if (is_draw)
          draw_index += 1
        else
          other_index += 1
        end
      end
    end

    if ((draw_index.to_i + other_index.to_i) > 0)
      proportion = draw_index.to_f / (draw_index + other_index)
    else
      proportion = 0
    end

    return normalizeGrade(proportion, 1.0)
  end
end