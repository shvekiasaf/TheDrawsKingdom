class DSGoalsCalculator

  def initialize(team, file_reader, from_date, to_date, amount_of_games,average_away_calculator,average_home_calculator)
    @team = team
    @file_reader = file_reader
    @from_date = from_date
    @to_date = to_date
    @amount_of_games = amount_of_games
    @average_away_calculator = average_away_calculator
    @average_home_calculator = average_home_calculator
  end

  def getGrade
    team_games = @file_reader.getAllGamesFor(@team, @from_date, @to_date + 365)
    future_games = team_games.select{|game| game.game_date > @to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..(@amount_of_games - 1)]

    # we want enough data: at least stay_power future games and at least stay_power previous games
    return 0 if (team_games.length < (@amount_of_games * 2) or future_games.length < @amount_of_games)
    expected_goals = 0
    expected_goals += get_team_scoring_average(team_games)
    expected_goals += future_games.map { |game|get_other_team_scoring_average(game)}.reduce(:+)
    expected_goals
  end

  def get_other_team_scoring_average(game)
    if game.home_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.away_team, @from_date, @to_date)
      other_team_scoring_avg = @average_away_calculator.call(all_other_team_games, @from_date, @to_date, game.away_team)
    elsif game.away_team.team_name.eql? @team.team_name
      all_other_team_games = @file_reader.getAllGamesFor(game.home_team, @from_date, @to_date)
      other_team_scoring_avg = @average_home_calculator.call(all_other_team_games, @from_date, @to_date, game.home_team)
    else
      msg = "#{@team.team_name} not found in game between #{game.home_team.team_name} and #{game.away_team.team_name} on date #{@to_date.to_s}"
      print msg
      raise msg
    end
    other_team_scoring_avg
  end

  def get_team_scoring_average(team_games)
    @average_home_calculator.call(team_games, @from_date, @to_date, @team) +
        @average_away_calculator.call(team_games, @from_date, @to_date, @team)
  end
end
