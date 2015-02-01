require 'csv'
require 'fileutils'

# todo: add simulation name to the csv file. We are currently overriding simulations :/
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

  def save_to_csv
    relative_path = File.dirname(File.realpath(__FILE__)) + "/../../"
    return nil if @games_hash.empty?

    CSV.open(relative_path + "csvs/" + @league_name.to_s + ".csv", "w") do |csv|

      key, value = @games_hash.first
      strategies_array = value.keys

      # write titles
      csv << ["league", "date", "home", "away"] + strategies_array + ["did_draw"]

      @games_hash.each do |key, value|

        # write the rest of the data
        csv << [@league_name.to_s, key.game_date.to_s, key.home_team.team_name.to_s, key.away_team.team_name.to_s] + value.values + [(key.isDraw ? "1" : "0")]
      end
    end
  end
end