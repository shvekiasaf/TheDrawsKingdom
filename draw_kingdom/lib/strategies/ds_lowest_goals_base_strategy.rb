require_relative 'ds_base_strategy'
require_relative '../../lib/components/ds_season_calculator'
class DSFewestGoalsBaseStrategy < DSBaseStrategy

  def initialize(since = nil)
    if(since.nil?)
      @since = 365
    else
      @since = since
    end
  end

  def getGrade
    @from_date = @due_to_date - @since
    team_games = @file_reader.getAllGamesFor(@team, @from_date, @due_to_date + 365)
    future_games = team_games.select{|game| game.game_date > @due_to_date}.sort {|x,y| x.game_date <=> y.game_date}[0..(@stay_power - 1)]
    # we want enough data: at least stay_power future games and at least stay_power previous games
    return 0 if (team_games.length < (@stay_power * 2) or future_games.length < @stay_power)
    expected_goals = future_games.map { |game| get_goals_for_game(game,team_games) }.reduce(:+)
    DSHelpers.reverse_normalize_value(expected_goals,3 * @stay_power,100.0)
  end




  def get_goals_for_game(game,team_games)
    raise "please implement getGradeForGame in subclass"
  end

  protected :get_goals_for_game
end