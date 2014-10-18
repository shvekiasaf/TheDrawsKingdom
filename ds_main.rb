require_relative "components/ds_file_reader"
require_relative "components/ds_simulations"
require 'date'

# Read all games from file
@file_readers = [#DSFileReader.new("german_urls"),
                 # DSFileReader.new("spanish_urls"),
                 # DSFileReader.new("italian_urls"),
                 # DSFileReader.new("greece_urls"),
                 # DSFileReader.new("belgium_urls"),
                 DSFileReader.new("frances_urls")]
                 # DSFileReader.new("nethderland_urls"),
                 # DSFileReader.new("portugali_urls"),
                 # DSFileReader.new("turkey_urls"),
                 # DSFileReader.new("english_urls")]

@file_readers.each do |current_file_reader|

  print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
  print "====================================\n"

  stay_power = 7
  initial_bet_money = 10
  today_date = Date.parse("16-10-2014")

  @simulation_manager = DSSimulations.new(current_file_reader)

  # create array with dates for simluations
  dates_array = Array.new
  current_date = today_date - 60
  for i in 0..(20)

    if (current_date.strftime("%m").eql? "08")
      current_date -= 100
    end

    current_date = current_date - 7
    dates_array.push(current_date)
  end

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
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 0.9)]

  simulations4 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.15),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.1),
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 0.75)]

  simulations5 = [DSStrategyValue.new(DSNonDrawInARowStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSNonDrawInARowStrategy.new(500), 0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(nil), 0.0),
                  DSStrategyValue.new(DSDrawGamesProportionStrategy.new(700), 0.4),
                  DSStrategyValue.new(DSLastNonDrawInARowStrategy.new, 0.1),
                  DSStrategyValue.new(DSFutureFixturesEffectStrategy.new(stay_power), 0.5)]

  # all_simulations = [simulations1, simulations2, simulations3, simulations4, simulations5]
all_simulations = [simulations3]

  max_earnings = -9999999999
  selected_simulation = nil
  all_simulations.each_with_index do |current_simulation, index|

    money_gained = 0
    succeeded_simulations = 0.0

    # run each simulation on all dates
    dates_array.each do |current_date|

      current_record = @simulation_manager.runSimulationWithStrategies(current_simulation, current_date, stay_power)

      # summarize success
      succeeded_simulations += (current_record.did_draw_since == true) ? 1 : 0

      # calculate profit according to
      money_gained += (current_record.draw_after_attempt == -1) ? -1 * ((initial_bet_money * (2 ** stay_power)) * 2 - initial_bet_money) # loss
                      : (0.3 * (initial_bet_money * 2 ** current_record.draw_after_attempt)) + initial_bet_money # win

    end

    # calculate average money gain and average success rate per simulation
    money_gained_avg = (money_gained / dates_array.count)
    succeeded_simulations_avg = (100 * succeeded_simulations / dates_array.count)

    # if we should have choose a team today according to this simulation
    record_for_todays_team = @simulation_manager.runSimulationWithStrategies(current_simulation, today_date, stay_power)

    print "Simulation " + (index+1).to_s +  ": " + ('%.2f' % money_gained_avg.to_s) + " NIS, " +
              ('%.2f' % succeeded_simulations_avg.to_s) + "% " + "Today: " + record_for_todays_team.team_object.team_name + "\n"

    # choose the best simulation
    if (max_earnings < money_gained_avg)
      max_earnings = money_gained_avg
      selected_simulation = current_simulation
    end
  end

  # print the chosen teams
  better_record = @simulation_manager.runSimulationWithStrategies(selected_simulation, today_date, stay_power)
  print "===============> You better choose: " + better_record.team_object.team_name + "\n"

end