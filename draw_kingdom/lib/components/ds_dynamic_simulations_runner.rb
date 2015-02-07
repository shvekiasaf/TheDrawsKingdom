require_relative 'ds_file_reader'
require_relative 'ds_csv_manager'
require_relative "../model/ds_record"
require_relative "../insufficient_data_manager"
class DSDynamicSimulationsRunner

  INSUFFICIENT_STRATEGIES_THRESHOLD = 0.3

  # return a hash of games and normalized grades
  def self.calculate_grades_for_games(simulation,games,file_reader, generate_csvs = true)

    csv_manager_instance = generate_csvs ? DsCsvManager.new(file_reader.url_file_name) : DsCsvManagerEmpty.new

    weightSum = simulation.map { |strategy_value| strategy_value.weight}.reduce(:+) # summary of all strategies' weights
    games_grade_hash = {} # hash of normalized grades per game (key:game, value: normalized grade)

    # run on all strategies
    simulation.each do |current_strategy_value|

      games_grade_unnormalized_hash = {} # hash of un-normalized grades per game (key:game, value:un-normalized grade)

      # get a non normalized grade hash per every game
      games.each do |game|

        # load initial data into strategy
        current_strategy_value.strategy.loadStrategyWithData(file_reader, game , simulation)

        # execute the strategy
        grade = current_strategy_value.strategy.execute

        # todo: talk to yeshi
        # is it fine some games won't have a grade
        # in case grade is not nil
        if (!grade.nil?)

          # insert grade into array
          games_grade_unnormalized_hash[game] = grade
        end
      end

      # normalize the grades
      games_grade_normalized_hash = DSHelpers.normalizeHashValues(games_grade_unnormalized_hash,
                                                                  current_strategy_value.strategy.shouldReverseNormalization)

      # adding the normalized grades to the final hash
      games_grade_normalized_hash.each do |key, value|

        csv_manager_instance.add_strategy_with_grade(key, current_strategy_value.strategy.strategyName, value)

        # add the grade to the final hash
        if (!games_grade_hash.has_key?(key)) # on first grade per game
          games_grade_hash[key] = 0
        end

        games_grade_hash[key] += value * current_strategy_value.weight / weightSum
      end
    end

    csv_manager_instance.save_to_csv(simulation.map {|strategy_value| strategy_value.strategy.strategyName})

    # todo: talk to yeshi
    # why clean?
    InsufficientDataManager.instance.clean

    games_grade_hash.select{|game,grade| strategies_sufficient(game,simulation.size)}
  end

  def self.strategies_sufficient(game,number_of_strategies)
    number_of_insufficient_grades = InsufficientDataManager.instance.get_number_of_insufficient_grades(game)
    (number_of_insufficient_grades.to_f / number_of_strategies) < INSUFFICIENT_STRATEGIES_THRESHOLD
  end
end
