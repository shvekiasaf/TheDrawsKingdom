# converted to support one game only

require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_season_calculator"
require 'date'

# this strategy calculates the similarity between teams by comparing the team points for the current season
# todo the name of the strategy needs to be changed
class DsShortestDistanceInTableStrategy < DSBaseStrategy

  def execute

    return nil if @all_team_games.empty?

    # season is derived from the due_to_date value
    current_season = @due_to_date.year.to_s[2,3]

    # next match data
    next_game = @file_reader.getSomeGamesForTeam(@team, @due_to_date, 1)
    return nil if next_game.empty?
    # get the opponent
    opponent = next_game[0].getOpponentForTeam(@team)

    all_games_for_opponent = @file_reader.getAllGamesFor(opponent, Date.parse('01-01-1804'), @due_to_date)

    # # calculate the team league points up to due_to_date
    current_team_league_points = DSSeasonCalculator.getTeamPoints(@all_team_games, current_season, @team)

    # calculate the opponents league points up to due_to_date
    opponent_league_points = DSSeasonCalculator.getTeamPoints(all_games_for_opponent, current_season, opponent)

    # subtract current team points from opponent
    difference = (opponent_league_points - current_team_league_points).abs

    # todo why limit ourselves to range 5???
    # normalize grade
    DSHelpers.reverse_normalize_value(difference,20)
  end

  # todo don't use this. we have DSHelpers.reverse_normalize_value for this
  def normalizeGrade(grade, range)
    normalizeGrade = super(grade, range)

    return (normalizeGrade - 100) * -1
  end
end