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

  def self.getAvgHomeTeamGoalsScoredInSeason(games_array, season, team_object)
    goals_count = 0
    teamGamesForSeason = games_array.select { |current_game|
      current_game.season.eql? season and
          current_game.home_score.to_i != -1 and
          current_game.home_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    teamGamesForSeason.each do|game|
      goals_count+= game.home_score
    end
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

  def self.getAvgAwayTeamGoalsScoredInSeason(games_array, season, team_object)
    goals_count = 0
    teamGamesForSeason = games_array.select { |current_game|
      current_game.season.eql? season and
          current_game.home_score.to_i != -1 and
          current_game.away_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    teamGamesForSeason.each do|game|
      goals_count+= game.away_score
    end
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

end