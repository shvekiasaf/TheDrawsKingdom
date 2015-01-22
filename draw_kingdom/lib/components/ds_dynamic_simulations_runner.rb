require_relative 'ds_file_reader'
require_relative "../model/ds_record"

class DSDynamicSimulationsRunner

  MINIMUM_TEAMS_FOR_BEST_RECORD = 10
  MINIMUM_PREVIOUS_GAMES_FOR_TEAM = 60

  def self.does_best_team_draw(simulation, date, current_file_reader)

    best_record = get_best_record_from_simulation(simulation, date, current_file_reader)

    if (best_record.nil?)
      return nil

    elsif (best_record.did_draw_in_next_match.nil?)

      # No expected draw result for chosen best record
      return nil
    else

      return (best_record.did_draw_in_next_match)
    end
  end

  # should_caulculate_odds will not include
  def self.get_best_record_from_simulation(simulation, date, current_file_reader)

    if (current_file_reader.nil?)
      return nil
    else

      # get all the teams from file reader that passed the sufficient data condition
      teams = current_file_reader.teamsHash.values.select{|team| past_team_data_sufficient(team, date, current_file_reader)}

      if (teams.nil? || teams.empty? || teams.length < MINIMUM_TEAMS_FOR_BEST_RECORD)

        # no calculation were executed, not enough teams
        return nil
      else

        best_record = nil # this param will hold the best team record with the best simulation score

        # run the simulation on the chosen teams
        teams.each do |team|

          # find the team's next game according to current date
          next_game = current_file_reader.getNextGameForTeam(team, date)

          next if next_game.nil?

          did_draw = next_game.isDraw

          # calculating team score
          team_score = get_team_grade(simulation, date, team, current_file_reader)

          # create a record with team, general grade and did draw indicator
          current_record = DSRecord.new(team, team_score, did_draw, date)

          # calculating and saving the best team record
          if (best_record.nil? ||
              (best_record.general_score < current_record.general_score))

            best_record = current_record
          end
        end

        if (best_record.nil?)

          #no record has created
          return nil
        else

          # does the best team did draw in the next game?
          return best_record
        end
      end
    end
  end

  def self.get_team_grade(simulation, date, team, file_reader)

    if (team.nil? || date.nil? || simulation.nil? || simulation.empty? || file_reader.nil?)
      return nil
    else

      weightSum = simulation.map { |strategy_value| strategy_value.weight}.reduce(:+)

      totalGrade = 0
      simulation.each do |current_strategy_value|
        current_strategy_value.strategy.loadStrategyWithData(file_reader, team, date, simulation)

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
