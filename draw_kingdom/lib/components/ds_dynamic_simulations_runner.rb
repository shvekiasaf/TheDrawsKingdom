require_relative 'ds_file_reader'
require_relative "../model/ds_record"

class DSDynamicSimulationsRunner

  def initialize
  end

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

      if (teams.nil? || teams.empty? || teams.length < 10)

        # no calculation were executed, not enough teams
        return nil
      else

        best_record = nil # this param will hold the best team record with the best simulation score

        # run the simulation on the chosen teams
        teams.each do |team|

          # find the team's next game according to current date
          nextGameArray = current_file_reader.getSomeGamesForTeam(team, date, 1)

          if (nextGameArray.empty?)
            # no next game data for current team for this date
          else
            # check if the team got a draw result in its next game
            did_draw = nextGameArray[0].isDraw

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
      all_games_for_team.size > 60
    end
  end

  private_class_method :past_team_data_sufficient

  #
  # def self.game_for_next_bet(all_teams_next_games, game_bet_index, stay_power, strategies)
  #   next_simulation_date = get_next_simulation_date(all_teams_next_games, game_bet_index)
  #   team_grades = get_team_grades(strategies, next_simulation_date, stay_power)
  #   team_grades.each do |team, grade|
  #     if(not (all_teams_next_games[team].nil? or all_teams_next_games[team][game_bet_index].nil?))
  #       return (all_teams_next_games[team][game_bet_index])
  #     end
  #   end
  # end
  #
  # # gets the next date to run the simulation on.
  # # in fact it goes to the next round of games, takes the earliest game and takes
  # # 1 day before
  # def self.get_next_simulation_date(all_teams_next_games, game_bet_index)
  #   latest_game_for_bet_index = all_teams_next_games.map { |team, next_games| next_games[game_bet_index] }.
  #       min_by { |game| game.game_date }
  #   latest_game_for_bet_index.game_date - 1
  # end
  # def get_team_grades(strategies, date, stay_power)
  #   weightSum = strategies.map { |strategy_value| strategy_value.weight}.reduce(:+)
  #   teams = @file_reader.teamsHash.values.select{|team| past_team_data_sufficient(team,date)}
  #   team_grades = Hash.new
  #   return nil if teams.empty?
  #   teams.each do |team|
  #     totalGrade = 0
  #     strategies.each do |current_strategy_value|
  #       current_strategy_value.strategy.loadGamesAndTeam(@file_reader, team, date, strategies, stay_power)
  #       grade = current_strategy_value.strategy.getGrade
  #       totalGrade += grade * current_strategy_value.weight
  #     end
  #
  #     team_grades[team] = totalGrade.to_f/weightSum
  #   end
  #   # DESCENDING sort by grade
  #   team_grades.sort_by {|team, grade| grade}.reverse
  # end
  #
  # def get_draw_after(strategies, start_date, stay_power)
  #
  #   teams = @file_reader.teamsHash.values
  #
  #   # all_teams_next_games = hash of [team -> future team games].
  #   all_teams_next_games = Hash[teams.
  #                                   map { |team| [team, @file_reader.getSomeGamesForTeam(team, start_date, (stay_power * 2)).reverse] }].
  #       select{|team,future_games| future_team_data_sufficient(team,future_games,start_date, stay_power) }
  #
  #   # in compliance with static algorithm
  #   return nil if all_teams_next_games.empty?
  #   1.upto(stay_power) { |game_bet_index|
  #     next_team_game = game_for_next_bet(all_teams_next_games, game_bet_index, stay_power, strategies)
  #     return game_bet_index if next_team_game.isDraw
  #   }
  #   # failed in predicting for all stay_power games (what a loser...)
  #   return -1
  # end
  #
  #
  # # helper functions
  #

  #
  # def future_team_data_sufficient(team, future_games, date, stay_power)
  #   minimal_future_games_amount = stay_power * 2
  #   future_games.size == minimal_future_games_amount and past_team_data_sufficient(team,date)
  # end
  #

  #
  #



end
