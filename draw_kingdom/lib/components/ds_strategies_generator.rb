require_relative '../../lib/strategies/ds_teams_draw_ratio_strategy'
require_relative '../../lib/strategies/ds_score_predictor_strategy'
require_relative '../../lib/strategies/ds_bet365_draw_odds_strategy'
require_relative '../../lib/strategies/ds_draws_in_season_time_window_strategy'
require_relative '../../lib/strategies/ds_common_draw_score_strategy'
require_relative '../../lib/strategies/ds_goals_difference_startegy'

class DSStrategiesGenerator

  def self.get_strategies_array

    # generate strategies array
    strategies = [DSBet365DrawOddsStrategy.new(nil, true),
                          DSDrawGamesProportionStrategy.new(nil),
                          DsShortestDistanceInTableStrategy.new]


    strategies
  end
end