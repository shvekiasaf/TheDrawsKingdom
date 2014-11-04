require_relative "../strategies/ds_base_strategy"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def initialize(since = nil)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def getGrade

    team_games = @file_reader.getAllGamesFor(@team, @due_to_date - @since, @due_to_date + 365)

    future_games = team_games.select{|game| game.game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..(@stay_power - 1)]
    grade = future_games.reduce(0) {|reduced_grade,game| getDrawProportionForTeam(game,team_games)}

    return normalizeGrade(grade,10)
  end

  def getDrawProportionForTeam(game, team_games)
    previous_matches_between_teams = team_games.select {
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
