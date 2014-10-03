require_relative "../strategies/ds_base_strategy"

class DSStrategyValue

  # readers
  attr_reader :strategy, :value

  def initialize(strategy, value)
    @strategy = strategy
    @value = value
  end
end