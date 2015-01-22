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


  def execute
    game_predictor = DSGamePredictor.new(@file_reader)
    next_game = @file_reader.getNextGameForTeam(@team, @due_to_date)

    return 0 if next_game.nil?
    grade = getDrawLikelihood(next_game, game_predictor)
    normalizeGrade(grade,1.0)
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