require_relative 'ds_file_reader'
require_relative "../model/ds_record"

class DSDynamicSimulationsRunner

  MINIMUM_TEAMS_FOR_BEST_RECORD = 10
  MINIMUM_PREVIOUS_GAMES_FOR_TEAM = 60

  def self.does_best_team_draw(simulation, date, current_file_reader)

    best_record = get_best_record_from_simulation(simulation, date, current_file_reader)

    if (best_record.nil?)
      return nil
    else
      return (best_record.game.isDraw)
    end
  end

  # should_caulculate_odds will not include
  def self.get_best_record_from_simulation(simulation, date, current_file_reader)

    if (current_file_reader.nil?)
      return nil
    else

      # get all the teams from file reader that passed the sufficient data condition
      teams = current_file_reader.teamsHash.values.select{|team| past_team_data_sufficient(team, date, current_file_reader)}

      team_names = teams.map { |team| team.team_name}

      if (teams.nil? || teams.empty? || teams.length < MINIMUM_TEAMS_FOR_BEST_RECORD)

        # no calculation were executed, not enough teams
        return nil
      else

        best_record = nil # this param will hold the best team record with the best simulation score

        games = current_file_reader.getNextGames(date)
        games.each do |next_game|
          # filter game if don't have enough data on one of the teams
          next if (not team_names.include?(next_game.home_team.team_name)) or (not team_names.include?(next_game.away_team.team_name))

          score = get_game_grade(simulation, next_game, current_file_reader)
          # create a record with team, general grade and did draw indicator
          current_record = DSRecord.new(next_game, score)

          # calculating and saving the best team record
          if (best_record.nil? ||
              (best_record.general_score < current_record.general_score))

            best_record = current_record
          end
        end

        if (best_record.nil?)

          #no record has created
          return nil
        end
        return best_record
      end
    end
  end

  def self.get_game_grade(simulation, game, file_reader)

    if (game.nil? || simulation.nil? || simulation.empty? || file_reader.nil?)
      return nil
    else

      weightSum = simulation.map { |strategy_value| strategy_value.weight}.reduce(:+)

      totalGrade = 0
      simulation.each do |current_strategy_value|
        current_strategy_value.strategy.loadStrategyWithData(file_reader, game , simulation)

        # execute the strategy
        grade = current_strategy_value.strategy.execute
        totalGrade += grade * current_strategy_value.weight
      end
    end

    totalGrade = totalGrade.to_f / weightSum

    return totalGrade
  end


  def self.past_team_data_sufficient(team,date,file_reader)

    if (date.nil?)
      return nil
    else
      all_games_for_team = file_reader.getAllGamesFor(team,
                                                      nil, # from date
                                                      date) # to date
      all_games_for_team.size > MINIMUM_PREVIOUS_GAMES_FOR_TEAM
    end
  end

  private_class_method :past_team_data_sufficient

end
