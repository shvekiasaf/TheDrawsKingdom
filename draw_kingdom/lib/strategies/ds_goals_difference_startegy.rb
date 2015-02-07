require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_season_calculator"


# based on the research: "Soccer: Is scoring goals a predictable Poissonian process?"
# http://arxiv.org/pdf/1002.0797v2.pdf
# http://iopscience.iop.org/0295-5075/89/3/38007
class DSGoalsDifferenceStartegy < DSBaseStrategy

  def execute

    # calculate the opponents league points up to due_to_date
    home_team_previous_games = @file_reader.getAllGamesFor(@game.home_team, nil, @game.game_date)
    away_team_previous_games = @file_reader.getAllGamesFor(@game.away_team, nil, @game.game_date)

    home_team_season_previous_games = home_team_previous_games.select { |current_game| current_game.season.eql?(@game.season) }
    away_team_season_previous_games = away_team_previous_games.select { |current_game| current_game.season.eql?(@game.season) }

    return insufficient_data_for_strategy if (home_team_season_previous_games.size < 5 || away_team_season_previous_games.size < 5)

    home_team_goal_difference_avg = DSSeasonCalculator.getAvgTeamGoalDifference(home_team_season_previous_games, @game.home_team)
    away_team_goal_difference_avg = DSSeasonCalculator.getAvgTeamGoalDifference(away_team_season_previous_games, @game.away_team)

    return insufficient_data_for_strategy if (home_team_goal_difference_avg.nil? || away_team_goal_difference_avg.nil?)

    # giving more power to home team
    diff_avg_of_both_teams = (home_team_goal_difference_avg * 1.4) - (away_team_goal_difference_avg * 1)

    return diff_avg_of_both_teams.abs

  end

  def shouldReverseNormalization
    true
  end

end