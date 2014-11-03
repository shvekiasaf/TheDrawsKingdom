require_relative "../strategies/ds_base_strategy"
require_relative "../strategies/ds_future_games_grader"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def getGrade

    team_games = @file_reader.getAllGamesFor(@team, @due_to_date - 999, @due_to_date + 365)
    future_games_grader = DSFutureGamesGrader.new(team_games,@due_to_date,@stay_power)
    grade = future_games_grader.getGrade
    return normalizeGrade(grade,10)
  end


end
