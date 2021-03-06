class DSSeasonCalculator
  def self.getTeamPoints(games_array, season, team_object)

    points = 0
    games_array.each() do |current_game|

      if (current_game.season.eql? season)

        if (current_game.home_score.to_i != -1)
          points += current_game.pointsForTeam(team_object)
        end
      end
    end

    return points
  end

  def self.getAvgHomeTeamGoalsScored(games_array, from_date, due_to_date, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.game_date >= from_date and
          current_game.game_date <= due_to_date and
          current_game.home_score.to_i != -1 and
          current_game.home_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.home_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

  def self.getAvgHomeTeamGoalsConceded(games_array, from_date, due_to_date, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.game_date >= from_date and
          current_game.game_date <= due_to_date and
          current_game.home_score.to_i != -1 and
          current_game.home_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.away_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

  def self.getAvgAwayTeamGoalsScored(games_array, from_date , due_to_date, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.game_date >= from_date and
          current_game.game_date <= due_to_date and
          current_game.home_score.to_i != -1 and
          current_game.away_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.away_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end
  def self.getAvgAwayTeamGoalsConceded(games_array, from_date , due_to_date, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.game_date >= from_date and
          current_game.game_date <= due_to_date and
          current_game.home_score.to_i != -1 and
          current_game.away_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.home_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end
  def self.getAvgTeamGoalDifference(games_array, team_object)

    total_difference = 0

    teamGamesForSeason = games_array.select {|current_game| (!current_game.missing_score)}
    teamGamesForSeason.each() do |current_game|
      diff = current_game.home_score.to_i - current_game.away_score.to_i
      if (team_object == current_game.away_team)
        diff = diff * -1
      end

      total_difference += diff
    end

    if (teamGamesForSeason.empty?)
      nil
    else
      total_difference.to_f / teamGamesForSeason.size
    end
  end

end