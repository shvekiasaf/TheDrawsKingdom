require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_goals_calculator"
require_relative "../../../draw_kingdom/lib/components/ds_season_calculator"

class DSLowestScoringStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 365
    else
      @since = since
    end
    @avg_away_counter = Proc.new {|all_other_team_games, from_date, due_to_date, away_team|DSSeasonCalculator.getAvgAwayTeamGoalsScored(all_other_team_games,from_date,due_to_date,away_team)}
    @avg_home_counter = Proc.new {|all_other_team_games, from_date, due_to_date, home_team|DSSeasonCalculator.getAvgHomeTeamGoalsScored(all_other_team_games,from_date,due_to_date,home_team)}
  end

  def getGrade
    @goals_calculator = DSGoalsCalculator.new(@team,
                                              @file_reader,
                                              @due_to_date - @since,
                                              @due_to_date,
                                              @stay_power,
                                              @avg_away_counter,
                                              @avg_home_counter)
    expected_goals = @goals_calculator.getGrade
    normalizeGrade(1.0/(expected_goals.zero? ? 0.000001 : expected_goals),@stay_power)
  end


end