require_relative "../strategies/ds_base_strategy"

class DSLastNonDrawInARowStrategy < DSBaseStrategy

  def getGrade
    non_draw_index = 0

    @all_team_games.each do |current_game|

      if (current_game.isDraw())
        break
      else
        non_draw_index += 1
      end
    end

    return normalizeGrade(non_draw_index, 15.0)
  end
end