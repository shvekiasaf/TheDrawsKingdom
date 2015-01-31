# converted to support one game only

require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_season_calculator"
require 'date'

# this strategy calculates the similarity between teams by comparing the team points for the current season
class DsShortestDistanceInTableStrategy < DSBaseStrategy

  def initialize()
  end


  def execute

    # calculate the opponents league points up to due_to_date
    home_team_previous_games = @file_reader.getAllGamesFor(@game.home_team, nil, @game.game_date)
    away_team_previous_games = @file_reader.getAllGamesFor(@game.away_team, nil, @game.game_date)

    home_team_season_previous_games = home_team_previous_games.select { |current_game| current_game.season.eql?(@game.season) }
    away_team_season_previous_games = away_team_previous_games.select { |current_game| current_game.season.eql?(@game.season) }

    # todo: maybe we should return a random number?
    return 0 if ((home_team_season_previous_games.size < 5) || (away_team_season_previous_games.size < 5))

    home_team_league_points = DSSeasonCalculator.getTeamPoints(home_team_season_previous_games, @game.season, @game.home_team)
    away_team_league_points = DSSeasonCalculator.getTeamPoints(away_team_season_previous_games, @game.season, @game.away_team)

    # subtract current team points from opponent
    difference = (home_team_league_points - away_team_league_points).abs

    return difference
  end

  def shouldReverseNormalization
    true
  end

end