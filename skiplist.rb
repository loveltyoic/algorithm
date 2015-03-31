require 'minitest/autorun'

class SkipListNode
  attr_reader :key, :level, :value
  def initialize(key, value, max_level)
    @key = key
    @value = value
    @levels = Array.new(max_level)
  end

  def next_node_at_level(l)
    @levels[l]
  end

  def set_next_node_at_level(l, node)
    @levels[l] = node
  end
end

class SkipList
  def initialize(max_level = 5)
    @max_level = max_level
    @head = SkipListNode.new(nil, nil, @max_level)
    @tail = nil
    @max_level.times { |l| @head.set_next_node_at_level(l, @tail) }
  end

  def insert(key, value)
    level = random_level
    new_node = SkipListNode.new(key, value, level)
    level.times do |l|
      current = @head
      while current.next_node_at_level(l) && current.next_node_at_level(l).key < key
        current = current.next_node_at_level(l)
      end
      new_node.set_next_node_at_level(l, current.next_node_at_level(l))
      current.set_next_node_at_level(l, new_node)
    end
    true
  end

  def delete(key)
    # found, node = lookup(key)
    # return false unless found
    @max_level.times do |l|
      current = @head
      while current.next_node_at_level(l) && current.next_node_at_level(l).key < key
        current = current.next_node_at_level(l)
      end

      node = current.next_node_at_level(l)
      if node && node.key == key
        current.set_next_node_at_level(l, node.next_node_at_level(l))
      end
    end
  end

  def lookup(key)
    current_level = @max_level - 1
    while  current_level >= 0
      floor = find_floor_in_level(current_level, key)
      return [true, floor] if floor.key == key
      current_level -= 1
    end
    return [false, floor]
  end

  def floor_node(key)
    lookup(key)[1]
  end

  private
  def find_floor_in_level(level, key, &block)
    current = @head
    while (next_node = current.next_node_at_level(level)) && next_node.key <= key
      current = next_node
    end
    block ? block.call(current) : current
  end

  def random_level
    # level值越高，其概率越小
    level = 1
    while rand(2) == 1
      level += 1
    end
    level = @max_level > level ? level : @max_level
  end
end

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
  end

  def test_delete
    @skip_list.delete(70)
    assert_equal "68", @skip_list.floor_node(70).value
    @skip_list.delete(68)
    assert_equal "65", @skip_list.floor_node(70).value
  end
end