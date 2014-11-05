require 'rspec'
require_relative '../../../lib/components/ds_file_reader'
require_relative 'sea'
describe 'find relevant teams' do
  let(:file_reader) {file_reader = DSFileReader.new("test_vectors")}
  it ' get lowest scoring team ' do

    true.should == false
  end
end
