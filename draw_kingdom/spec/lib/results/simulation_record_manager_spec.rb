require 'rspec'
require 'date'
require_relative '../../../../draw_kingdom/lib/results/ds_simulation_record_manager'
require_relative '../../../../draw_kingdom/lib/model/ds_record'
require_relative '../../../../draw_kingdom/lib/model/ds_team'

spec_team = DSTeam.new("bet she'an")
spec_records = [DSRecord.new(spec_team, 0.0, 1, Date.new(2010, 1, 1))]

describe DSSimulationRecordManager do

  it 'should return 0 with no records' do
    record_manager = DSSimulationRecordManager.new(Array.new,5)
    record_manager.calculate
    record_manager.money_gained_avg.zero?.should be_truthy
    record_manager.succeeded_simulations_avg.zero?.should be_truthy
  end

  it 'should return profit of initial be for single record' do
    record_manager = DSSimulationRecordManager.new(spec_records[0..0],5,10)
    record_manager.calculate
    record_manager.money_gained_avg.should == 15
    record_manager.succeeded_simulations_avg.should  == 100
  end
end