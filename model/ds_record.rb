class DSRecord

  # Readers
  attr_reader :team_object, :general_score, :did_draw_since

  # Initialize
  def initialize(team_object, general_score, did_draw_since)

    @team_object = team_object
    @general_score = general_score
    @did_draw_since = did_draw_since
  end
end
