require_relative "../strategies/ds_base_strategy"


class DSArrivalsStrategy < DSBaseStrategy

  @@teamsWithStrategyToGrade = {}

  def getGrade

    # create hash key
    baseKey = @due_to_date.to_s

    strategiesWithoutCurrentStrategy = Array.new
    # Building new strategies array to prevent an endless recursive
    @strategies.each do |current_strategy_value|

      if (current_strategy_value.strategy.shouldRunWhenTreatingArrivals)
        strategiesWithoutCurrentStrategy.push(current_strategy_value)

        baseKey += current_strategy_value.strategy.class.name + current_strategy_value.weight.to_s
      end
    end

      totalGradeOfAllArrivals = 0

      # get all next arrivals for the current team
      some_games_for_team = @file_reader.getSomeGamesForTeam(@team, @due_to_date, @stay_power)

      some_games_for_team.each do |current_game|

        arrival_team = nil
        if (current_game.home_team.team_name.eql? @team.team_name)
          arrival_team = current_game.away_team
        else
          arrival_team = current_game.home_team
        end

        key = baseKey + arrival_team.team_name

        if (not @@teamsWithStrategyToGrade.key?(key))

          totalGradePerTeam = 0
          weightSum = 0

          # run all strategies on arrival team
          strategiesWithoutCurrentStrategy.each do |current_strategy_value|

            # set all teams and team object for current strategy
            current_strategy_value.strategy.loadGamesAndTeam(@file_reader, arrival_team, @due_to_date, strategiesWithoutCurrentStrategy, @stay_power)

            # calculate the current strategy grade
            tempgrade = current_strategy_value.strategy.getGrade.abs

            totalGradePerTeam += tempgrade * current_strategy_value.weight
            weightSum += current_strategy_value.weight
          end

          totalGradePerTeam /= weightSum

          @@teamsWithStrategyToGrade[key] = totalGradePerTeam
        else

          totalGradePerTeam = @@teamsWithStrategyToGrade[key]
        end

        # summarize all grades from all strategies per each team
        totalGradeOfAllArrivals += totalGradePerTeam

        key = ""
      end

      averageArrivalsGrade = 0
      if (some_games_for_team.length > 0)

        # calculating the average score of all arrival's grades
        averageArrivalsGrade = totalGradeOfAllArrivals / some_games_for_team.length
      end


      # print @team.team_name + " score: " + averageArrivalsGrade.to_s + " " + @due_to_date.to_s + " " + " key: " +key + "\n"

      # already normalized so we can just use the grade as is
      return averageArrivalsGrade
  end

  def shouldRunWhenTreatingArrivals
    return false
  end
end