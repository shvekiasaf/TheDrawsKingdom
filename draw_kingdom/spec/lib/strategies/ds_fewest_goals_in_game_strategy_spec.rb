require 'rspec'
require_relative '../../../lib/strategies/ds_fewest_goals_in_game_strategy'

describe DSFewestGoalsInGameStrategy do

  let(:file_reader) {file_reader = DSFileReader.new("test_vectors",true)}
  let(:allGamesArray) {allGamesArray = file_reader.games_array.sort {|x,y| x.game_date <=> y.game_date}}
  let(:stay_power) {stay_power = 2}
  let(:due_to_date) {due_to_date = allGamesArray[allGamesArray.length - stay_power].game_date+ 1}
  it 'tested_team' do
    tested_team = file_reader.teamsHash[RSpec.current_example.description]
    all_team_games = allGamesArray.select { |game| game.home_team.eql? tested_team or game.away_team.eql? tested_team }
    test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
    subject.loadGamesAndTeam(file_reader, tested_team, test_date,nil,stay_power)
    subject.getGrade.should == 100 * (1.0/14)
  end
end