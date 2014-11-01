require_relative "../strategies/ds_base_strategy"
require_relative "../strategies/ds_future_games_grader"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def getGrade
    future_games_grader = DSFutureGamesGrader.new(@all_team_games,@due_to_date,@stay_power)
    grade = future_games_grader.getGrade
    return normalizeGrade(grade,10)
  end


end
