require_relative "../components/ds_file_reader"
require_relative "../components/ds_helpers"

class DSBaseStrategy

  def loadStrategyWithData(file_reader, team, due_to_date, strategies)

    @due_to_date = due_to_date

    @file_reader = file_reader

    @all_team_games  = @file_reader.getAllGamesFor(team, Date.parse('01-01-1804'), due_to_date)

    @team = team

    @strategies = strategies

  end

  # Grade will be a number between 0 to 100
  def execute; raise "You must implement the method, this is an abstract class" ; end

  # With given grade it will return the grade in range from 0 to 100
  def normalizeGrade(grade, range)

    return  DSHelpers.normalize_value(grade,range,100.0)
  end

  def shouldRunWhenTreatingArrivals
    return true
  end

  def strategyName
    return self.class.name
  end

  protected :normalizeGrade

end