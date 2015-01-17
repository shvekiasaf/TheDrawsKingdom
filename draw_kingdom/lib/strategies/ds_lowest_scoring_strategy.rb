require_relative 'ds_lowest_goals_base_strategy'
class DSLowestScoringStrategy < DSFewestGoalsBaseStrategy


  def get_goals_for_game(game, team_games)
    if game.home_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.away_team, @from_date, @due_to_date)
      away_team_goals_avg = DSSeasonCalculator.getAvgAwayTeamGoalsConceded(all_other_team_games, @from_date, @due_to_date, game.away_team)
      home_team_goals_avg = DSSeasonCalculator.getAvgHomeTeamGoalsScored(team_games, @from_date, @due_to_date, @team)
    elsif game.away_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.home_team, @from_date, @due_to_date)
      home_team_goals_avg = DSSeasonCalculator.getAvgHomeTeamGoalsConceded(all_other_team_games, @from_date, @due_to_date, game.home_team)
      away_team_goals_avg = DSSeasonCalculator.getAvgAwayTeamGoalsScored(team_games, @from_date, @due_to_date, @team)
    else
      msg = "#{@team.team_name} not found in game between #{game.home_team.team_name} and #{game.away_team.team_name} on date #{@due_to_date.to_s}"
      print msg
      raise msg
    end
    (away_team_goals_avg + home_team_goals_avg)/2
  end
end