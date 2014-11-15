require_relative 'ds_base_strategy'
require_relative '../../lib/components/ds_season_calculator'
class DSFewestGoalsInGameStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 365
    else
      @since = since
    end
  end

  def getGrade
    @from_date = @due_to_date - @since
    team_games = @file_reader.getAllGamesFor(@team, @from_date, @due_to_date + 365)
    future_games = team_games.select{|game| game.game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..(@stay_power - 1)]
    # we want enough data: at least stay_power future games and at least stay_power previous games
    return 0 if (team_games.length < (@stay_power * 2) or future_games.length < @stay_power)
    gradeForFutureGames = future_games.map { |game| getGradeForGame(game) }.reduce(:+)
    normalizeGrade(gradeForFutureGames,@stay_power)
  end

  def getGradeForGame(game)
    home_team_previous_games = @file_reader.getAllGamesFor(game.home_team, @from_date, @due_to_date)
    away_team_previous_games = @file_reader.getAllGamesFor(game.away_team, @from_date, @due_to_date)
    return 0 if away_team_previous_games.empty? or home_team_previous_games.empty?
    avg_home_team_goals_scored = DSSeasonCalculator.getAvgHomeTeamGoalsScored(home_team_previous_games, @from_date, @due_to_date, game.home_team)
    avg_home_team_goals_conceded = DSSeasonCalculator.getAvgHomeTeamGoalsConceded(home_team_previous_games, @from_date, @due_to_date, game.home_team)
    avg_away_team_goals_scored = DSSeasonCalculator.getAvgAwayTeamGoalsScored(away_team_previous_games, @from_date, @due_to_date, game.away_team)
    avg_away_team_goals_conceded = DSSeasonCalculator.getAvgAwayTeamGoalsConceded(away_team_previous_games, @from_date, @due_to_date, game.away_team)
    total_goals = avg_home_team_goals_scored +
        avg_away_team_goals_conceded +
        avg_home_team_goals_conceded +
        avg_away_team_goals_scored
    total_goals.zero? ? 10.0 : 1.0/total_goals
  end

  private :getGradeForGame
end