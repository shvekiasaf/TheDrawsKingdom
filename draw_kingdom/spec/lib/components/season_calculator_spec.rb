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

  let(:allGamesArray) {allGamesArray = DSFileReader.new("test_vectors").games_array}
  let(:season) {'Lowest_Score_Concede.csv'}
  it 'no_scoring' do
    DSSeasonCalculator.getAvgHomeTeamGoalsScoredInSeason(allGamesArray,season,getTestedTeam).zero?.should be_truthy
    DSSeasonCalculator.getAvgHomeTeamGoalsScoredInSeason(allGamesArray,season,getTestedTeam).zero?.should be_truthy
  end

  it '66_home_33_away' do
    DSSeasonCalculator.getAvgHomeTeamGoalsScoredInSeason(allGamesArray,season,getTestedTeam).should == 4.0/6
    DSSeasonCalculator.getAvgAwayTeamGoalsScoredInSeason(allGamesArray,season,getTestedTeam).should == 1.0/3
  end


end