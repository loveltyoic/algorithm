require 'benchmark'

%w(rb_tree.rb rb_tree_node.rb skiplist.rb).each { |f| require File.expand_path("../#{f}", __FILE__) }
skip_list = SkipList.new
rb_tree = Xunch::RBTree.new
Benchmark.bm do |x|
  x.report("rb_tree insert") { [0, 3].each { |s| (s..5000).step(5) { |i| rb_tree.put(i, i.to_s) } } }
  x.report("skip list insert") { [0, 3].each { |s| (s..5000).step(5) { |i| skip_list.insert(i, i.to_s) } } }
end

looked = (1..10000).map { rand(20000) }
Benchmark.bm do |x|
  x.report("skip list lookup") { looked.each { |i| skip_list.floor_node(i) } }
  x.report("rb_tree list lookup") { looked.each { |i| rb_tree.floor_node(i) } }
end  

Benchmark.bm do |x|
  x.report("skip list delete") { looked.each { |i| skip_list.delete(i) } }
  x.report("rb_tree list delete") { looked.each { |i| rb_tree.remove(i) } }
end