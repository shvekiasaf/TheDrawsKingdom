require 'rspec'
require_relative "../../../lib/strategies/ds_future_games_grader"
require_relative "../../../lib/model/ds_game"
require_relative "../../../lib/model/ds_team"

hapoel = DSTeam.new("hapoel")
maccabi = DSTeam.new("maccabi")
haifa = DSTeam.new("haifa")
beitar = DSTeam.new("beitar")
ashdod = DSTeam.new("ashdod")
tubruk = DSTeam.new("tubruk")

describe "Calculate Draw Ratio" do
  it 'should be accurate' do
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
    grade = DSFutureGamesGrader.new(allGamesArray[10..10], allGamesArray, Date.new(2010, 1, 10)).getGrade
    grade.should == 0.0

    grade = DSFutureGamesGrader.new(allGamesArray[9..9], allGamesArray, Date.new(2010, 1, 10)).getGrade
    grade.should == 1.0

    grade = DSFutureGamesGrader.new(allGamesArray[11..11], allGamesArray, Date.new(2010, 1, 10)).getGrade
    grade.should == 0.0

    grade = DSFutureGamesGrader.new(allGamesArray[8..8], allGamesArray, Date.new(2010, 1, 8)).getGrade
    grade.should == 0.5
  end
end