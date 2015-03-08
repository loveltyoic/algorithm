require 'pry'
def extract_min(distance, u)
  vertex, d = "-1", Float::INFINITY
  u.each do |v|
    vertex, d = v, distance[v] if distance[v] < Float::INFINITY
  end
  return vertex
end

# 每个顶点到目标点的最短距离
distance = {}
# 邻接矩阵
lm = Array.new(10) { Array.new(10) }
puts "matrix:"
0.upto(9) do |i|
  lm[i][i] = 0

  # 初始距离都设为负无穷
  distance.merge!({i.to_s => Float::INFINITY})

  0.upto(i-1) do |j|
    lm[i][j] = rand(10)

  end
  # puts
end

0.upto(9) do |i|
  (i+1).upto(9) do |j|
    lm[i][j] = lm[j][i]
  end
end

0.upto(9) do |i|
  0.upto(9) do |j|
    print "#{lm[i][j]} "
  end
  puts
end
# 前驱顶点
pre = Array(10)

distance["0"] = 0

pre[0] = "0"

s = []
u = (0..9).to_a.map(&:to_s)

until u.empty? do 
  # 每次取u中距离最短的点, 加入s
  vertex = extract_min(distance, u)
  dis = distance[vertex]
  u.delete(vertex)
  s << vertex
  #遍历这一点的相邻顶点，更新它们的最短路径
  lm[vertex.to_i].each.with_index do |edge, i|
    # binding.pry
    if dis + edge < distance[i.to_s] 
      distance[i.to_s] = dis + edge
      pre[i] = vertex
    end
  end
end

0.upto(9) do |i|
  # binding.pry
  puts "节点#{i}到源的最短距离为#{distance[i.to_s]}"
  start = pre[i]

  print "最短路径为:"
  until start == "0" do 
    print "#{start}-"
    start = pre[start.to_i]
  end
  print "0\n"
end

