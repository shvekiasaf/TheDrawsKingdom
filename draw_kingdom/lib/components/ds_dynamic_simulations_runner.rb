require_relative 'ds_file_reader'
require_relative 'ds_csv_manager'
require_relative "../model/ds_record"
require_relative "../insufficient_data_manager"
class DSDynamicSimulationsRunner

  INSUFFICIENT_STRATEGIES_THRESHOLD = 0.3

  # return a hash of games and normalized grades
  def self.calculate_grades_for_games(simulation,games,file_reader, generate_csvs = true)

    csv_manager_instance = generate_csvs ? DsCsvManager.new(file_reader.url_file_name) : DsCsvManagerEmpty.new

    games_grade_hash = {} # hash of normalized grades per game (key:game, value: normalized grade)

    # will hold RELEVANT weights for strategies
    total_weights_for_games = Hash[games.collect{ |game|[game,0]}]

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
        if (!games_grade_normalized_hash.nil?)

          # adding the normalized grades to the final hash
          games_grade_normalized_hash.each do |game, strategy_normalized_grade|

            csv_manager_instance.add_strategy_with_grade(game, current_strategy_value.strategy.strategyName, strategy_normalized_grade)

            # add the grade to the final hash
            if (!games_grade_hash.has_key?(game)) # on first grade per game
              games_grade_hash[game] = 0
            end

            # todo talk to shveki
            # we are currently dividing by the total sum of weights - but there are strategies that we ignore
            # due to insufficient data. we ignore them using the total_weights_for_games
            games_grade_hash[game] += strategy_normalized_grade * current_strategy_value.weight
            total_weights_for_games[game] += current_strategy_value.weight
          end
        end
    end

    # now we divide grades by correct proportion
    games_grade_hash = games_grade_hash.each {| game, not_proportional_grade| games_grade_hash[game] = not_proportional_grade.to_f / total_weights_for_games[game] }
    csv_manager_instance.save_to_csv(simulation.map {|strategy_value| strategy_value.strategy.strategyName})

    # todo: talk to shveki
    # because this is called for each file reader. if we don't perform cleanup, the context will store the games from other
    # file readers in memory throughout the program execution - significantly increasing our memory footprint
    # and possibly harming performance.
    # if you are OK with this lets remove the comment. if not - lets talk
    InsufficientDataManager.instance.clean

    games_grade_hash.select{|game,grade| strategies_sufficient(game,simulation.size)}
  end

  def self.strategies_sufficient(game,number_of_strategies)
    number_of_insufficient_grades = InsufficientDataManager.instance.get_number_of_insufficient_grades(game)
    (number_of_insufficient_grades.to_f / number_of_strategies) < INSUFFICIENT_STRATEGIES_THRESHOLD
  end
end
