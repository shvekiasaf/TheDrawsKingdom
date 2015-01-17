require_relative 'ds_file_reader'

class DSDynamicSimulationsRunner

  def initialize(file_reader)
    @file_reader = file_reader
  end

  def get_team_grades(strategies, date, stay_power)
    weightSum = strategies.map { |strategy_value| strategy_value.weight}.reduce(:+)
    teams = @file_reader.teamsHash.values.select{|team| past_team_data_sufficient(team,date)}
    team_grades = Hash.new
    return nil if teams.empty?
    teams.each do |team|
      totalGrade = 0
      strategies.each do |current_strategy_value|
        current_strategy_value.strategy.loadGamesAndTeam(@file_reader, team, date, strategies, stay_power)
        grade = current_strategy_value.strategy.getGrade
        totalGrade += grade * current_strategy_value.weight
      end

      team_grades[team] = totalGrade.to_f/weightSum
    end
    # DESCENDING sort by grade
    team_grades.sort_by {|team, grade| grade}.reverse
  end

  def get_draw_after(strategies, start_date, stay_power)

    teams = @file_reader.teamsHash.values

    # all_teams_next_games = hash of [team -> future team games].
    all_teams_next_games = Hash[teams.
                                    map { |team| [team, @file_reader.getSomeGamesForTeam(team, start_date, (stay_power * 2)).reverse] }].
        select{|team,future_games| future_team_data_sufficient(team,future_games,start_date, stay_power) }

    # in compliance with static algorithm
    return nil if all_teams_next_games.empty?
    1.upto(stay_power) { |game_bet_index|
      next_team_game = game_for_next_bet(all_teams_next_games, game_bet_index, stay_power, strategies)
      return game_bet_index if next_team_game.isDraw
    }
    # failed in predicting for all stay_power games (what a loser...)
    return -1
  end


  # helper functions

  def game_for_next_bet(all_teams_next_games, game_bet_index, stay_power, strategies)
    next_simulation_date = get_next_simulation_date(all_teams_next_games, game_bet_index)
    team_grades = get_team_grades(strategies, next_simulation_date, stay_power)
    team_grades.each do |team, grade|
      if(not (all_teams_next_games[team].nil? or all_teams_next_games[team][game_bet_index].nil?))
        return (all_teams_next_games[team][game_bet_index])
      end
    end
  end

  def future_team_data_sufficient(team, future_games, date, stay_power)
    minimal_future_games_amount = stay_power * 2
    future_games.size == minimal_future_games_amount and past_team_data_sufficient(team,date)
  end

  def past_team_data_sufficient(team,date)
    all_games_for_team = @file_reader.getAllGamesFor(team,
                                                     nil, # from date
                                                     date) # to date
    all_games_for_team.size > 100
  end


  # gets the next date to run the simulation on.
  # in fact it goes to the next round of games, takes the earliest game and takes
  # 1 day before
  def get_next_simulation_date(all_teams_next_games, game_bet_index)
    latest_game_for_bet_index = all_teams_next_games.map { |team, next_games| next_games[game_bet_index] }.
        min_by { |game| game.game_date }
    latest_game_for_bet_index.game_date - 1
  end
  private :past_team_data_sufficient, :future_team_data_sufficient, :get_next_simulation_date, :game_for_next_bet

end
