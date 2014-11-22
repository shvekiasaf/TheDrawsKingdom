require_relative "../model/ds_game"
require_relative "../model/ds_team"
require_relative "../model/ds_record"
require_relative "../model/ds_strategy_value"
require_relative "ds_file_reader"
require_relative "../strategies/ds_base_strategy"
require_relative "../strategies/ds_draw_games_proportion_strategy"
require_relative "../strategies/ds_last_non_draw_in_a_row_strategy"
require_relative "../strategies/ds_non_draw_in_a_row_strategy"
require_relative "../strategies/ds_future_fixtures_effect_strategy"
require_relative "../strategies/ds_arrivals_strategy"


class DSSimulationsRunner

  # Readers
  attr_reader :file_reader

  # Initialize
  def initialize(file_reader)
    @file_reader = file_reader
  end

  # run all strategies for specific date.
  # return the record of the best strategy
  # with respect to strategy weights
  def run_simulations_for_strategies(strategies, due_to_date, stay_power, csv_file)
    values_array_for_csv = Array.new

    @records_array = Array.new
    totalGrade = 0
    weightSum = 0
    # same as in previous algorithm
    draw_after_attempt = 0
    strategies.each do |current_strategy_value|
      team, draw_after_attempt, grade = get_draw_after_attempt_for_strategy(
          current_strategy_value.strategy,
          due_to_date,
          stay_power)
      values_array_for_csv.push(grade)

      totalGrade += grade * current_strategy_value.weight
      weightSum += current_strategy_value.weight
    end

    DSRecord.new(team_object, totalGrade.to_f/weightSum, draw_after_attempt,due_to_date)

  end

  def runSimulationWithStrategies(strategies, due_to_date, stay_power, csv_file)

    values_array_for_csv = Array.new

    @records_array = Array.new
    @file_reader.teamsHash.each do |team_name, team_object|

      # get all team's games until now
      all_games_for_team = @file_reader.getAllGamesFor(team_object,
                                                       nil, # from date
                                                       due_to_date) # to date

      if (not all_games_for_team.nil?)

        # only teams with more than 100 games in history will be checked
        if (all_games_for_team.count > 100)

          # if had a draw in the following X games, then - on what attempt. else = -1
          draw_after_attempt = get_draw_after_attempt_indicator(team_object, due_to_date, stay_power)

          @totalGrade = 0
          weightSum = 0

          strategies.each do |current_strategy_value|

            # set all teams and team object for current strategy
            current_strategy_value.strategy.loadGamesAndTeam(@file_reader, team_object, due_to_date, strategies, stay_power)

            # calculate the current simulation grade
            tempgrade = current_strategy_value.strategy.getGrade.abs
            values_array_for_csv.push(tempgrade)

            @totalGrade += tempgrade * current_strategy_value.weight
            weightSum += current_strategy_value.weight
          end

          @totalGrade /= weightSum

          currentRecord = DSRecord.new(team_object, @totalGrade, draw_after_attempt,due_to_date)
          @records_array.push(currentRecord)

          if (not csv_file.nil?)
            # print the current values into the csv
            values_array_for_csv.push(due_to_date)
            values_array_for_csv.push(team_object.team_name)
            values_array_for_csv.push(currentRecord.did_draw_since ? 1 : 0)
            csv_file << values_array_for_csv
            values_array_for_csv.clear
          end
        end
      end

    end

    # Printing all records sorted by general score
    # print "====================================" + "\n"

    best_record = @records_array.max_by {|record| record.general_score}
    best_record
  end


  def get_draw_after_attempt_for_strategy(strategy, due_to_date, stay_power)
    teams = @file_reader.teamsHash.values
    all_teams_next_games = Hash[teams.
                                    # return map of team -> future team games
                                    map { |team| [team, @file_reader.getSomeGamesForTeam(team, due_to_date, (stay_power * 2)).reverse] }].
        # filter teams without enough future games
        select{|team,future_games| team_data_sufficient(future_games, stay_power,due_to_date) }

    stay_power.times { |game_bet_index|
      # get a map of team -> grade for team for strategy for this specific date
      team_grades_for_strategy = Hash[all_teams_next_games.map { |team, future_games| [team, get_grade_for_team_and_strategy_specific_date(
          strategy,
          team,
          future_games,
          game_bet_index
      )] }]

      # find the best team on this date
      best_team, grade = team_grades_for_strategy.max_by { |team, grade| grade }

      next_team_game = all_teams_next_games[best_team][game_bet_index + 1]
      return best_team, game_bet_index, grade if (next_team_game.isDraw)
    }
  end

  def team_data_sufficient(future_games, stay_power,due_to_date)
    all_games_for_team = @file_reader.getAllGamesFor(team_object,
                                                     nil, # from date
                                                     due_to_date) # to date
    future_games.size >= stay_power * 2 and all_games_for_team.size > 100
  end

  def get_grade_for_team_and_strategy_specific_date(strategy, team, team_next_games, game_bet_index)
    # we want to calculate grade BEFORE the next game
    to_date = team_next_games[game_bet_index].game_date - 1

    strategy.loadGamesAndTeam(@file_reader, team, to_date, nil, nil)
    strategy.getGrade
  end

  def get_draw_after_attempt_indicator(team_object, due_to_date, stay_power)
    # Check whether team has a draw or not in X number of games after custom date
    # todo: MAJOR BUG HERE!!!. getSomeGamesForTeam returns an array sorted by descending dates
    some_games_for_team = @file_reader.getSomeGamesForTeam(team_object, due_to_date, stay_power).reverse
    did_draw_since = false
    draw_after_attempt = 0

    # count the number of draws since date
    some_games_for_team.each do |current_game|
      draw_after_attempt += 1
      if (current_game.isDraw)
        did_draw_since = true
        break
      end
    end
    if (did_draw_since != true)
      draw_after_attempt = -1
    end

    return draw_after_attempt
  end
end