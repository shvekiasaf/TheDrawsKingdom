require_relative "components/ds_file_reader"
require_relative "components/ds_simulations_runner"
require_relative "components/ds_simulations_generator"
require_relative "components/ds_helpers"
require_relative "../../draw_kingdom/lib/results/ds_simulation_record_manager"
require_relative "components/ds_dynamic_simulations_runner"
require_relative "noise/ds_noise_cleaners"
require 'date'
require 'csv'
require 'fileutils'
require 'linefit'

module DrawHistogramGenerator

  all_simulations = DSSimulationsGenerator.get_simulations_array

  init_data_store = false

  file_readers = [
      DSFileReader.new("german_urls",init_data_store),
      DSFileReader.new("spanish_urls",init_data_store),
      DSFileReader.new("italian_urls",init_data_store),
      DSFileReader.new("greece_urls",init_data_store),
      DSFileReader.new("belgium_urls",init_data_store),
      DSFileReader.new("frances_urls",init_data_store),
      DSFileReader.new("nethderland_urls",init_data_store),
      DSFileReader.new("portugali_urls",init_data_store),
      DSFileReader.new("turkey_urls",init_data_store),
      DSFileReader.new("english_urls",init_data_store)
  ]

  # for each set of teams from url
  file_readers.each do |current_file_reader|

    filtered_games_array = current_file_reader.games_array.select{|game| game.game_date < Date.today}

    print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
    print "====================================\n"

    all_simulations.each_with_index do |current_simulation, simulation_index|

      total_games_percent_histogram = Hash.new
      success_percent_histogram = Hash.new

      # init histograms
      (0..90).step(10) { |index|
        total_games_percent_histogram[index] = 0
        success_percent_histogram[index] = 0
      }

      # get the normalized grade of all games after executing the simulation strategies
      # its a hash with game as a key and normalized grade for value
      games_grade_hash = DSDynamicSimulationsRunner.calculate_grades_for_games(current_simulation, filtered_games_array, current_file_reader,false)

      # remove games with insufficient data based on the application context
      games_grade_hash = DSNoiseCleaners.remove_insufficient_data(games_grade_hash,current_simulation.size)

      games_grade_hash.each do |game, grade|

        # the histogram index is the grade range:
        histogram_index = (games_grade_hash[game]==100 ? 90 : (games_grade_hash[game] / 10).to_i * 10)

        # success percent histogram value is the number of draws
        success_percent_histogram[histogram_index] +=1 if game.isDraw

        # total percent histogram value is the total number of games
        total_games_percent_histogram[histogram_index] +=1
      end

      def self.histogramIndexValue(index, num_of_games, success_percent_histogram)
        return 0 if num_of_games == 0
        (success_percent_histogram[index].to_f/num_of_games)
      end

      # generate percentage histogram for this simulation.
      simulation_histogram = total_games_percent_histogram.map { |index, num_of_games| [index, histogramIndexValue(index, num_of_games, success_percent_histogram)] }

      # filter entries from histogram with less than 1% of games (noise)
      simulation_histogram = DSNoiseCleaners.remove_vacant_histogram_entries(games_grade_hash,simulation_histogram,success_percent_histogram)

      # printing results
      puts "simulation " + simulation_index.to_s + " results"

      # calculating regression slope & rSquare
      lineFit = LineFit.new
      lineFit.setData(simulation_histogram.map { |current_array| current_array[0]},
                      simulation_histogram.map { |current_array| current_array[1]})

      intercept, slope = lineFit.coefficients
      rSquared = lineFit.rSquared #R-squared is a statistical measure of how close the data are to the fitted regression line. It is also known as the coefficient of determination, or the coefficient of multiple determination for multiple regression.

      print "rSquare: " + ('%.2f' % (rSquared*100).to_s) + "% \n" + "slope: " + ('%.6f' % slope.to_s) + "\n"

      simulation_histogram.each do |index, success_rate|
        num_of_games_with_index = total_games_percent_histogram[index]
        puts index.to_s + "-" + (index+10).to_s + "\t(" + num_of_games_with_index.to_s + " games)\tSuccess Rate: " + ('%.2f' %success_rate.to_s)
      end

      # run the simulation on today's games
      print "Today:\n"
      todays_games = current_file_reader.games_array.select{|game| (game.game_date >= Date.today) && (game.game_date < Date.today + 14)}
      todays_games = current_file_reader.games_array.select{|game| (game.game_date >= Date.today) && (game.game_date < Date.today + 14)}
      games_grade_hash = DSDynamicSimulationsRunner.calculate_grades_for_games(current_simulation, todays_games, current_file_reader,false)

      top_games = games_grade_hash.select {|game, grade| games_grade_hash.values.sort.last(4).include?grade}
      top_games.each do |game, grade|
        print game.home_team.team_name.to_s + " VS " + game.away_team.team_name.to_s + " " + game.game_date.strftime("%d/%m/%Y").to_s + " (" + ('%.2f' %grade.to_s) + ")\n"
      end

      # cleaning insufficient data from context at the end of each simulation so we
      # won't overload memory consumption
      InsufficientDataManager.instance.clean
    end
  end
end