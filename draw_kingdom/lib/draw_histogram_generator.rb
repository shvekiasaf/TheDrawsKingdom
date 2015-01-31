require_relative "components/ds_file_reader"
require_relative "components/ds_simulations_runner"
require_relative "components/ds_simulations_generator"
require_relative "components/ds_helpers"
require_relative "../../draw_kingdom/lib/results/ds_simulation_record_manager"
require_relative "components/ds_dynamic_simulations_runner"
require 'date'
require 'csv'
require 'fileutils'
require 'linefit'

NUMBER_OF_DATES = 200
module DrawHistogramGenerator

  all_simulations = DSSimulationsGenerator.get_simulations_array



  file_readers = [
      DSFileReader.new("german_urls"),
      DSFileReader.new("spanish_urls"),
      DSFileReader.new("italian_urls"),
      # DSFileReader.new("greece_urls"),
      # DSFileReader.new("belgium_urls"),
      # DSFileReader.new("frances_urls"),
      # DSFileReader.new("nethderland_urls"),
      # DSFileReader.new("portugali_urls"),
      # DSFileReader.new("turkey_urls"),
      # DSFileReader.new("english_urls")
  ]


  # for each set of teams from url
  file_readers.each do |current_file_reader|

    #todo: deselect games from bottom of the array, we need previous data for games so we shouldn't calculate grades for these games
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
      games_grade_hash = DSDynamicSimulationsRunner.calculate_grades_for_games(current_simulation, filtered_games_array, current_file_reader)

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
    end
  end
end