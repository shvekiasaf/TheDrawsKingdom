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
TODAY_DATE = "22-01-2015"

module DrawKingdom

  today_date      = Date.parse(TODAY_DATE) # define the date of the simulation dd-mm-yyyy
  dates_array     = DSHelpers.get_dates_before_date(NUMBER_OF_DATES, today_date) # get an array of dates
  all_simulations = DSSimulationsGenerator.get_simulations_array
  # file_readers    = [DSFileReader.new("frances_urls",true),
  #                    DSFileReader.new("italian_urls",true),
  #                    DSFileReader.new("german_urls",true),
  #                    DSFileReader.new("spanish_urls",true)]

  # #Read all games from file
  file_readers = [
      DSFileReader.new("german_urls",true),
      DSFileReader.new("spanish_urls",true),
      DSFileReader.new("italian_urls",true),
      DSFileReader.new("greece_urls",true),
      DSFileReader.new("belgium_urls",true),
      DSFileReader.new("frances_urls",true),
      DSFileReader.new("nethderland_urls",true),
      DSFileReader.new("portugali_urls",true),
      DSFileReader.new("turkey_urls",true),
      DSFileReader.new("english_urls",true)
  ]

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
      best_record = DSDynamicSimulationsRunner.get_best_record_from_simulation(best_simulation, today_date, current_file_reader)

      # print the selected team and the success rate of the simulation
      print best_record.team_object.team_name.to_s + ", " + ('%.2f' % best_simulation_success_rate.to_s) + "\n"

    end
  end
end







