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
require 'colorize'

class DSSimulations

  # Readers
  attr_reader :file_reader

  # Initialize
  def initialize(file_reader)
    @file_reader = file_reader
  end

  def runSimulationWithStrategies(strategies, due_to_date, success_indicator)

    @records_array = Array.new()

    # debug
    # print "teamname,did_draw_since,non_draw_in_a_row,non_draw_in_a_row_since,draw_games_prop,draw_games_prop_since,last_non_draw_games" + "\n"

    @file_reader.teamsHash.each do |team_name, team_object|

      # get all games per team between dates
      all_games_for_team = @file_reader.getAllGamesFor(team_object, Date.parse('01-01-1804'), due_to_date)

      if (not all_games_for_team.nil?)

        # only teams with more than 100 games will be checked
        if (all_games_for_team.count > 100)

          # For simulation purposes -
          # Check whether team has a draw or not in X number of games after custom date
          some_games_for_team = @file_reader.getSomeGamesForTeam(team_object, due_to_date, success_indicator)
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

          # print team_name + "," + (did_draw_since ? "1" : "0")

          @totalGrade = 0
          strategies.each do |current_strategy_value|

            # set all teams and team object for current strategy
            current_strategy_value.strategy.loadGamesAndTeam(@file_reader, team_object, due_to_date)

            # calculate the current simulation grade
            tempgrade = current_strategy_value.strategy.getGrade.abs

            @totalGrade += tempgrade * current_strategy_value.value

            # debug
            # print "," + ('%.2f' % tempgrade)
          end

          currentRecord = DSRecord.new(team_object, @totalGrade, did_draw_since, draw_after_attempt)
          @records_array.push(currentRecord)

          # debug
          # print "\n"


        end
      end

    end

    # Printing all records sorted by general score
    #  print "====================================" + "\n"
    @records_array = @records_array.sort {|x,y| y.general_score <=> x.general_score}

    if (@records_array.length > 0)
      current_record = @records_array[0]

      return current_record
    else
      return nil
    end
  end
end