class DSRecord

  # Readers
  attr_reader :team_object, :general_score, :did_draw_since, :draw_after_attempt

  # Initialize
  def initialize(team_object, general_score, did_draw_since, draw_after_attempt)

    @team_object = team_object
    @general_score = general_score
    @did_draw_since = did_draw_since
    @draw_after_attempt = draw_after_attempt
  end
end
