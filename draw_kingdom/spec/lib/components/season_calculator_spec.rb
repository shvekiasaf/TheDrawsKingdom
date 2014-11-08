require 'rspec'
require 'date'
require_relative '../../../../draw_kingdom/lib/model/ds_game'
require_relative '../../../../draw_kingdom/lib/model/ds_team'
require_relative '../../../lib/components/ds_season_calculator'
require_relative '../../../lib/components/ds_file_reader'

def getTestedTeam
  allGamesArray.select { |game| game.home_team.team_name.eql? RSpec.current_example.description}[0].home_team
end
describe 'Calculation utils for season' do

  let(:allGamesArray) {allGamesArray = DSFileReader.new("test_vectors",true).games_array.sort {|x,y| x.game_date <=> y.game_date}}
  let(:due_to_date) {due_to_date = allGamesArray.last.game_date+ 1}
  let(:from_date) {from_date = allGamesArray[0].game_date }
  it 'no_scoring' do
    DSSeasonCalculator.getAvgHomeTeamGoalsScored(allGamesArray,from_date,due_to_date,getTestedTeam).zero?.should be_truthy
    DSSeasonCalculator.getAvgHomeTeamGoalsScored(allGamesArray,from_date,due_to_date,getTestedTeam).zero?.should be_truthy
  end

  it '66_home_33_away' do
    DSSeasonCalculator.getAvgHomeTeamGoalsScored(allGamesArray,from_date,due_to_date,getTestedTeam).should == 4.0/6
    DSSeasonCalculator.getAvgAwayTeamGoalsScored(allGamesArray,from_date,due_to_date,getTestedTeam).should == 1.0/3
  end


end