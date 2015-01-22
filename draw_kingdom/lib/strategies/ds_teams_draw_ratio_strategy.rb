require_relative "../strategies/ds_base_strategy"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def initialize(since = nil)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def execute

    next_game = @file_reader.getNextGameForTeam(@team, @due_to_date)
    return 0 if next_game.nil?
    grade = getDrawProportionForTeam(next_game)
    return normalizeGrade(grade,1.0)
  end

  def getDrawProportionForTeam(game)
    team_games = @file_reader.getAllGamesFor(@team, @due_to_date - @since, @due_to_date + 365)
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
