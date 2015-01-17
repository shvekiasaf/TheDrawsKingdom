require 'rspec'
require_relative '../../../lib/strategies/ds_lowest_scoring_strategy'
require_relative '../../../lib/components/ds_file_reader'
require_relative '../../../lib/strategies/ds_lowest_conceding_strategy'
require_relative '../../../../draw_kingdom/lib/model/ds_team'

def getTestedTeam
  file_reader.teamsHash.values.select { |team| team.team_name.eql? RSpec.current_example.description }[0]
end
describe 'general spec' do


  let(:file_reader) {file_reader = DSFileReader.new("test_vectors",true)}
  let(:allGamesArray) {allGamesArray = file_reader.games_array.sort {|x,y| x.game_date <=> y.game_date}}
  let(:stay_power) {stay_power = 2}
  let(:due_to_date) {due_to_date = allGamesArray[allGamesArray.length - stay_power].game_date+ 1}
  describe DSLowestConcedingStrategy do


    it 'home_1_away_0' do

      tested_team = getTestedTeam
      all_team_games = allGamesArray.select { |game| game.home_team.eql? tested_team or game.away_team.eql? tested_team }
      test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
      subject.loadGamesAndTeam(file_reader, tested_team, test_date,nil,stay_power)
      subject.getGrade.zero?.should be_truthy
    end

    it 'home_5_away_2' do

      tested_team = getTestedTeam
      all_team_games = allGamesArray.select { |game| game.home_team.eql? tested_team or game.away_team.eql? tested_team }
      test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
      subject.loadGamesAndTeam(file_reader, tested_team, test_date,nil,stay_power)
      subject.getGrade.should == 100.0 * (5.0/6)
    end
  end

  describe DSLowestScoringStrategy do
    it 'home_5_away_2' do

      tested_team = getTestedTeam
      all_team_games = allGamesArray.select { |game| game.home_team.eql? tested_team or game.away_team.eql? tested_team }
      test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
      subject.loadGamesAndTeam(file_reader, tested_team, test_date,nil,stay_power)
      subject.getGrade.should == 0.0
    end

    it 'home_1_away_4' do

      tested_team = getTestedTeam
      all_team_games = allGamesArray.select { |game| game.home_team.eql? tested_team or game.away_team.eql? tested_team }
      test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
      subject.loadGamesAndTeam(file_reader, tested_team, test_date,nil,stay_power)
      subject.getGrade.should == 100.0 * (1.0/6.0)
    end

    it 'home_1_away_4' do 'test non existing team return 0'
      some_team = getTestedTeam
      all_team_games = allGamesArray.select { |game| game.home_team.eql? some_team or game.away_team.eql? some_team }
      test_date = all_team_games[all_team_games.length - 1 - stay_power].game_date + 1
      subject.loadGamesAndTeam(file_reader, DSTeam.new('non_existing'), test_date,nil,stay_power)
      subject.getGrade.zero?.should be_truthy
    end

  end


end
