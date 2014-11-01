class DSRecord

  # Readers
  attr_reader :team_object, :general_score, :draw_after_attempt, :simulation_date

  # Initialize
  def initialize(team_object, general_score, draw_after_attempt,simulation_date)
    @simulation_date = simulation_date
    @team_object = team_object
    @general_score = general_score
    @draw_after_attempt = draw_after_attempt
  end

  def did_draw_since
    if (not @draw_after_attempt.nil?)

      if (@draw_after_attempt == -1)
        return false
      else
        return true
      end
    else
      return false
    end
  end
end
