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

    normalizeGrade(grade,@stay_power)

  end

  def getDrawLikelihood(game, game_predictor)
    prediction = game_predictor.getPrediction(game, @due_to_date - @since, @due_to_date)
    # not enough data to predict
    return 0 if prediction.nil?
    predicted_delta = (prediction.home_score - prediction.away_score).abs

    # weight how close our prediction is to a draw.
    # max delta we will calculate is 4. after that we discard the weight
    # normalize it [0,1]
    result_weight = DSHelpers.reverse_normalize_value(predicted_delta, 4.0)
    result_weight * prediction.likelihood
  end

  private :getDrawLikelihood
end