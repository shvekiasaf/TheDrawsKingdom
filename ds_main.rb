require_relative "model/ds_game"
require_relative "model/ds_team"
require_relative "model/ds_record"
require_relative "model/ds_strategy_value"
require_relative "components/ds_file_reader"
require_relative "strategies/ds_base_strategy"
require_relative "strategies/ds_draw_games_proportion_strategy"
require_relative "strategies/ds_last_non_draw_in_a_row_strategy"
require_relative "strategies/ds_non_draw_in_a_row_strategy"
require 'colorize'

# Read all games from file
@file_reader = DSFileReader.new("../stats/urls")
@records_array = Array.new()

# debug
# print "teamname,did_draw_since,non_draw_in_a_row,non_draw_in_a_row_since,draw_games_prop,draw_games_prop_since,last_non_draw_games" + "\n"

@file_reader.teamsHash.each do |team_name, team_object|

  # get all games per team between dates
  all_games_for_team = @file_reader.getAllGamesFor(team_object, Date.parse('01-01-1804'), Date.parse('15-03-2014'))

  if (not all_games_for_team.nil?)

    # only teams with more than 100 games will be checked
    if (all_games_for_team.count > 100)

      # For simulation purposes -
      # Check whether team has a draw or not in X number of games after custom date
      some_games_for_team = @file_reader.getSomeGamesForTeam(team_object, Date.parse('15-03-2014'), 10)
      did_draw_since = false
      # count the number of draws since date
      some_games_for_team.each do |current_game|
        if (current_game.isDraw)
          did_draw_since = true
        end
      end

      # debug
      # print team_name + "," + (did_draw_since ? "1" : "0")

      @strategies = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(all_games_for_team, team_object, nil), 0),
                     DSStrategyValue.new(DSNonDrawInARowStrategy.new(all_games_for_team, team_object, 500), 0),
                     DSStrategyValue.new(DSDrawGamesProportionStrategy.new(all_games_for_team, team_object, nil), 0.0),
                     DSStrategyValue.new(DSDrawGamesProportionStrategy.new(all_games_for_team, team_object, 500), 0.85),
                     DSStrategyValue.new(DSLastNonDrawInARowStrategy.new(all_games_for_team, team_object), 0.15)]

      @totalGrade = 0
      @strategies.each do |current_strategy_value|

        tempgrade = current_strategy_value.strategy.getGrade.abs
        @totalGrade += tempgrade * current_strategy_value.value

        # debug
        # print "," + ('%.2f' % tempgrade)
      end

      currentRecord = DSRecord.new(team_object, @totalGrade, did_draw_since)
      @records_array.push(currentRecord)

      # debug
      # print "\n"
    end
  end
end

# Printing all records sorted by general score
print "====================================" + "\n"
@records_array = @records_array.sort {|x,y| y.general_score <=> x.general_score}
@records_array.each() do |x|
   print  x.team_object.team_name.to_s + ":\t\t" + ('%.2f' % x.general_score) + " draw? " + (x.did_draw_since ? "YES".green : "NO".red) + "\n"
end

