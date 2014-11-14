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

  def getGrade

    draw_index  = 0
    other_index = 0

    @all_team_games.each do |current_game|

      if (current_game.game_date.to_datetime > Date.today-@since)

        if (current_game.isDraw())
          draw_index += 1
        else
          other_index += 1
        end
      end
    end

    if ((draw_index.to_i + other_index.to_i) > 0)
      proportion = draw_index.to_f / (draw_index.to_f + other_index.to_f)
    else
      proportion = 0
    end

    return normalizeGrade(proportion, 1.0)
  end
end