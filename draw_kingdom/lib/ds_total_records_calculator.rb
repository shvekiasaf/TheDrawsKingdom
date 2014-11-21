require_relative "components/ds_file_reader"
require_relative 'components/ds_helpers'
class DSTotalRecordsCalculator
  def initialize
    @stay_power = 5 # stay power - the number of bets you agree to risk in a row
    today_date = Date.parse("20-11-2014") # define the date of the simulation dd-mm-yyyy
    @dates_array = DSHelpers.get_dates_before_date(200, today_date) # get an array of dates
    @initial_bet_money = 10

    @file_readers = [
        DSFileReader.new("german_urls"),
        DSFileReader.new("spanish_urls"),
        DSFileReader.new("italian_urls"),
        DSFileReader.new("greece_urls"),
        DSFileReader.new("belgium_urls"),
        DSFileReader.new("frances_urls"),
        DSFileReader.new("nethderland_urls"),
        DSFileReader.new("portugali_urls"),
        DSFileReader.new("turkey_urls"),
        DSFileReader.new("english_urls")
    ]

  end
  def calculate_results_for_all_records
    results = @file_readers.map { |file_reader| calculate_results_for_file_reader(file_reader) }
    total_income = results.map { |result|result[0]}.reduce(:+)
    total_expense = results.map { |result|result[1]}.reduce(:+)
    puts "profit: " + (total_income - total_expense).to_s
    puts "interest: " + (total_income.to_f / total_expense).to_s
  end

  def calculate_results_for_file_reader(file_reader)
    total_income = 0
    total_expense = 0
    @dates_array.each do |today_date|


      file_reader.teamsHash.each do |team_name, team_object|


        # get all team's games until now
        all_games_for_team = file_reader.getAllGamesFor(team_object,
                                                        nil, # from date
                                                        today_date) # to date

        if (not all_games_for_team.nil?)

          # only teams with more than 100 games in history will be checked
          if (all_games_for_team.count > 100)

            # if had a draw in the following X games, then - on what attempt. else = -1
            draw_after_attempt = get_draw_after_attempt_indicator(team_object, today_date, @stay_power,file_reader)
            simulation_succeeded = (draw_after_attempt != -1)
            income = simulation_succeeded ? (2.5 * @initial_bet_money * (2 ** (draw_after_attempt - 1))) : 0
            expense = simulation_succeeded ? @initial_bet_money * ((2 ** draw_after_attempt) - 1) : @initial_bet_money * ((2 ** @stay_power) - 1)
            total_income += income
            total_expense += expense
          end
        end
      end
    end
    return total_income, total_expense
  end

  def get_draw_after_attempt_indicator(team_object, due_to_date, stay_power,file_reader)
    # Check whether team has a draw or not in X number of games after custom date
    some_games_for_team = file_reader.getSomeGamesForTeam(team_object, due_to_date, stay_power).reverse
    did_draw_since = false
    draw_after_attempt = 0

    # count the number of draws since date
    some_games_for_team.each do |current_game|
      draw_after_attempt += 1
      if (current_game.isDraw)
        did_draw_since = true
        break
      end
    end
    if (did_draw_since != true)
      draw_after_attempt = -1
    end

    return draw_after_attempt
  end


  private :calculate_results_for_file_reader, :get_draw_after_attempt_indicator
end

calculator = DSTotalRecordsCalculator.new
calculator.calculate_results_for_all_records
