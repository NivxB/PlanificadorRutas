class Graph

  attr_reader :nodes

  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.name] = node
  end

  def add_edge(predecessor_name, successor_name,weight)
    @nodes[predecessor_name].add_edge(@nodes[successor_name],weight)
  end

  def get_node(nodeName)
    return @nodes[nodeName]
  end

  def reset_node_visited()
    @nodes.each do |node_name, node|
      node.visited = false
    end
  end

  def [](name)
    @nodes[name]
  end

end