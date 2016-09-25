class Edge

  attr_reader :successor
  attr_reader :weight


  def initialize(successor,weight)
    @successor = successor
    @weight = weight
  end

  def to_s
    "-> #{@successor.name}"
  end

end