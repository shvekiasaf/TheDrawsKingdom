# converted to support one game only

require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_season_calculator"
require 'date'

# this strategy calculates the similarity between teams by comparing the team points for the current season
class DsShortestDistanceInTableStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 700
    else
      @since = since
    end
  end


  def execute


    # season is derived from the due_to_date value
    current_season = @game.game_date.year.to_s[2,3]

    # calculate the opponents league points up to due_to_date
    home_team_previous_games = @file_reader.getAllGamesFor(@game.home_team, @game.game_date - @since, @game.game_date)
    away_team_previous_games = @file_reader.getAllGamesFor(@game.away_team, @game.game_date - @since, @game.game_date)
    home_team_league_points = DSSeasonCalculator.getTeamPoints(home_team_previous_games, current_season, @game.home_team)
    away_team_league_points = DSSeasonCalculator.getTeamPoints(away_team_previous_games, current_season, @game.away_team)

    # subtract current team points from opponent
    difference = (home_team_league_points - away_team_league_points).abs

    # todo why limit ourselves to range 5???
    # normalize grade
    DSHelpers.reverse_normalize_value(difference,0,20,100.0)
  end

end