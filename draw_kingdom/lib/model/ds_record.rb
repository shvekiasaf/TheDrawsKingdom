class DSRecord

  # Readers
  attr_reader :game, :general_score

  # Initialize
  def initialize(game, general_score)
    @game = game
    @general_score = general_score
  end

end
