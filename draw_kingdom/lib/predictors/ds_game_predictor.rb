require_relative '../model/ds_game'
require_relative '../components/ds_season_calculator'
require_relative 'ds_score_prediction'
require_relative '../components/ds_helpers'
class DSGamePredictor

  def initialize(file_reader)
    @file_reader = file_reader
  end


  def getPrediction(game, from_date, to_date)

    validate_input(from_date, game, to_date)

    # get previous games for both teams
    home_team_previous_games = @file_reader.getAllGamesFor(game.home_team, from_date, to_date)
    away_team_previous_games = @file_reader.getAllGamesFor(game.away_team, from_date, to_date)
    return nil if home_team_previous_games.empty? or away_team_previous_games.empty?

    # calculate average scoring/conceding data for HOME team
    home_team_goals_scored = DSSeasonCalculator.getAvgHomeTeamGoalsScored(home_team_previous_games, from_date, to_date, game.home_team)
    home_team_goals_conceded = DSSeasonCalculator.getAvgHomeTeamGoalsConceded(home_team_previous_games, from_date, to_date, game.home_team)

    # calculate average scoring/conceding data for AWAY team
    away_team_goals_scored = DSSeasonCalculator.getAvgAwayTeamGoalsScored(away_team_previous_games, from_date, to_date, game.away_team)
    away_team_goals_conceded = DSSeasonCalculator.getAvgAwayTeamGoalsConceded(away_team_previous_games, from_date, to_date, game.away_team)

    predicted_home_goals = (home_team_goals_scored + away_team_goals_conceded)/2
    predicted_away_goals = (home_team_goals_conceded + away_team_goals_scored)/2

    prediction_likelihood = calculate_prediction_likelihood(away_team_goals_conceded, away_team_goals_scored, home_team_goals_conceded, home_team_goals_scored)

    DSScorePrediction.new(predicted_home_goals,predicted_away_goals,prediction_likelihood)
  end

  # we predict based on two data inputs (home team previous scores and away team previous scores)
  # weight is a measurement of how accurate is our prediction
  # we assume that delta < 8 and reverse normalize to [0,1]
  def calculate_prediction_likelihood(away_team_goals_conceded, away_team_goals_scored, home_team_goals_conceded, home_team_goals_scored)
    delta = (home_team_goals_scored - away_team_goals_conceded).abs + (home_team_goals_conceded - away_team_goals_scored).abs
    DSHelpers.reverse_normalize_value(delta,0, 8.0,1.0)
  end

  def validate_input(from_date, game, to_date)
    raise "invalid time window " if  to_date < from_date
    raise "invalid input - game date should be after time window " if game.game_date < to_date
  end

  private :validate_input, :calculate_prediction_likelihood
end