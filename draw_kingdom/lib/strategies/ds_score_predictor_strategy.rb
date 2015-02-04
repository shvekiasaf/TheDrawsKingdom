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
    prediction = game_predictor.getPrediction(@game, @game.game_date - @since, @game.game_date)
    # not enough data to predict
    return insufficient_data_for_strategy if prediction.nil?
    predicted_delta = (prediction.home_score - prediction.away_score).abs

    # weight how close our prediction is to a draw.
    # max delta we will calculate is 4. after that we discard the weight
    # normalize it [0,1]
    result_weight = DSHelpers.reverse_normalize_value(predicted_delta, 0, 4.0)
    result_weight * prediction.likelihood
  end


end