
require_relative "../components/ds_file_reader"

class DSBaseStrategy

  # Readers
  attr_reader :file_reader

  # Initialize
  def initialize(all_team_games, team)
    @all_team_games = all_team_games
    @team = team
  end

  # Grade will be a number between 0 to 100
  def getGrade; raise "You must implement the method, this is an abstract class" ; end

  # With given grade it will return the grade in range from 0 to 100
  def normalizeGrade(grade, range)

    return  ((grade >= range ? range : grade) / range) * 100.0
  end

end