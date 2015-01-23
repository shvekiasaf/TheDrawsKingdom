require_relative "ds_file_reader"
require_relative "ds_simulations_runner"
require_relative '../../lib/strategies/ds_teams_draw_ratio_strategy'
require_relative '../../../draw_kingdom/lib/strategies/ds_lowest_scoring_strategy'
require_relative '../../../draw_kingdom/lib/strategies/ds_lowest_conceding_strategy'
require_relative '../../lib/strategies/ds_score_predictor_strategy'
require_relative '../../lib/strategies/ds_bet365_draw_odds_strategy'
require_relative '../../lib/strategies/ds_fewest_goals_in_game_strategy'
require_relative '../../lib/strategies/ds_draws_in_season_time_window_strategy'
require_relative '../../lib/strategies/ds_common_draw_score_strategy'

class DSSimulationsGenerator

  def self.get_simulations_array

    simulations0 = [DSStrategyValue.new(DSBet365DrawOddsStrategy.new(800), 1.0)]


    simulationsAll = [DSStrategyValue.new(DSDrawGamesProportionStrategy.new(500), 3.0),
                      DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 1.0),
                      DSStrategyValue.new(DSFutureFixturesEffectStrategy.new, 3.0),
                      # todo this is still not popoulated
                      # DSStrategyValue.new(DSBet365DrawOddsStrategy.new(800), 1.0),
                      DSStrategyValue.new(DSScorePredictorStrategy.new,10),
                      DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil),1.0),
                      DSStrategyValue.new(DSDrawsInSeasonTimeWindowStrategy.new,2.0),
                      DSStrategyValue.new(DSCommonDrawScoreStrategy.new,2.0)]

    simulations1 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                    DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                    DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                    DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 15.0),
                    DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 5.0)]

    # simulations2 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 17.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 3.0)]
    #
    # simulations3 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 75.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 25.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 900.0)]
    #
    # simulations4 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 3.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 15.0)]
    #
    # simulations5 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 4.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 1.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 5.0)]
    #
    # simulations6 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 1.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 1.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 1.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 1.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 0.0),
    #                 DSStrategyValue.new(DSArrivalsStrategy.new, 1.0)]
    #
    # simulations7 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 1.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 1.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 1.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 0.0),
    #                 DSStrategyValue.new(DSArrivalsStrategy.new, 1.0)]
    #
    # simulations8 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 1.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 1.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                 DSStrategyValue.new(DSArrivalsStrategy.new, 1.0)]
    #
    # simulations9 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 1.0),
    #                 DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                 DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 0.0),
    #                 DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                 DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                 DSStrategyValue.new(DSArrivalsStrategy.new, 2.0)]
    #
    #
    # simulations10 = [DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 10.0),
    #                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 1.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 3.0),
    #                  DSStrategyValue.new(DSFewestGoalsInGameStrategy.new, 5.0),
    #                  DSStrategyValue.new(DSScorePredictorStrategy.new, 5.0),
    #                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                  DSStrategyValue.new(DSArrivalsStrategy.new, 2.0)]
    #
    # simulations11 = [DSStrategyValue.new(DSScorePredictorStrategy.new, 10.0),
    #                  DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 5.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 17.0),
    #                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 3.0)]
    #
    # simulations12 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 1.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 1.0),
    #                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                  DSStrategyValue.new(DSArrivalsStrategy.new, 1.0),
    #                  DSStrategyValue.new(DSScorePredictorStrategy.new, 1.0)]
    # simulations13 = [DSStrategyValue.new(DSLowestScoringStrategy.new(nil), 6.0),
    #                  DSStrategyValue.new(DSLowestConcedingStrategy.new(nil), 6.0),
    #                  DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 1.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 17.0),
    #                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 3.0)]
    #
    # simulations14 = [DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 1.0),
    #                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 0.0),
    #                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                  DSStrategyValue.new(DSArrivalsStrategy.new, 2.0)]
    #
    # allStrategies = [DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 1.0),
    #                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
    #                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 0.0),
    #                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 2.0),
    #                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 1.0),
    #                  DSStrategyValue.new(DSArrivalsStrategy.new, 2.0),
    #                  DSStrategyValue.new(DSLowestScoringStrategy.new(nil), -6.0),
    #                  DSStrategyValue.new(DSLowestConcedingStrategy.new(nil), -6.0)]

    all_simulations = [simulationsAll]
    # all_simulations = [allStrategies]

    return all_simulations
  end
end