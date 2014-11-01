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
end