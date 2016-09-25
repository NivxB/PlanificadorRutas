require_relative "edge.rb"

class Node

  attr_reader :name, :xC, :yC, :visited,:index
  attr_writer :visited


  def initialize(name,xC,yC,index)
    @name = name
    @xC = xC
    @yC = yC
    @visited = false
    @index = index
    @successors = []
  end

  def add_edge(successor,weight)
    edge = Edge.new(successor,weight)
    @successors << edge
  end

  def get_min_edge()
    retVal = nil
    @successors.each do |inner_edge|
        if (!(inner_edge.successor.visited) and retVal.nil?) or (!(inner_edge.successor.visited) and inner_edge.weight < retVal.weight) then
          retVal = inner_edge
        end
    end
    return retVal
  end

  def to_s
    "#{@name} [#{@successors.map{|edge| "#{edge}"}.join(' ')}]"
  end

end