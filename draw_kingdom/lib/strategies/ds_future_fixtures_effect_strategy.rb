# converted to support one game only

require_relative "../strategies/ds_base_strategy"
require_relative "../../lib/components/ds_season_calculator"
require 'date'

# this strategy calculates the similarity between teams by comparing the team points for the current season
class DSFutureFixturesEffectStrategy < DSBaseStrategy

  def initialize

  end

  def execute

    if (@all_team_games.empty?)

      return nil
    else
      current_season = @all_team_games[0].season
      current_team_league_points = DSSeasonCalculator.getTeamPoints(@all_team_games, current_season, @team)

      # get the team next game
      next_game = @file_reader.getSomeGamesForTeam(@team, @due_to_date, 1)

      if (next_game.empty?)
        return nil
      else

        # get the opponent
        opponent = next_game[0].getOpponentForTeam(@team)

        # calculate the opponents league points
        all_games_for_opponent = @file_reader.getAllGamesFor(opponent, Date.parse('01-01-1804'), @due_to_date)
        opponent_league_points = DSSeasonCalculator.getTeamPoints(all_games_for_opponent, current_season, opponent)

        # subtract current team points from opponent
        difference = (opponent_league_points - current_team_league_points).abs

        # normalize grade
        return normalizeGrade(difference, 5.0)
      end
    end

  end

  def normalizeGrade(grade, range)
    normalizeGrade = super(grade, range)

    return (normalizeGrade - 100) * -1
  end
end