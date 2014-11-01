require 'date'

class DSGame
  # Readers
  attr_reader :game_date, :home_team, :away_team, :home_score, :away_score, :div, :season

  # Initialize
  def initialize(game_date, home_team, away_team, home_score, away_score, div, season)

    @game_date =  game_date
    @home_team = home_team
    @away_team = away_team
    @home_score = home_score
    @away_score = away_score
    @div = div
    @season = season
  end

  def isDraw
    @dif = @home_score.to_i - @away_score.to_i
    return (@dif == 0)
  end

  def isTeamInMatch(team)
    return (@home_team.team_name.eql?(team.team_name) or @away_team.team_name.eql?(team.team_name))
  end

  def pointsForTeam(team_object)

    home_points = 0
    away_points = 0

    if (@home_score.to_i > @away_score.to_i)
      home_points = 3
      away_points = 0
    elsif (isDraw)
      home_points = 1
      away_points = 1
    else
      home_points = 0
      away_points = 3
    end

    if (team_object.team_name.eql? home_team.team_name)

      return home_points
    else
      return away_points
    end
  end
end