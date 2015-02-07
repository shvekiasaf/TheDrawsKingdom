require 'date'

class DSGame
  # Readers
  attr_reader :game_date, :home_team, :away_team, :home_score, :away_score, :div, :season, :b365_draw_odds

  # Initialize
  def initialize(game_date, home_team, away_team, home_score, away_score, div, season, b365_draw_odds)

    @game_date =  game_date
    @home_team = home_team
    @away_team = away_team
    @home_score = home_score
    @away_score = away_score
    @div = div
    @season = season
    @b365_draw_odds = b365_draw_odds
  end

  def isDraw
    return nil if missing_score
    @dif = @home_score.to_i - @away_score.to_i
    return (@dif == 0)
  end

  def missing_score
    @home_score == -1 or @away_score == -1
  end

  def isTeamInMatch(team)
    return (@home_team.team_name.eql?(team.team_name) or @away_team.team_name.eql?(team.team_name))
  end

  def pointsForTeam(team_object)

    return 0 if missing_score
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

  # this method recieve a team and return its opponent
  def getOpponentForTeam(team)
    # get the arrival team
    current_comp_team = (team.team_name.eql? @home_team.team_name) ? @away_team : home_team

    return current_comp_team
  end

  # return true iff input game had same teams
  def isSameTeams(game)
    return false if game.nil? or game.home_team.nil? or game.away_team.nil?
    [@home_team.team_name,@away_team.team_name].sort == [game.home_team.team_name,game.away_team.team_name].sort
  end

  # return true iff input game had same teams
  def isOneOfTheTeamsSame(game)
    return false if game.nil? or game.home_team.nil? or game.away_team.nil?

    ((@home_team.team_name.eql?(game.home_team.team_name)) ||
     (@home_team.team_name.eql?(game.away_team.team_name)) ||
     (@away_team.team_name.eql?(game.home_team.team_name)) ||
     (@away_team.team_name.eql?(game.away_team.team_name)))
  end

  # return true iff input game had same teams with corresponding home/ away configuration
  def isSameMatch(game)
    isSameTeams(game) and @home_team.team_name.eql?(game.home_team.team_name)
  end

  def gameName
    @home_team.team_name + " VS " + @away_team.team_name
  end

end