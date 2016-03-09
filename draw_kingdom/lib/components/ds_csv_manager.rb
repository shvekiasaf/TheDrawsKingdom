require 'csv'
require_relative "../../../draw_kingdom/lib/model/ds_grades_container"

class DsCsvManager

  # csv with Game object as Grades Container as value
  def self.save_to_csv(csv_hashmap, filename)

    # relative_path = File.dirname(File.realpath(__FILE__)) + "/../../"

    return nil if csv_hashmap.empty?

    first_game, first_grade_container = csv_hashmap.first
    titles = first_grade_container.container.keys # all strategies

    CSV.open("../" + filename.to_s + ".csv", "w") do |csv|

      # enter titles
      csv << ["date", "league", "home", "away"] + titles

      # print all game & grades values to CSV
      csv_hashmap.each do |game, grades_container|

        csv << [game.game_date.to_s, game.league.to_s, game.home_team.team_name.to_s, game.away_team.team_name.to_s] + grades_container.container.values
      end

    end
  end
end