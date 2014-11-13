require_relative 'ds_base_strategy'
require_relative '../../../draw_kingdom/lib/predictors/ds_game_predictor'

class DSScorePredictorStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 700
    else
      @since = since
    end
  end


  def getGrade
    game_predictor = DSGamePredictor.new(@file_reader)
    future_team_games = @file_reader.getSomeGamesForTeam(@team, @due_to_date, @stay_power)
    # can't predict without enough future games...
    return 0 if future_team_games.size < @stay_power

    # calculate average of array of likelihoods
    grade = future_team_games.map { |game| getDrawLikelihood(game, game_predictor)
    }.instance_eval { reduce(:+) / size.to_f }

    normalizeGrade(grade,5.0)

  end

  def getDrawLikelihood(game, game_predictor)
    prediction = game_predictor.getPrediction(game, @due_to_date - @since, @due_to_date)
    # not enough data to predict
    return 0 if prediction.nil?
    predicted_delta = (prediction.home_score - prediction.away_score).abs

    # don't have anything intelligent to say here :(
    return 0 if predicted_delta > 2

    predicted_delta * prediction.likelihood
  end

  private :getDrawLikelihood
end