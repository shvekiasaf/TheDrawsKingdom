require_relative "../components/ds_file_reader"

class DSBaseStrategy

  def loadGamesAndTeam(file_reader, team, due_to_date)

    @due_to_date = due_to_date

    @file_reader = file_reader

    @all_team_games  = @file_reader.getAllGamesFor(team, Date.parse('01-01-1804'), due_to_date)

    @team = team
  end

  # Grade will be a number between 0 to 100
  def getGrade; raise "You must implement the method, this is an abstract class" ; end

  # With given grade it will return the grade in range from 0 to 100
  def normalizeGrade(grade, range)

    return  ((grade >= range ? range : grade) / range) * 100.0
  end

end