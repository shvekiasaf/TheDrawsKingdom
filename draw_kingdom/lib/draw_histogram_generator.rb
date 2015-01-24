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
module DrawHistogramGenerator

  all_simulations = DSSimulationsGenerator.get_simulations_array

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


  # for each set of teams from url
  file_readers.each do |current_file_reader|

    print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
    print "====================================\n"

    all_simulations.each_with_index do |current_simulation, simulation_index|
      total_games_percent_histogram = Hash.new
      success_percent_histogram = Hash.new

      # init histograms
      (0..100).step(10) { |index|
        total_games_percent_histogram[index] = 0
        success_percent_histogram[index] = 0
      }

      # grade all games in the past and place them in the histograms
      current_file_reader.games_array.select{|game| game.game_date < Date.today}.each do |game|

        game_grade = DSDynamicSimulationsRunner.get_game_grade(current_simulation, game, current_file_reader)
        histogram_index = (game_grade / 10).to_i * 10
        success_percent_histogram[histogram_index] +=1 if game.isDraw
        total_games_percent_histogram[histogram_index] +=1
      end

      def self.histogramIndexValue(index, num_of_games, success_percent_histogram)
        return 0 if num_of_games == 0
        (success_percent_histogram[index].to_f/num_of_games)
      end
      # generate percentage histogram for this simulation.
      simulation_histogram = total_games_percent_histogram.map { |index, num_of_games| [index, histogramIndexValue(index, num_of_games, success_percent_histogram)] }
      puts "simulation " + simulation_index.to_s + " results"
      simulation_histogram.each do |index, success_rate|
        num_of_games_with_index = total_games_percent_histogram[index]
        puts num_of_games_with_index.to_s + " games under " + index.to_s + "%. Success Rate: " + ('%.2f' %success_rate.to_s)
      end
    end

  end



end