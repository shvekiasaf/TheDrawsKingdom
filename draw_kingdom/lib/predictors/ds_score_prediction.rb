class DSScorePrediction

  attr_reader :home_score, :away_score, :likelihood

  def initialize(home_score, away_score, likelihood)
    @home_score = home_score
    @away_score = away_score
    @likelihood = likelihood
  end
end