class DSFutureGamesGrader

  def initialize(all_team_games,due_to_date,num_of_games)
    @all_team_games = all_team_games
    @num_of_games = num_of_games
    @due_to_date = due_to_date
  end



  def getGrade
    grade = 0
    # check if 0 to num of games is out of bounds
    future_games = @all_team_games.select{|game| game.game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..@num_of_games]
    future_games.each do |game|
      proportion = getDrawProportionForTeam(game)
      grade += proportion
    end
    return grade
  end

  def getDrawProportionForTeam(game)
    previous_matches_between_teams = @all_team_games.select {
        |current_game| gameBetweenSameTeams(game, current_game) and @due_to_date >= current_game.game_date}
    if(previous_matches_between_teams.empty?)
      return 0
    else
      num_previous_draws = previous_matches_between_teams.select { |previous_game| previous_game.isDraw() }.size()
      return num_previous_draws.to_f / previous_matches_between_teams.size().to_f
    end
  end

  def gameBetweenSameTeams(first_game, second_game)
    first_game_team_names = [first_game.home_team.team_name, first_game.away_team.team_name]
    second_game_team_names = [second_game.home_team.team_name, second_game.away_team.team_name]
    second_game_team_names.sort == first_game_team_names.sort
  end
end