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

  def next
    @levels[0]
  end

  def inspect
    "#{@key} #{@value}"
  end
end

class SkipList
  attr_reader :size
  def initialize(max_level = 16)
    @max_level = max_level
    @current_highest_level = 1
    @head = SkipListNode.new(nil, nil, @max_level)
    @tail = nil
    @max_level.times { |l| @head.set_next_node_at_level(l, nil) }
    @size = 0
  end

  def insert(key, value)
    level = random_level
    # 更新当前最高层数
    @current_highest_level = level if level > @current_highest_level 

    new_node = SkipListNode.new(key, value, level)
    current = @head
    # 从高向低插入
    (level - 1).downto(0) do |l|
      # 找到应该插入的前驱位置
      while current.next_node_at_level(l) && current.next_node_at_level(l).key < key
        current = current.next_node_at_level(l)
      end
      # key值唯一
      raise "Key must be unique" if current.next_node_at_level(l) && current.next_node_at_level(l).key == key
      # 链表插入
      new_node.set_next_node_at_level(l, current.next_node_at_level(l))
      current.set_next_node_at_level(l, new_node)
    end

    # 如果新节点的key比当前尾节点大，则将尾节点指向新节点
    @tail = new_node if @tail.nil? || new_node.key > @tail.key

    @size += 1
  end

  def delete(key)
    deleted = false
    current = @head
    # 逐层删除
    (@current_highest_level - 1).downto(0) do |l|
      # 找到待删节点的前驱
      while current.next_node_at_level(l) && current.next_node_at_level(l).key < key
        current = current.next_node_at_level(l)
      end

      node = current.next_node_at_level(l)
      if node && node.key == key
        deleted = true
        current.set_next_node_at_level(l, node.next_node_at_level(l))
      end
    end
    # 如果删除的是尾节点，则需要更新尾节点
    @tail = current if key == @tail.key
    if deleted
      @size -= 1 
      # 如果删除的节点是当前最高层中的唯一节点，即当前最高层为空，则层高递减
      while @head.next_node_at_level(@current_highest_level).nil?
        @current_highest_level -= 1
      end
    end

    deleted
  end

  def lookup(key)
    current = @head
    (@current_highest_level - 1).downto(0) do |current_level|
      while current.next_node_at_level(current_level) && current.next_node_at_level(current_level).key <= key
        current = current.next_node_at_level(current_level)
      end
      return [true, current] if current.key == key
    end
    return [false, current]
  end

  def floor_node(key)
    lookup(key)[1]
  end

  def ceil_node(key)
    found, node = lookup(key)
    found ? node : node.next
  end

  def first
    @head.next
  end

  def last
    @tail
  end

  private
  def random_level
    # level值越高，其概率越小
    level = 1
    while rand(2) == 1
      level += 1
    end
    level = @max_level > level ? level : @max_level
  end
end