require_relative "components/ds_file_reader"
require_relative "components/ds_simulations"
require 'date'

# Read all games from file
# @file_readers = [DSFileReader.new("german_urls"),
#                  DSFileReader.new("spanish_urls"),
#                  DSFileReader.new("italian_urls"),
#                  DSFileReader.new("greece_urls"),
#                  DSFileReader.new("belgium_urls"),
#                  DSFileReader.new("frances_urls"),
#                  DSFileReader.new("italian_urls"),
#                  DSFileReader.new("nethderland_urls"),
#                  DSFileReader.new("portugali_urls"),
#                  DSFileReader.new("turkey_urls"),
#                  DSFileReader.new("english_urls")]

# @file_readers = [DSFileReader.new("spanish_urls"),
#                  DSFileReader.new("german_urls")]

@file_readers = [DSFileReader.new("english_urls")]

@file_readers.each do |current_file_reader|

  print "\n================\nCalculating odds for " + current_file_reader.url_file_name + "\n"

  number_of_games_i_can_bet_in_a_row = 5
  number_of_teams_i_will_bet_on = 1
  today_date = "16-10-2014"

  @simulation_manager = DSSimulations.new(current_file_reader)

  dates_array = ['15-09-2014','15-05-2014','15-04-2014','15-03-2014','15-02-2014','15-01-2014','15-12-2013','15-11-2013']

  simulations1 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(400), 0.75),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.25)]

  simulations2 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.85),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.15)]

  simulations3 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.075),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.025),
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(number_of_games_i_can_bet_in_a_row), 0.9)]

  simulations4 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.15),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.1),
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(number_of_games_i_can_bet_in_a_row), 0.75)]

  simulations5 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.4),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.1),
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(number_of_games_i_can_bet_in_a_row), 0.5)]

  all_simulations = [simulations1, simulations2, simulations3, simulations4, simulations5]
# all_simulations = [simulations4]

  max_grade = 0
  selected_simulation = nil
  all_simulations.each_with_index do |current_simulation, index|

    grade = 0
    dates_array.each do |current_date|
      grade +=  @simulation_manager.runSimulationWithStrategies(current_simulation, current_date, number_of_games_i_can_bet_in_a_row, number_of_teams_i_will_bet_on, false)
    end

    calc_grade = (grade * 100/ dates_array.count)
    print "Simulation " + (index+1).to_s +  ": " + ('%.2f' % calc_grade) + "%, "

    @simulation_manager.runSimulationWithStrategies(current_simulation, today_date, number_of_games_i_can_bet_in_a_row, number_of_teams_i_will_bet_on, true)

    if (max_grade < calc_grade)
      max_grade = calc_grade
      selected_simulation = current_simulation
    end
  end

  # print the chosen teams
  print "\nThese are the chosen teams for the chosen simulation: \n===============================================\n"
  @simulation_manager.runSimulationWithStrategies(selected_simulation, today_date, number_of_games_i_can_bet_in_a_row, number_of_teams_i_will_bet_on, true)

end


