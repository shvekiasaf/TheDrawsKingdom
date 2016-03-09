require_relative "components/ds_file_reader"
require_relative "components/ds_simulations_runner"
require_relative "components/ds_simulations_generator"
require_relative "components/ds_strategies_generator"
require_relative "components/ds_helpers"
require_relative "../../draw_kingdom/lib/results/ds_simulation_record_manager"
require_relative "components/ds_dynamic_simulations_runner"
require_relative "noise/ds_noise_cleaners"
require_relative "model/ds_grades_container"
require_relative "../../draw_kingdom/lib/components/ds_csv_manager"
require 'date'
require 'csv'
require 'fileutils'
require 'linefit'


module DrawHistogramGenerator

  should_init_data_store = false

  file_readers = [
      # DSFileReader.new("german_urls",should_init_data_store ),
      # DSFileReader.new("spanish_urls",should_init_data_store ),
      # DSFileReader.new("italian_urls",should_init_data_store ),
      # DSFileReader.new("greece_urls",should_init_data_store ),
      # DSFileReader.new("belgium_urls",should_init_data_store ),
      DSFileReader.new("frances_urls",should_init_data_store ),
      # DSFileReader.new("nethderland_urls",should_init_data_store ),
      # DSFileReader.new("portugali_urls",should_init_data_store ),
      # DSFileReader.new("turkey_urls",should_init_data_store ),
      # DSFileReader.new("english_urls",should_init_data_store )
  ]

  all_grades = {}

  # for each set of teams from url
  file_readers.each do |current_file_reader|

    filtered_games_array = current_file_reader.games_array.select{|game| ! game.missing_score}

    print "\nCalculating odds for " + current_file_reader.url_file_name + "\n"
    print "====================================\n"

    filtered_games_array.each do |game|

      grades_container = DSGradesContainer.new()
      is_valid_game = true

      # add to container whether or not was a draw
      grades_container.addResult(game.isDraw())

      DSStrategiesGenerator.get_strategies_array.each do |current_strategy|

        # load initial data into strategy
        current_strategy.loadStrategyWithData(current_file_reader, game , nil)

        # execute the strategy
        grade = current_strategy.execute

        # all grades should have data
        is_valid_game = (grade != nil)

        # insert grade into master array
        grades_container.addGrade(grade, current_strategy)

      end

      # remove insufficient games
      is_valid_game = false if InsufficientDataManager.instance.get_number_of_insufficient_grades(game) > 0

      if (is_valid_game)

        all_grades[game] = grades_container
      end

      ## un comment to make a short run
      # if (all_grades.length > 50)
      #   break
      # end
    end
  end

  print "Total of " + all_grades.length.to_s + " games"
  DsCsvManager.save_to_csv(all_grades, "all_results")
  print "\n"

end