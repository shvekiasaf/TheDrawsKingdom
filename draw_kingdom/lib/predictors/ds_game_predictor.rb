require_relative '../model/ds_game'
require_relative '../components/ds_season_calculator'
require_relative 'ds_score_prediction'
class DSGamePredictor

  def initialize(file_reader)
    @file_reader = file_reader
  end


  def getPrediction(game, from_date, to_date)
    validate_input(from_date, game, to_date)
    home_team_previous_games = @file_reader.getAllGamesFor(game.home_team, from_date, to_date)
    away_team_previous_games = @file_reader.getAllGamesFor(game.away_team, from_date, to_date)
    return nil if home_team_previous_games.empty? or away_team_previous_games.empty?
    home_team_goals_scored = DSSeasonCalculator.getAvgHomeTeamGoalsScored(home_team_previous_games, from_date, to_date, game.home_team)
    home_team_goals_conceded = DSSeasonCalculator.getAvgHomeTeamGoalsConceded(home_team_previous_games, from_date, to_date, game.home_team)
    away_team_goals_scored = DSSeasonCalculator.getAvgAwayTeamGoalsScored(away_team_previous_games, from_date, to_date, game.away_team)
    away_team_goals_conceded = DSSeasonCalculator.getAvgAwayTeamGoalsConceded(away_team_previous_games, from_date, to_date, game.away_team)
    delta = (home_team_goals_scored - away_team_goals_conceded).abs + (home_team_goals_conceded - away_team_goals_scored).abs
    predicted_home_goals = (home_team_goals_scored + away_team_goals_conceded)/2
    predicted_away_goals = (home_team_goals_conceded + away_team_goals_scored)/2
    weight = delta.zero? ? 100 : 1.0/delta
    DSScorePrediction.new(predicted_home_goals,predicted_away_goals,weight)
  end

  def validate_input(from_date, game, to_date)
    raise "invalid time window " if  to_date < from_date
    raise "invalid input - game date should be after time window " if game.game_date < to_date
  end

  private :validate_input
end