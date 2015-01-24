require_relative "../components/ds_file_reader"
require_relative "../components/ds_helpers"

class DSBaseStrategy

  def loadStrategyWithData(file_reader, game, strategies)

    @file_reader = file_reader

    @game = game

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

  def gamesInRange
    @file_reader.games_array.select{|game| game.game_date < @game.game_date}
  end

  def gamesInRangeSameTeams
    gamesInRange.select{|game| @game.isSameTeams(game)}
  end
  protected :normalizeGrade

end