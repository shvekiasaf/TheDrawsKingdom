require 'csv'
require 'fileutils'
require_relative "../insufficient_data_manager"
require_relative "ds_dynamic_simulations_runner"

class DsCsvManager

  attr_reader :league_name

  # Initialize
  def initialize(league_name)

    @league_name = league_name

    @games_hash = {}
  end

  def add_strategy_with_grade(game, strategy_name, value)

    if @games_hash.has_key?(game)
      grades_hash = @games_hash[game]
    else
      grades_hash = {}
    end

    grades_hash[strategy_name] = value
    @games_hash[game] = grades_hash
  end

  def save_to_csv(titles_array)

    # todo: talk to yeshi
    # didn't work for me..
    relative_path = File.dirname(File.realpath(__FILE__)) + "/../../"
    return nil if @games_hash.empty?

    CSV.open("csvs//" + @league_name.to_s + ".csv", "w") do |csv|

      # write titles
      csv << ["league", "date", "home", "away"] + titles_array + ["did_draw"]

      games_entries_with_sufficient_data = @games_hash.select { |game, scores_arr| DSDynamicSimulationsRunner.strategies_sufficient(game, scores_arr.size) }
      games_entries_with_sufficient_data.each do |key, value|

        # Put the grades into array using the same order as the titles_array's order.
        # In order to print it later accurately into the CSV file
        grades_array = []
        titles_array.each do |title_strategy_name|

          grade = ""
          value.each do |strategy_name, strategy_grade|
            if (title_strategy_name.eql?strategy_name)
              grade = strategy_grade
              break
            end
          end

          grades_array.push(grade)
        end

        # write the rest of the data
        csv << [@league_name.to_s, key.game_date.to_s, key.home_team.team_name.to_s, key.away_team.team_name.to_s] + grades_array + [(key.isDraw ? "1" : "0")]
      end
    end
  end

end

class DsCsvManagerEmpty < DsCsvManager
  def save_to_csv(titles_array)
  #   do nothing
  end

  def add_strategy_with_grade(game, strategy_name, value)
  #   do nothing
  end

  def initialize
    super(nil)
  end
end