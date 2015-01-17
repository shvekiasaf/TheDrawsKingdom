require_relative "components/ds_file_reader"
require_relative "components/ds_simulations_runner"
require_relative "components/ds_simulations_generator"
require_relative "components/ds_helpers"
require_relative "../../draw_kingdom/lib/results/ds_simulation_record_manager"
require_relative "components/ds_dynamic_simulations_runner"
require 'date'
require 'csv'
require 'fileutils'

NUMBER_OF_DATES = 200
TODAY_DATE = "17-01-2015"

module DrawKingdom

  today_date      = Date.parse(TODAY_DATE) # define the date of the simulation dd-mm-yyyy
  dates_array     = DSHelpers.get_dates_before_date(NUMBER_OF_DATES, today_date) # get an array of dates
  all_simulations = DSSimulationsGenerator.get_simulations_array
  file_readers    = [DSFileReader.new("german_urls")]

  # #Read all games from file
  # file_readers = [
  #     DSFileReader.new("german_urls"),
  #     DSFileReader.new("spanish_urls"),
  #     DSFileReader.new("italian_urls"),
  #     DSFileReader.new("greece_urls"),
  #     DSFileReader.new("belgium_urls"),
  #     DSFileReader.new("frances_urls"),
  #     DSFileReader.new("nethderland_urls"),
  #     DSFileReader.new("portugali_urls"),
  #     DSFileReader.new("turkey_urls"),
  #     DSFileReader.new("english_urls")
  # ]

  if (dates_array.nil?)

    print "No dates were given to execute simulations\n"
  elsif (all_simulations.nil?)

    print "No simulations were given\n"
  else
    # for each set of teams from url
    file_readers.each do |current_file_reader|

      print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
      print "====================================\n"

      best_simulation_success_rate = 0
      best_simulation_index        = 0

      all_simulations.each_with_index do |current_simulation, index|

        total_number_of_successes = 0
        valid_dates_count         = 0

        # run each simulation on all dates
        dates_array.each do |current_date|

          # The function runs the simulation on all teams for current date,
          # picks the best team (from all grades) and returns whether the team draw or not in the next game
          did_draw = DSDynamicSimulationsRunner.does_best_team_draw(current_simulation,
                                                                    current_date,
                                                                    current_file_reader)

          if (did_draw.nil?)
            # No calculation were executed for current date
          else

            valid_dates_count += 1
            # count the number of successes
            total_number_of_successes += (did_draw ? 1 : 0)
          end

          #todo: handle case when we don't have enough previous games for the calculations

        end

        # choose the best simulation according to the best success rate
        simulation_success_rate_tmp = total_number_of_successes.to_f / valid_dates_count
        if (simulation_success_rate_tmp > best_simulation_success_rate)
          best_simulation_index = index
          best_simulation_success_rate = simulation_success_rate_tmp
        end
      end

      # pick the best simulation
      best_simulation = all_simulations[best_simulation_index]

      # run the best simulation on current date

      # print the selected team and the success rate of the simulation
      print best_simulation_index.to_s + ", " + ('%.2f' % best_simulation_success_rate.to_s)
    end
  end
end





# module DrawKingdom
#
#   stay_power = 5 # stay power - the number of bets you agree to risk in a row
#   today_date = Date.parse("27-11-2014") # define the date of the simulation dd-mm-yyyy
#   dates_array = DSHelpers.get_dates_before_date(200, today_date) # get an array of dates
#   all_simulations = DSSimulationsGenerator.get_simulations_array(stay_power)
#
  # Read all games from file
  # file_readers = [
  #     DSFileReader.new("german_urls"),
  #     DSFileReader.new("spanish_urls"),
  #     DSFileReader.new("italian_urls"),
  #     DSFileReader.new("greece_urls"),
  #     DSFileReader.new("belgium_urls"),
  #     DSFileReader.new("frances_urls"),
  #     DSFileReader.new("nethderland_urls"),
  #     DSFileReader.new("portugali_urls"),
  #     DSFileReader.new("turkey_urls"),
  #     DSFileReader.new("english_urls")
  # ]

#   file_readers = [DSFileReader.new("german_urls")]
#
#   FileUtils.rm_rf("csvs")
#   FileUtils.mkdir("csvs")
#   FileUtils.cd("csvs") do
#
#   file_readers.each do |current_file_reader|
#
#     print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
#     print "====================================\n"
#
#     # configure simulation runner with teams and games data
#     # simulation_runner = DSSimulationsRunner.new(current_file_reader)
#     simulation_runner = DSDynamicSimulationsRunner.new(current_file_reader)
#
#     max_earnings = -9999999999 # the variable that holds the highest earning per simulation
#     best_team = nil
#
#     all_simulations.each_with_index do |current_simulation, index|
#
#       CSV.open(current_file_reader.url_file_name + ".csv", "w") do |csv|
#
#         # write titles of strategies into the csv file
#         if (not csv.nil?)
#           csvTitlesArray = current_simulation.map { |x| x.strategy.strategyName}
#           csvTitlesArray.push("date")
#           csvTitlesArray.push("teamName")
#           csvTitlesArray.push("didDrawSince")
#
#           csv << csvTitlesArray
#         end
#
#         simulation_records_array = Array.new
#         # run each simulation on all dates
#         dates_array.each do |current_date|
#
#           # execute the simulation for the current date
#           team_grades = simulation_runner.get_team_grades(current_simulation, current_date, stay_power)
#           draw_after = simulation_runner.get_draw_after(current_simulation, current_date, stay_power)
#           # this will be the case when we don't have enough previous games for the calculations
#           break if(team_grades.nil? or draw_after.nil?)
#           team, grade = team_grades.first
#           simulation_records_array.push DSRecord.new(team,grade,draw_after,current_date)
#
#         end
#
#         simulation_record_manager = DSSimulationRecordManager.new(simulation_records_array,stay_power)
#         simulation_record_manager.calculate
#
#         # calculate average money gain and average success rate per simulation
#         money_gained_avg = simulation_record_manager.money_gained_avg
#         succeeded_simulations_avg = simulation_record_manager.succeeded_simulations_avg
#
#         # if we should have choose a team today according to this simulation
#         team_to_bet_on = simulation_runner.get_team_grades(current_simulation, today_date, stay_power).first[0]
#
#         print "Simulation " + (index+1).to_s +  ": " + ('%.2f' % money_gained_avg.to_s) + " NIS, " +
#                   ('%.2f' % succeeded_simulations_avg.to_s) + "%, Interest (Tsua'a): " + ('%.2f' %simulation_record_manager.interest_on_money.to_s) + "%,Today: " + team_to_bet_on.team_name + "\n"
#
#         # choose the best simulation
#         if (max_earnings < money_gained_avg)
#           max_earnings = money_gained_avg
#           best_team = team_to_bet_on
#         end
#       end
#     end
#
#     # print the chosen teams
#     print "===============> You better choose: " + best_team.team_name + "\n"
#     end
#   end
# end






