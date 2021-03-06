require_relative "ds_file_reader"
require_relative "ds_simulations_runner"
require_relative '../../lib/strategies/ds_teams_draw_ratio_strategy'
require_relative '../../lib/strategies/ds_score_predictor_strategy'
require_relative '../../lib/strategies/ds_bet365_draw_odds_strategy'
require_relative '../../lib/strategies/ds_draws_in_season_time_window_strategy'
require_relative '../../lib/strategies/ds_common_draw_score_strategy'
require_relative '../../lib/strategies/ds_goals_difference_startegy'

class DSSimulationsGenerator

  def self.get_simulations_array

    # bad strategy
    DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil),1.0)

    optimalSimulations = [DSStrategyValue.new(DSBet365DrawOddsStrategy.new(nil, true), 2.0),
                          DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 1.0),
                          DSStrategyValue.new(DsShortestDistanceInTableStrategy.new, 2.0)

    ]


    simulation_for_itzik = [
                            DSStrategyValue.new(DSDrawGamesProportionStrategy.new(500),1.0),
                            DSStrategyValue.new(DSBet365DrawOddsStrategy.new(nil, true), 1.0),
                            DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 1.0),
                            DSStrategyValue.new(DsShortestDistanceInTableStrategy.new, 1.0),
                            DSStrategyValue.new(DSBet365DrawOddsStrategy.new(800,false), 1.0),
                            DSStrategyValue.new(DSScorePredictorStrategy.new,1),
                            DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil),1.0),
                            DSStrategyValue.new(DSDrawsInSeasonTimeWindowStrategy.new,1.0),
                            DSStrategyValue.new(DSCommonDrawScoreStrategy.new,1.0),
                            DSStrategyValue.new(DSLastNonDrawInARowStrategy.new,1.0),
                            DSStrategyValue.new(DSTeamsDrawRatioStrategy.new, 1.0),
                            DSStrategyValue.new(DSGoalsDifferenceStartegy.new, 1.0)
                            ]


    simulations1 = [DSStrategyValue.new(DSDrawGamesProportionStrategy.new(500), 3.0),
                    DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 1.0),
                    DSStrategyValue.new(DsShortestDistanceInTableStrategy.new, 3.0),
                    DSStrategyValue.new(DSBet365DrawOddsStrategy.new(800,false), 1.0),
                    DSStrategyValue.new(DSScorePredictorStrategy.new,10),
                    DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil),1.0),
                    DSStrategyValue.new(DSDrawsInSeasonTimeWindowStrategy.new,2.0),
                    DSStrategyValue.new(DSCommonDrawScoreStrategy.new,2.0)]

    simulations2 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                    DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                    DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                    DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 15.0),
                    DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 5.0),
                    DSStrategyValue.new(DSBet365DrawOddsStrategy.new(800,true), 1.0)]

    [simulations1,simulations2,optimalSimulations,simulation_for_itzik]

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

    # all_simulations = [allStrategies]

    # return [simulations1,simulations2,optimalSimulations]
    # [optimalSimulations,simulations1,simulations2,simulation_for_itzik]

  end
end