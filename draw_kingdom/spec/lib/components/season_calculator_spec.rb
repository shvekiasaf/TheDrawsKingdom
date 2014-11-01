require 'rspec'
require 'date'
require_relative '../../../../draw_kingdom/lib/model/ds_game'
require_relative '../../../../draw_kingdom/lib/model/ds_team'
require_relative '../../../lib/components/ds_season_calculator'

hapoel = DSTeam.new("hapoel")
maccabi = DSTeam.new("maccabi")
haifa = DSTeam.new("haifa")
beitar = DSTeam.new("beitar")
ashdod = DSTeam.new("ashdod")
tubruk = DSTeam.new("tubruk")

division = "Israel"
allGamesArray = [
    DSGame.new(Date.new(2010, 1, 1), hapoel, haifa, 1, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 2), hapoel, ashdod, 1, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 3), maccabi, tubruk, 0, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 4), hapoel, beitar, 0, 1, nil, division),
    DSGame.new(Date.new(2010, 1, 5), hapoel, ashdod, 0, 1, nil, division),
    DSGame.new(Date.new(2010, 1, 6), haifa,hapoel , 0, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 7), hapoel, haifa, 0, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 8), hapoel, maccabi, 0, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 9),hapoel , ashdod, 0, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 10), maccabi,hapoel , 1, 1, nil, division),
    DSGame.new(Date.new(2010, 1, 11), hapoel, tubruk, 1, 0, nil, division),
    DSGame.new(Date.new(2010, 1, 12), ashdod, beitar, 1, 0, nil, division)
]

describe 'Calculation utils for season' do

  it 'should return 0 for team not in league' do
    DSSeasonCalculator.getAvgHomeTeamGoalsScoredInSeason(allGamesArray,"Not-Israel",DSTeam.new("aaa")).zero?.should be_truthy
    DSSeasonCalculator.getAvgAwayTeamGoalsScoredInSeason(allGamesArray,"Not-Israel",DSTeam.new("aaa")).zero?.should be_truthy
  end
  it 'should count team goals correctly' do

    DSSeasonCalculator.getAvgHomeTeamGoalsScoredInSeason(allGamesArray, division,ashdod).should == 1.0
    DSSeasonCalculator.getAvgAwayTeamGoalsScoredInSeason(allGamesArray, division,ashdod).should == 1.0/3.0
    end

end