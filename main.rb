require_relative "graph.rb"
require_relative "node.rb"

def calcular_ruta(origin_x, origin_y, destiny_x, destiny_y)
	distancia = Math.sqrt((destiny_x-origin_x)**2 + (destiny_y-origin_y)**2)
	return distancia
end

def incorrect_mst(origin_node)
	currentMST = []
	min_edge = origin_node.get_min_edge()
	while (!(min_edge.nil?) and !min_edge.successor.visited) do

		currentMST.push(min_edge)
		min_edge.successor.visited = true
		min_edge = min_edge.successor.get_min_edge()
		
	end
	return currentMST
end

def mergesort(array,xCompare)
  def merge(left_sorted, right_sorted,xCompare)
  	def compare_logic(left_sorted,right_sorted,l,r,xCompare)
  		if xCompare then
  			return left_sorted[l].xC < right_sorted[r].xC
  		else
  			return left_sorted[l].yC < right_sorted[r].yC
  		end
  	end
    res = []
    l = 0
    r = 0

    loop do
      break if r >= right_sorted.length and l >= left_sorted.length

      if r >= right_sorted.length or (l < left_sorted.length and compare_logic(left_sorted,right_sorted,l,r,xCompare) )
        res << left_sorted[l]
        l += 1
      else
        res << right_sorted[r]
        r += 1
      end
    end

    return res
  end

  def mergesort_iter(array_sliced,xCompare)
    return array_sliced if array_sliced.length <= 1

    mid = array_sliced.length/2 - 1
    left_sorted = mergesort_iter(array_sliced[0..mid],xCompare)
    right_sorted = mergesort_iter(array_sliced[mid+1..-1],xCompare)
    return merge(left_sorted, right_sorted,xCompare)
  end

  mergesort_iter(array,xCompare)
end

def get_max_value(array_nodes,xValue)
	retVal = xValue ? array_nodes[0].xC : array_nodes[0].yC
	array_nodes.each do |node|
		if node.xC > retVal && xValue then
			retVal = node.xC
		elsif node.yC > retVal && !xValue then
			retVal = node.yC
		end
	end
	return retVal
end


entryFile = File.open("entrada.txt","r")
outFile = File.open("salida.txt","w")
finalDistanceFile = File.open("calculos.txt","w")

trucksAvailable = -1
distributionCenter_X = -1
distributionCenter_Y = -1
#wut change
fileLine = 0
#|V|
graphs = []
nodes = [];


entryFile.each_line do |line|
	if fileLine > 1 then
		#graph logic
		storeX = line.split(",")[0].to_i
		storeY = line.split(",")[1].to_i
		nodes.push(Node.new("Store(#{storeX},#{storeY})",storeX,storeY,nodes.length))
		
		#fileLine++;
	elsif fileLine == 0 then
		trucksAvailable = line.to_i
		fileLine = 1
	elsif fileLine == 1 then
		distributionCenter_X = line.split(",")[0].to_i
		distributionCenter_Y = line.split(",")[1].to_i
		fileLine = 2
	end
end

puts("#{nodes.length}")
puts("#{nodes.map{|no| "(#{no.xC},#{no.yC})"}.join(",")}")

max_x = get_max_value(nodes,true)
#min_x = get_min_value(nodes,true)
max_y = get_max_value(nodes,false)
#min_y = get_min_value(nodes,false)

x_compare =  max_x - distributionCenter_X
y_compare = max_y - distributionCenter_Y

if (x_compare > y_compare) then
	nodes = mergesort(nodes,true)
else
	nodes  = mergesort(nodes,false)
end
graphIndex = 0
nodes_by_truck = (nodes.length.to_f / trucksAvailable.to_f).ceil


while (graphIndex < trucksAvailable) do
	graphs.push(Graph.new)
	
	nodeIndex = nodes_by_truck * (graphIndex)
	upperLimit = nodes_by_truck * (1 + graphIndex)
	
	if (upperLimit > nodes.length) then
		upperLimit = nodes.length 
	end
	while (nodeIndex < upperLimit) do
		graphs[graphIndex].add_node(nodes[nodeIndex])
		nodeIndex = nodeIndex + 1
	end

	#add principal Store
	graphs[graphIndex].add_node(Node.new("MainHub(#{distributionCenter_X},#{distributionCenter_Y})",distributionCenter_X,distributionCenter_Y,0))
	#connect everything
	#|V|^2
	graphs[graphIndex].nodes.each do |node_name, node|
		graphs[graphIndex].nodes.each do |sub_node_name, sub_node|
			if node_name != sub_node_name then
				weight = calcular_ruta(node.xC,node.yC,sub_node.xC,sub_node.yC)
				graphs[graphIndex].add_edge(node.name,sub_node.name,weight)
			end
		end
	end
	graphIndex = graphIndex + 1
end

graphIndex = 0
while (graphIndex < trucksAvailable) do
	graphs[graphIndex].reset_node_visited()

	origin_node = graphs[graphIndex].get_node("MainHub(#{distributionCenter_X},#{distributionCenter_Y})")
	origin_node.visited = true
	#Node.new("MainHub(#{distributionCenter_X},#{distributionCenter_Y})",distributionCenter_X,distributionCenter_Y)	
	#currentMST.push(origin_node)
	currentMST = incorrect_mst(origin_node)
	
	graphIndex = graphIndex + 1
	puts("")
	puts("----------------------------------")
	puts("#{currentMST.length}")
	puts("#{currentMST.map{|edge| "(#{edge.successor.xC},#{edge.successor.yC})"}.join(",")}")
	puts("****************************************")

	#puts(currentMST.length)
	total_distance = 0;
	outFile.puts("#{currentMST.length}")
	currentMST.each do |c_node|
		outFile.puts("#{c_node.successor.index}")
		puts("#{c_node}")
		total_distance = total_distance + c_node.weight
	end
	origin_node = Node.new("MainHub(#{distributionCenter_X},#{distributionCenter_Y})",distributionCenter_X,distributionCenter_Y,0)	
	currentMST = currentMST.unshift(origin_node)
	final_x = currentMST.last.successor.xC
	final_y = currentMST.last.successor.yC
	
	total_distance = total_distance+calcular_ruta(final_x,final_y,distributionCenter_X,distributionCenter_Y)
	finalDistanceFile.puts("Ruta #{graphIndex}: Total Distance: #{total_distance}")
	#puts(currentMST[0])

end

puts("")
puts("Store X: #{distributionCenter_X}")
puts("Store Y: #{distributionCenter_Y}")
puts("Trucks Available: #{trucksAvailable}")
puts("Total Stores: #{nodes.length}")
