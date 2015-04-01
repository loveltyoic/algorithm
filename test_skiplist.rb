require 'minitest/autorun'
require_relative 'skiplist'

class TestSkipList < Minitest::Test
  def setup
    @skip_list = SkipList.new
    [0, 3].each { |s| (s..100).step(5) { |i| @skip_list.insert(i, i.to_s) } }
  end

  def test_lookup
    assert_equal "20", @skip_list.lookup(20)[1].value
    assert_equal false, @skip_list.lookup(44)[0]
    assert_equal "53", @skip_list.floor_node(54).value
    assert_equal nil, @skip_list.floor_node(-1).value
    assert_equal "55", @skip_list.ceil_node(54).value
    assert_equal "73", @skip_list.ceil_node(73).value
    assert_equal "73", @skip_list.floor_node(73).value
    assert_equal "100", @skip_list.lookup(100)[1].value
  end

  def test_delete
    @skip_list.delete(70)
    assert_equal "68", @skip_list.floor_node(70).value
    @skip_list.delete(68)
    assert_equal "65", @skip_list.floor_node(70).value
  end

  def test_enumerable_attribute
    assert_equal "0", @skip_list.first.value
    assert_equal "100", @skip_list.last.value
    assert_equal 41, @skip_list.size
    @skip_list.delete(100)
    assert_equal "98", @skip_list.last.value
    @skip_list.delete(0)
    assert_equal "3", @skip_list.first.value    
    assert_equal 39, @skip_list.size
  end
end

# Run Test
# ruby -Ilib:test test_skiplist.rb