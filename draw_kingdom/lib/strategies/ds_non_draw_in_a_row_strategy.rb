
require_relative "../strategies/ds_base_strategy"

class DSNonDrawInARowStrategy < DSBaseStrategy

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

    max_draws = 0
    index = 0

    @all_team_games.each do |current_game|

      # todo same issue with Date.today

      if (current_game.isDraw())
        if (max_draws <= index)
          max_draws = index
        end

        index = 0
      else
        index += 1
      end
    end
    DSHelpers.reverse_normalize_value(max_draws,15.0,100.0)
  end

end