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

  # todo: use a threshold of at least 5 previous games for the team and consider using previous seasons.
  # in case I don't have the minimum amount, see what exactly I should return.
  def self.getAvgHomeTeamGoalsScoredInSeason(games_array, season, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.season.eql? season and
          current_game.home_score.to_i != -1 and
          current_game.home_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.home_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

  # todo: use a threshold of at least 5 previous games for the team and consider using previous seasons.
  # in case I don't have the minimum amount, see what exactly I should return.
  def self.getAvgAwayTeamGoalsScoredInSeason(games_array, season, team_object)
    teamGamesForSeason = games_array.select { |current_game|
      current_game.season.eql? season and
          current_game.home_score.to_i != -1 and
          current_game.away_team.team_name.eql?(team_object.team_name)}
    if(teamGamesForSeason.empty?)
      return 0
    end
    goals_count =  teamGamesForSeason.map { |game| game.away_score.to_i}.reduce(:+)
    return goals_count.to_f/teamGamesForSeason.count.to_f
  end

end