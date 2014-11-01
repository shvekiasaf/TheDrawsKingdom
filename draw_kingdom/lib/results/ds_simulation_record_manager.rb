class DSSimulationRecordManager

  attr_reader :money_gained_avg, :succeeded_simulations_avg

  def initialize(records, stay_power, initial_bet_money = 10)
    @records = records
    @stay_power = stay_power
    @initial_bet_money = initial_bet_money
  end

  def calculate
    if @records.empty?
      @money_gained_avg = 0
      @succeeded_simulations_avg = 0
      return
    end
    succeeded_simulations = 0
    money_gained = 0
    @records.each do |current_record|
      # summarize success
      succeeded_simulations += (current_record.did_draw_since == true) ? 1 : 0

      # calculate profit according to
      money_gained += (current_record.draw_after_attempt == -1) ? -1 * @initial_bet_money * ((2 ** @stay_power) - 1) # loss
      : (2.5 * @initial_bet_money * (2 ** (current_record.draw_after_attempt - 1))) - (@initial_bet_money * ((2 ** current_record.draw_after_attempt) - 1)) # win
    end
    # calculate average money gain and average success rate per simulation
    @money_gained_avg = (money_gained / @records.count)
    @succeeded_simulations_avg = (100 * succeeded_simulations / @records.count)
  end


end