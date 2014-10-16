require_relative "../strategies/ds_base_strategy"
require 'date'

class DSFutureFixturesEffectStrategy < DSBaseStrategy

  def initialize(future_games_ammount)

    @future_games_ammount = future_games_ammount
  end

  def getGrade

    # retrieve future game for the current team
    future_date = Date.parse(@due_to_date) + 365
    future_games_for_team = @file_reader.getAllGamesFor(@team,
                                                     Date.parse(@due_to_date),
                                                     future_date).sort {|x,y| x.game_date <=> y.game_date}

    # Get current team league points for this season
    current_season = @all_team_games[0].season
    current_team_points = @file_reader.getTeamPoints(@all_team_games, current_season, @team)
    difference_sum = 0

    # run over the X number of future games
    if (future_games_for_team.length > @future_games_ammount)

      for i in 0..(@future_games_ammount - 1)

        # get the arrival team
        home_team = future_games_for_team[i].home_team
        away_team = future_games_for_team[i].away_team
        current_comp_team = (@team.team_name.eql? home_team.team_name) ? away_team : home_team

        # get the arrival team league points according to relevant date
        all_games_for_comp_team = @file_reader.getAllGamesFor(current_comp_team, Date.parse('01-01-1804'), Date.parse(@due_to_date))
        current_comp_team_points = @file_reader.getTeamPoints(all_games_for_comp_team, current_season, current_comp_team)

        # calculate the difference between the arrival league points to the current team points
        difference_sum += (current_team_points - current_comp_team_points).abs
      end

      # calculating average
      grade = difference_sum / @future_games_ammount

      # normalize grade
      return normalizeGrade(grade, 7.0)
    else

      # print @team.team_name + "\n"

      return 0
    end
  end

  def normalizeGrade(grade, range)
    normalizeGrade = super(grade, range)

    return (normalizeGrade - 100) * -1
  end
end