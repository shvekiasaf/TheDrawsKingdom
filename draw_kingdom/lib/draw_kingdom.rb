require_relative "components/ds_file_reader"
require_relative "components/ds_simulations_runner"
require_relative "components/ds_simulations_generator"
require_relative "components/ds_helpers"
require_relative "../../draw_kingdom/lib/results/ds_simulation_record_manager"
require 'date'

module DrawKingdom

  stay_power = 5 # stay power - the number of bets you agree to risk in a row
  today_date = Date.parse("28-10-2014") # define the date of the simulation
  dates_array = DSHelpers.get_dates_before_date(100, today_date) # get an array of dates
  all_simulations = DSSimulationsGenerator.get_simulations_array(stay_power)

  # Read all games from file
  file_readers = [
      DSFileReader.new("german_urls"),
      DSFileReader.new("spanish_urls"),
      DSFileReader.new("italian_urls"),
      DSFileReader.new("greece_urls"),
      DSFileReader.new("belgium_urls"),
      DSFileReader.new("frances_urls"),
      DSFileReader.new("nethderland_urls"),
      DSFileReader.new("portugali_urls"),
      DSFileReader.new("turkey_urls"),
      DSFileReader.new("english_urls")
  ]

  # file_readers = [DSFileReader.new("german_urls"), DSFileReader.new("turkey_urls")]

  file_readers.each do |current_file_reader|

    print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
    print "====================================\n"

    # configure simulation runner with teams and games data
    simulation_runner = DSSimulationsRunner.new(current_file_reader)

    # print "date,teamname,non_draw_in_a_row,non_draw_in_a_row_since,draw_games_prop,draw_games_prop_since,last_non_draw_games,future_fixtures,arrivals,did_draw_since" + "\n"

    max_earnings = -9999999999 # the variable that holds the highest earning per simulation
    selected_simulation = nil

    all_simulations.each_with_index do |current_simulation, index|

      money_gained = 0 # the total earnings of all dates
      succeeded_simulations = 0.0 # the number of dates where we succeeded to score

      simulation_records_array = Array.new
      # run each simulation on all dates
      dates_array.each do |current_date|

        # execute the simulation for the current date
        current_record = simulation_runner.runSimulationWithStrategies(current_simulation, current_date, stay_power)

        if (not current_record.nil?)
          simulation_records_array.push current_record
        else
          # todo: when does this happen?
          break
        end
      end
      simulation_record_manager = DSSimulationRecordManager.new(simulation_records_array,stay_power)
      simulation_record_manager.calculate

      # calculate average money gain and average success rate per simulation
      money_gained_avg = simulation_record_manager.money_gained_avg
      succeeded_simulations_avg = simulation_record_manager.succeeded_simulations_avg

      # if we should have choose a team today according to this simulation
      record_for_todays_team = simulation_runner.runSimulationWithStrategies(current_simulation, today_date, stay_power)

      print "Simulation " + (index+1).to_s +  ": " + ('%.2f' % money_gained_avg.to_s) + " NIS, " +
                ('%.2f' % succeeded_simulations_avg.to_s) + "%, Interest (Tsua'a): " + simulation_record_manager.interest_on_money.to_s + "%,Today: " + record_for_todays_team.team_object.team_name + "\n"

      # choose the best simulation
      if (max_earnings < money_gained_avg)
        max_earnings = money_gained_avg
        selected_simulation = current_simulation
      end
    end

    # print the chosen teams
    better_record = simulation_runner.runSimulationWithStrategies(selected_simulation, today_date, stay_power)
    print "===============> You better choose: " + better_record.team_object.team_name + "\n"

  end
end






