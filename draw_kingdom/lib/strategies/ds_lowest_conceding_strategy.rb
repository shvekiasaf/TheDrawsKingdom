require_relative "ds_lowest_goals_base_strategy"
require_relative "../../../draw_kingdom/lib/components/ds_season_calculator"
require_relative "../components/ds_helpers"
# calculate grade based on the prediction of amount of goals the team will
# concede in the next stay_power matches.
# This strategy performs reverse normalization to the estimated amount of conceded goals
# with max value of (3 * stay_power), and spans it to [0..100]
class DSLowestConcedingStrategy < DSFewestGoalsBaseStrategy
  def initialize(since = nil)
    if(since.nil?)
      @since = 365
    else
      @since = since
    end
  end


  def get_goals_for_game(game, team_games)
    if game.home_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.away_team, @from_date, @due_to_date)
      away_team_goals_avg = DSSeasonCalculator.getAvgAwayTeamGoalsScored(all_other_team_games, @from_date, @due_to_date, game.away_team)
      home_team_goals_avg = DSSeasonCalculator.getAvgHomeTeamGoalsConceded(team_games, @from_date, @due_to_date, @team)
    elsif game.away_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.home_team, @from_date, @due_to_date)
      home_team_goals_avg = DSSeasonCalculator.getAvgHomeTeamGoalsScored(all_other_team_games, @from_date, @due_to_date, game.home_team)
      away_team_goals_avg = DSSeasonCalculator.getAvgAwayTeamGoalsConceded(team_games, @from_date, @due_to_date, @team)
    else
      msg = "#{@team.team_name} not found in game between #{game.home_team.team_name} and #{game.away_team.team_name} on date #{@due_to_date.to_s}"
      print msg
      raise msg
    end
    (away_team_goals_avg + home_team_goals_avg)/2
  end

  private :get_goals_for_game

end