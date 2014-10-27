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
require 'colorize'

class DSSimulationsRunner

  # Readers
  attr_reader :file_reader

  # Initialize
  def initialize(file_reader)
    @file_reader = file_reader
  end

  def runSimulationWithStrategies(strategies, due_to_date, stay_power)

    @records_array = Array.new()

    # debug
    # print "teamname,did_draw_since,non_draw_in_a_row,non_draw_in_a_row_since,draw_games_prop,draw_games_prop_since,last_non_draw_games,future_fixtures,arrivals" + "\n"

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

          # print due_to_date.to_s + "," + team_name

          @totalGrade = 0
          weightSum = 0
          strategies.each do |current_strategy_value|

            # set all teams and team object for current strategy
            current_strategy_value.strategy.loadGamesAndTeam(@file_reader, team_object, due_to_date, strategies, stay_power)

            # calculate the current simulation grade
            tempgrade = current_strategy_value.strategy.getGrade.abs

            @totalGrade += tempgrade * current_strategy_value.weight
            weightSum += current_strategy_value.weight
            # debug
            # print "," + ('%.2f' % tempgrade)
          end

          @totalGrade /= weightSum

          currentRecord = DSRecord.new(team_object, @totalGrade, draw_after_attempt)
          @records_array.push(currentRecord)

          # debug
          # print "," + (currentRecord.did_draw_since ? "1" : "0") + "\n"
        end
      end

    end

    # Printing all records sorted by general score
    # print "====================================" + "\n"
    @records_array = @records_array.sort {|x,y| y.general_score <=> x.general_score}

    if (@records_array.length > 0)
      current_record = @records_array[0]

      return current_record
    else
      return nil
    end
  end

  def get_draw_after_attempt_indicator(team_object, due_to_date, stay_power)
    # Check whether team has a draw or not in X number of games after custom date
    some_games_for_team = @file_reader.getSomeGamesForTeam(team_object, due_to_date, stay_power)
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