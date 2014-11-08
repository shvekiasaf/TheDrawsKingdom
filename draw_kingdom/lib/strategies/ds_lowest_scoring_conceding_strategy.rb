require_relative "../strategies/ds_base_strategy"
require_relative "../components/ds_season_calculator"

class DSLowestScoringConcedingStrategy < DSBaseStrategy



  def initialize(since = nil)
    if(since.nil?)
      @since = 365
    else
      @since = since
    end
  end

  def getGrade
    team_games = @file_reader.getAllGamesFor(@team, @due_to_date - @since, @due_to_date + 365)
    future_games = team_games.select{|game| game.game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..(@stay_power - 1)]

    # we want enough data: at least stay_power future games and at least stay_power previous games
    if(team_games.length < (@stay_power * 2) or future_games.length < @stay_power)
      return 0
    end
    @from_date = @due_to_date - @since
    expected_goals = 0
    expected_goals += get_team_scoring_average(team_games)
    expected_goals += future_games.map { |game|get_other_team_scoring_average(game)}.reduce(:+)
    normalizeGrade(1.0/(expected_goals.zero? ? 0.000001 : expected_goals),10)
  end

  def get_other_team_scoring_average(game)
    other_team_scoring_avg = 0
    if (game.home_team.eql? @team)
      all_other_team_games = @file_reader.getAllGamesFor(game.away_team, @from_date, @due_to_date)
      other_team_scoring_avg = DSSeasonCalculator.getAvgAwayTeamGoalsScored(all_other_team_games, @from_date, @due_to_date, game.away_team)
    elsif (game.away_team.eql? @team)
      all_other_team_games = @file_reader.getAllGamesFor(game.home_team, @from_date, @due_to_date)
      other_team_scoring_avg = DSSeasonCalculator.getAvgHomeTeamGoalsScored(all_other_team_games, @from_date, @due_to_date, game.home_team)
    else
      msg = 'problem with team ' + @team.team_name + ' in date ' + @due_to_date
      print msg
      raise msg
    end
    other_team_scoring_avg
  end

  def get_team_scoring_average(team_games)
    DSSeasonCalculator.getAvgHomeTeamGoalsScored(team_games, @from_date, @due_to_date, @team) +
        DSSeasonCalculator.getAvgAwayTeamGoalsScored(team_games, @from_date, @due_to_date, @team)
  end


end