require 'rspec'
require_relative '../../../../draw_kingdom/lib/predictors/ds_game_predictor'
require_relative '../../../lib/model/ds_game'
require_relative '../../../lib/components/ds_file_reader'
def getTestedTeam
  file_reader.teamsHash.values.select { |team| team.team_name.eql? RSpec.current_example.description }[0]
end

describe DSGamePredictor do

  let(:file_reader) {file_reader = DSFileReader.new("test_vectors",true)}
  it 'should return nil for non existing team' do
    game = file_reader.games_array.sort { |x, y| x.game_date <=> y.game_date }.last
    dummy_game = DSGame.new(game.game_date, game.home_team, DSTeam.new('no_such_team'), 0, 0, nil, nil)
    prediction = DSGamePredictor.new(file_reader).getPrediction(dummy_game, game.game_date - 100, game.game_date - 10)
    prediction.should be_nil
  end

  it 'past_results_home_5_away_2' do
    tested_team = getTestedTeam
    all_team_games = file_reader.getAllGamesFor(tested_team, Date.new(1900), Date.new(2100)).sort { |x, y| x.game_date <=> y.game_date }
    prediction = DSGamePredictor.new(file_reader).getPrediction(all_team_games[2], all_team_games.first.game_date - 1, all_team_games.last.game_date - 1)
    prediction.home_score.should == 5
    prediction.away_score.should == 0
    prediction.likelihood.should == 1.0


  end
  it 'past_results_home_1_away_4' do
    tested_team = getTestedTeam
    all_team_games = file_reader.getAllGamesFor(tested_team, Date.new(1900), Date.new(2100)).sort { |x, y| x.game_date <=> y.game_date }
    prediction = DSGamePredictor.new(file_reader).getPrediction(all_team_games.last, all_team_games.first.game_date - 1, all_team_games.last.game_date - 3)
    prediction.home_score.should == 0.5
    prediction.away_score.should == 1
    prediction.likelihood.should == 5.0/8


  end
end