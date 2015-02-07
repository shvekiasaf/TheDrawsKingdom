class DSTeam
  # Readers
  attr_reader :team_name

  # Initialize
  def initialize(team_name)
    @team_name = team_name
  end

  def eql?(object)
    self == (object)
  end

  def ==(object)
    if object.equal?(self)
      return true
    elsif !object.instance_of?(self.class)
      return false
    end

    return object.team_name.eql?@team_name
  end
end