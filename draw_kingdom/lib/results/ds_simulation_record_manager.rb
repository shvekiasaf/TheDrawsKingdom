class DSSimulationRecordManager

  attr_reader :money_gained_avg, :succeeded_simulations_avg, :interest_on_money

  def initialize(records, stay_power, initial_bet_money = 10)
    @records = records
    @stay_power = stay_power
    @initial_bet_money = initial_bet_money
  end

  def calculate
    if @records.nil? or @records.empty?
      @money_gained_avg = 0
      @succeeded_simulations_avg = 0
      @interest_on_money = 0
      return
    end
    succeeded_simulations = 0
    money_gained = 0
    total_income = 0
    total_expence = 0
    @records.each do |current_record|
      # summarize success
      succeeded_simulations += (current_record.did_draw_since == true) ? 1 : 0

      # calculate profit according to
      simulation_succeeded = (current_record.draw_after_attempt != -1)
      income = simulation_succeeded ? (2.5 * @initial_bet_money * (2 ** (current_record.draw_after_attempt - 1))) : 0
      expense = simulation_succeeded ? @initial_bet_money * ((2 ** current_record.draw_after_attempt) - 1) : @initial_bet_money * ((2 ** @stay_power) - 1)
      money_gained += (income - expense)
      total_income += income
      total_expence += expense
    end

    # calculate average money gain and average success rate per simulation
    @money_gained_avg = (money_gained / @records.count.to_f)
    @succeeded_simulations_avg = (100.0 * succeeded_simulations.to_f / @records.count)
    @interest_on_money = 100 * ((total_income.to_f - total_expence.to_f)/total_expence.to_f)
  end


end