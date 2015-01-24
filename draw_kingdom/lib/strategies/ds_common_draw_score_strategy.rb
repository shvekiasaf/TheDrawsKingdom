require_relative "ds_base_strategy"
require_relative '../predictors/ds_game_predictor'
# strategy that grades by similarity to the most common draw score achieved by the team
class DSCommonDrawScoreStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 1000
    else
      @since = since
    end
  end

  def execute
    game_predictor = DSGamePredictor.new(@file_reader)

    most_common_draw_score = get_most_common_draw_score
    return 0 if most_common_draw_score.nil?

    prediction = game_predictor.getPrediction(@game, @game.game_date - @since, @game.game_date)
    # could happen if we don't have enough data on other team
    return 0 if prediction.nil?

    delta = (prediction.home_score - most_common_draw_score[0]).abs +
        (prediction.away_score - most_common_draw_score[1]).abs
    reversed_normalized_delta = DSHelpers.reverse_normalize_value(delta, 4.0)
    normalizeGrade(reversed_normalized_delta * prediction.likelihood,1.0)
  end

  def get_most_common_draw_score
    draw_games = gamesInRange.select { |game| game.isDraw }
    # no previous games that ended with draw
    return nil if draw_games.empty?
    # counting occurrences of draws by score
    str_results_arr = draw_games.map { |game| game.home_score.to_s + ":" + game.away_score.to_s }
    hash_of_occurrences = str_results_arr.each_with_object(Hash.new(0)) { |result, counts| counts[result] += 1 }
    # returning array of size 2. first element is home score and second is away score
    hash_of_occurrences.max_by{|k,v| v}[0].split(":").map { |str_num|str_num.to_i}
  end
end