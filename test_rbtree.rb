require 'minitest/autorun'
require_relative 'rb_tree'
require_relative 'rb_tree_node'

module Xunch
  class TestRBTree < Minitest::Test
    def setup
      @tree = RBTree.new
      [0].each { |s| (s..100).step(5) { |i| @tree.put(i, i.to_s) } }
    end

    def test_remove
      (50..100).step(5) do |i|
        assert_equal i.to_s, @tree.floor_node(i+1).value
      end

      @tree.remove(85)
      @tree.remove(75)
      @tree.remove(90)
      assert_equal "80", @tree.floor_node(81).value
      assert_equal "80", @tree.floor_node(86).value
      assert_equal "80", @tree.floor_node(92).value
    end
  end
end