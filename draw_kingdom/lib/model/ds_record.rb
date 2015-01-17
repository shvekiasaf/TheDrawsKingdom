class DSRecord

  # Readers
  attr_reader :team_object, :general_score, :did_draw_in_next_match, :simulation_date

  # Initialize
  def initialize(team_object, general_score, did_draw_in_next_match, simulation_date)
    @simulation_date = simulation_date
    @team_object = team_object
    @general_score = general_score
    @did_draw_in_next_match = did_draw_in_next_match
  end

end
