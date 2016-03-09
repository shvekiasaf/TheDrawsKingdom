require_relative "../strategies/ds_base_strategy"

class DSGradesContainer

  # readers
  attr_reader :container

  def initialize
      @container = {}
  end

  def addGrade(grade, strategy)

      @container[strategy.strategyName] = grade
  end

  def addResult(did_draw)

    result = did_draw ? 1 : 0
    @container["did_draw"] = result
  end

end