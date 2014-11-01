require_relative "../strategies/ds_base_strategy"
require_relative "../strategies/ds_future_games_grader"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def getGrade
    future_games = @all_team_games.select{|game| game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}
    future_games_grader = DSFutureGamesGrader.new(@all_team_games,@due_to_date)
    grade = future_games_grader.getGrade
    return normalizeGrade(grade,10)
  end


end
