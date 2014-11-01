require 'rspec'
require_relative "../../../lib/strategies/ds_future_games_grader"
require_relative "../../../lib/model/ds_team"
require_relative "../../../lib/model/ds_game"

hapoel = DSTeam.new("hapoel")
maccabi = DSTeam.new("maccabi")
haifa = DSTeam.new("haifa")
beitar = DSTeam.new("beitar")
ashdod = DSTeam.new("ashdod")
tubruk = DSTeam.new("tubruk")

allGamesArray = [
    DSGame.new(Date.new(2010, 1, 1), hapoel, haifa, 1, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 2), hapoel, ashdod, 1, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 3), hapoel, maccabi, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 4), hapoel, beitar, 0, 1, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 5), hapoel, ashdod, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 6), hapoel, haifa, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 7), hapoel, haifa, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 8), hapoel, maccabi, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 9), hapoel, ashdod, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 10), hapoel, maccabi, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 11), hapoel, tubruk, 0, 0, nil, "Israel"),
    DSGame.new(Date.new(2010, 1, 12), hapoel, beitar, 0, 0, nil, "Israel")
]

describe DSFutureGamesGrader do
  it 'should give 0 with no previous game' do
    grade = DSFutureGamesGrader.new(allGamesArray[0..10], Date.new(2010, 1, 10)).getGrade
    grade.should == 0.0
  end
  it 'should give 1.0 with only draws'do
    grade = DSFutureGamesGrader.new(allGamesArray[0..7], Date.new(2010, 1, 7)).getGrade
    grade.should == 1.0
  end
  it 'should give 0.0 with only non-draws'do
    grade = DSFutureGamesGrader.new(allGamesArray[0..5], Date.new(2010, 1, 5)).getGrade
    grade.should == 0.0
  end
  it 'should give 0.5 with draws in 50% of the games'do
    grade = DSFutureGamesGrader.new(allGamesArray[0..6], Date.new(2010, 1, 6)).getGrade
    grade.should == 0.5
  end
end