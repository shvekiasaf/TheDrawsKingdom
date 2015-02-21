class DSNoiseCleaners

  INSUFFICIENT_STRATEGIES_THRESHOLD = 0.3

  def self.remove_insufficient_data(game_grades_hash, number_of_strategies)
    def self.strategies_sufficient(game,number_of_strategies)
      number_of_insufficient_grades = InsufficientDataManager.instance.get_number_of_insufficient_grades(game)
      (number_of_insufficient_grades.to_f / number_of_strategies) < INSUFFICIENT_STRATEGIES_THRESHOLD
    end
    game_grades_hash.select{|game,grade| strategies_sufficient(game,number_of_strategies)}
  end


  AMOUNT_OF_HISTOGRAM_ENTRIES_THRESHOLD = 0.01
  def self.remove_vacant_histogram_entries(games_grade_hash, simulation_histogram,success_percent_histogram)
    amount_of_games = games_grade_hash.keys.size
    simulation_histogram.select{|index, success_rate|
      success_percent_histogram[index].to_f/amount_of_games > AMOUNT_OF_HISTOGRAM_ENTRIES_THRESHOLD}
  end

end