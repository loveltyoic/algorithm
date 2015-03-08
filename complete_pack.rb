# 完全背包
require 'pry'
def max(*values)
  values.max
end

c = [2, 4, 5, 7, 9, 5]
w = [4, 3, 6, 8, 10, 9]

vol = 20

f = Array.new(vol + 1, 0)
# binding.pry
take = Array.new(c.size + 1) {Array.new(vol + 1, [])}

(1..c.size).each do |i|
  0.upto(vol) do |v|
    # 不选i
    if (v < c[i-1]) || (f[v-c[i-1]] + w[i-1] < f[v])
      take[i][v] = take[i-1][v]
    # 选i
    else
      f[v] = f[v-c[i-1]] + w[i-1]
      take[i][v] = [i].concat take[i][v-c[i-1]]
    end
  end
end
# binding.pry
puts f[vol]

puts take[c.size][vol]

