require 'rspec'
require_relative "../../../lib/strategies/ds_teams_draw_ratio_strategy"
require_relative "../../../lib/model/ds_team"
require_relative "../../../lib/model/ds_game"
require_relative "../../../lib/components/ds_file_reader"

def getTestedTeam
  file_reader.teamsHash.values.select { |team| team.team_name.eql? RSpec.current_example.description }[0]
end

describe DSTeamsDrawRatioStrategy do

  let(:file_reader) {file_reader = DSFileReader.new("test_vectors")}

  it "hapoel" do
    subject.loadGamesAndTeam(file_reader, getTestedTeam, Date.new(2014,1,10), nil, 5)
    subject.getGrade.should == 5.0
  end

  it "maccabi" do
    subject.loadGamesAndTeam(file_reader, getTestedTeam, Date.new(2014,1,9), nil, 5)
    subject.getGrade.should == 10.0
  end

end