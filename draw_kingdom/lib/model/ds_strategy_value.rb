require_relative "../strategies/ds_base_strategy"

class DSStrategyValue

  # readers
  attr_reader :strategy, :weight

  def initialize(strategy, weight)
    @strategy = strategy
    @weight = weight
  end
end

