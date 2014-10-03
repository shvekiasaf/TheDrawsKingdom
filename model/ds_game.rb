require 'date'

class DSGame
  # Readers
  attr_reader :game_date, :home_team, :away_team, :home_score, :away_score

  # Initialize
  def initialize(game_date, home_team, away_team, home_score, away_score)

    @game_date =  DateTime.strptime(game_date, '%d/%m/%y')
    @home_team = home_team
    @away_team = away_team
    @home_score = home_score
    @away_score = away_score
  end

  def isDraw
    @dif = @home_score.to_i - @away_score.to_i
    return (@dif == 0)
  end
end