require_relative "../strategies/ds_base_strategy"
class DSTeamsDrawRatioStrategy < DSBaseStrategy


  def initialize(since = nil)

    if (since.nil?)
      @since = 999999999
    else
      @since = since
    end

  end

  def execute

    grade = getDrawProportionForTeam()
    return grade
  end

  def getDrawProportionForTeam()
    previous_matches_between_teams = gamesInRangeSameTeams
    if(previous_matches_between_teams.empty?)
      return insufficient_data_for_strategy
    else
      num_previous_draws = previous_matches_between_teams.select { |previous_game| previous_game.isDraw() }.size()
      return num_previous_draws.to_f / previous_matches_between_teams.size().to_f
    end
  end


end
