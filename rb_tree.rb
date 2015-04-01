module Xunch
  class RBTree


    # The tree's root node.
    attr_reader :root
    
    # The number of nodes in the tree.
    attr_reader :size

    # The key compare proc
    attr_reader :compare_proc

    # Creates a new tree.
    def initialize(&compare_proc)
      @size = 0
      @root = nil
      @compare_proc = compare_proc
    end

    def put(key,value)
      tmp_node = @root
      if(tmp_node == nil)
        compare_key(key,key)
        @root = RBTree::Node.new(key,value,nil)
        @size = 1
        return value
      end
      cmp = 0
      parent = nil

      begin
        parent = tmp_node
        cmp = compare_key(key,parent.key)
        if cmp < 0
          tmp_node = tmp_node.left;
        elsif cmp > 0
          tmp_node = tmp_node.right;
        else
          return tmp_node.value = value;
        end
      end while tmp_node != nil

      node = RBTree::Node.new(key,value,parent)

      if cmp < 0
        parent.left = node
      else
        parent.right = node
      end
      
      fixafterinsertion(node)    
      @size+=1

      return value
      
    end

    def remove(key)
      p = getnode(key)
      if (p == nil)
        return nil
      end

      oldValue = p.value
      deletenode(p)
      return oldValue
    end

    def get(key)
      p = getnode(key);
      return (p == nil ? nil : p.value)
    end

    def clear
      @size = 0
      @root = nil
    end

    def size
      @size
    end

    def first_node
      p = @root;
      if p != nil
        while p.left != nil
          p = p.left
        end
      end
      RBTree::ImmutableNode.new(p.key,p.value)
    end

    def first_key
      p = @root;
      if p != nil
        while p.left != nil
          p = p.left
        end
      end
      p.key
    end

    def first_value
      p = @root;
      if p != nil
        while p.left != nil
          p = p.left
        end
      end
      p.value
    end

    def last_node
      p = @root;
      if p != nil
        while p.right != nil
          p = p.right
        end
      end
      RBTree::ImmutableNode.new(p.key,p.value)
    end

    def last_key
      p = @root;
      if p != nil
        while p.right != nil
          p = p.right
        end
      end
      p.key
    end

    def last_value
      p = @root;
      if p != nil
        while p.right != nil
          p = p.right
        end
      end
      p.value
    end

    def floor_node(key)
      p = @root;
      while p != nil
        cmp = compare_key(key, p.key)
        if cmp > 0
          if p.right != nil
            p = p.right
          else
            if p == nil
              return nil
            else
              return RBTree::ImmutableNode.new(p.key,p.value)
            end
          end
        elsif cmp < 0
          if p.left != nil
            p = p.left
          else
            parent = p.parent
            ch = p
            while parent != nil && ch == parent.left
              ch = parent
              parent = parent.parent;
            end
            if parent == nil
              return nil
            else
              return RBTree::ImmutableNode.new(parent.key,parent.value)
            end
          end
        else
          if p == nil
            return nil
          else
            return RBTree::ImmutableNode.new(p.key,p.value)
          end
        end
      end
    
      return nil
    end

    def floor_key(key)
      node = floor_node(key)
      if node == nil
        return nil
      else
        return node.key
      end
    end

    def floor_value(key)
      node = floor_node(key)
      if node == nil
        return nil
      else
        return node.value
      end
    end

    def lower_node(key)
      p = @root;
      while p != nil
        cmp = compare_key(key, p.key)
        if cmp > 0
          if p.right != nil
            p = p.right
          else
            if p == nil
              return nil
            else
              return RBTree::ImmutableNode.new(p.key,p.value)
            end
          end
        else
          if p.left != nil
            p = p.left
          else
            parent = p.parent
            ch = p
            while parent != nil && ch == parent.left
              ch = parent
              parent = parent.parent;
            end
            if parent == nil
              return nil
            else
              return RBTree::ImmutableNode.new(parent.key,parent.value)
            end
          end
        end
      end
      return nil
    end

    def lower_key(key)
      node = lower_node(key)
      if node == nil
        return nil
      else
        return node.key
      end
    end

    def lower_value(key)
      node = lower_node(key)
      if node == nil
        return nil
      else
        return node.value
      end
    end

    def ceiling_node(key)
      p = @root;
      while p != nil
        cmp = compare_key(key, p.key)
        if cmp < 0
          if p.left != nil
            p = p.left
          else
            if p == nil
              return nil
            else
              return RBTree::ImmutableNode.new(p.key,p.value)
            end
          end
        elsif cmp > 0
          if p.right != nil
            p = p.right
          else
            parent = p.parent
            ch = p
            while parent != nil && ch == parent.right
              ch = parent
              parent = parent.parent;
            end
            if parent == nil
              return nil
            else
              return RBTree::ImmutableNode.new(parent.key,parent.value)
            end
          end
        else
          if p == nil
            return nil
          else
            return RBTree::ImmutableNode.new(p.key,p.value)
          end
        end
      end
    
      return nil
    end

    def ceiling_key(key)
      node = ceiling_node(key)
      if node == nil
        return nil
      else
        return node.key
      end
    end

    def ceiling_value(key)
      node = ceiling_node(key)
      if node == nil
        return nil
      else
        return node.value
      end
    end

    def higher_node(key)
      p = @root;
      while p != nil
        cmp = compare_key(key, p.key)
        if cmp < 0
          if p.left != nil
            p = p.left
          else
            if p == nil
              return nil
            else
              return RBTree::ImmutableNode.new(p.key,p.value)
            end
          end
        else
          if p.right != nil
            p = p.right
          else
            parent = p.parent
            ch = p
            while parent != nil && ch == parent.right
              ch = parent
              parent = parent.parent;
            end
            if parent == nil
              return nil
            else
              return RBTree::ImmutableNode.new(parent.key,parent.value)
            end
          end
        end
      end
    
      return nil
    end

    def higher_key(key)
      node = higher_node(key)
      if node == nil
        return nil
      else
        return node.key
      end
    end

    def higher_value(key)
      node = higher_node(key)
      if node == nil
        return nil
      else
        return node.value
      end
    end

    def successor(t)
      if t == nil
        return nil
      elsif t.right != nil
        p = t.right
        while p.left != nil
            p = p.left
        end
        return p
      else
        p = t.parent
        ch = t
        while p != nil && ch == p.right
          ch = p
          p = p.parent
        end
        return p
      end
    end

    def deletenode(p)
      @size-=1

      if p.left != nil && p.right != nil
        s = successor(p)
        p.key = s.key
        p.value = s.value
        p = s
      end

      replacement = (p.left != nil ? p.left : p.right)

      if replacement != nil
        replacement.parent = p.parent;
        if p.parent == nil
          @root = replacement
        elsif p == p.parent.left
          p.parent.left  = replacement
        else
          p.parent.right = replacement
        end

        p.left = p.right = p.parent = nil

        if p.color == :black
          fixafterdeletion(replacement)
        end
      elsif p.parent == nil
        @root = nil
      else
        if p.color == :black
          fixafterdeletion(p)
        end
        if p.parent != nil
          if p == p.parent.left
            p.parent.left = nil
          elsif p == p.parent.right
            p.parent.right = nil
          end
          p.parent = nil
        end
      end
    end

    def getnode(key)
      raise "key is nil." unless key != nil 
      p = @root;
      while p != nil
        cmp = compare_key(key, p.key)
        if cmp < 0
          p = p.left
        elsif cmp > 0
          p = p.right
        else
          return p
        end
      end
      return nil
    end

    def fixafterdeletion(x)
      while x != @root && colorof(x) == :black
        if x == leftof(parentof(x))
          sib = rightof(parentof(x))

          if colorof(sib) == :red
            setcolor(sib, :black)
            setcolor(parentof(x), :red)
            rotateleft(parentof(x))
            sib = rightof(parentof(x))
          end

          if colorof(leftof(sib))  == :black && colorof(rightof(sib)) == :black
            setcolor(sib, :red)
            x = parentof(x)
          else
            if colorof(rightof(sib)) == :black
              setcolor(leftof(sib), :black)
              setcolor(sib, :red)
              rotateright(sib)
              sib = rightof(parentof(x))
            end
            setcolor(sib, colorof(parentof(x)))
            setcolor(parentof(x), :black)
            setcolor(rightof(sib), :black)
            rotateleft(parentof(x))
            x = @root
          end
        else
          sib = leftof(parentof(x))

          if colorof(sib) == :red
            setcolor(sib, :black)
            setcolor(parentof(x), :red)
            rotateright(parentof(x))
            sib = leftof(parentof(x))
          end

          if colorof(rightof(sib)) == :black && colorof(leftof(sib)) == :black
            setcolor(sib, :red)
            x = parentof(x)
          else
            if colorof(leftof(sib)) == :black
              setcolor(rightof(sib), :black)
              setcolor(sib, :red)
              rotateleft(sib)
              sib = leftof(parentof(x))
            end
            setcolor(sib, colorof(parentof(x)))
            setcolor(parentof(x), :black)
            setcolor(leftof(sib), :black)
            rotateright(parentof(x))
            x = @root;
          end
        end
      end
      setcolor(x, :black);
    end

    def fixafterinsertion(x)
      x.color = :red

      while x != nil && x != @root && x.parent.color == :red 
        if parentof(x) == leftof(parentof(parentof(x)))
          y = rightof(parentof(parentof(x)))
          if colorof(y) == :red
            setcolor(parentof(x), :black)
            setcolor(y, :black)
            setcolor(parentof(parentof(x)), :red)
            x = parentof(parentof(x))
          else
            if x == rightof(parentof(x)) 
              x = parentof(x)
              rotateleft(x)
            end
            setcolor(parentof(x), :black);
            setcolor(parentof(parentof(x)), :red);
            rotateright(parentof(parentof(x)));
          end
        else
          y = leftof(parentof(parentof(x)))
          if colorof(y) == :red
            setcolor(parentof(x), :black)
            setcolor(y, :black)
            setcolor(parentof(parentof(x)), :red)
            x = parentof(parentof(x))
          else
            if x == leftof(parentof(x))
              x = parentof(x)
              rotateright(x)
            end
            setcolor(parentof(x), :black);
            setcolor(parentof(parentof(x)), :red);
            rotateleft(parentof(parentof(x)));
          end
        end
      end

      @root.color = :black;
    end

    def rotateleft(p)
      return unless p.right
      if p != nil
        r = p.right
        p.right = r.left
        if r.left != nil
          r.left.parent = p
        end
        r.parent = p.parent
        if p.parent == nil
          @root = r
        elsif p.parent.left == p
          p.parent.left = r
        else
          p.parent.right = r
        end
        r.left = p
        p.parent = r
      end
    end

    def rotateright(p)
      return unless p.left
      if p != nil
        l = p.left
        p.left = l.right
        if l.right != nil
          l.right.parent = p
        end
        l.parent = p.parent
        if p.parent == nil
          @root = l
        elsif p.parent.right == p
          p.parent.right = l
        else 
          p.parent.left = l
        end
        l.right = p
        p.parent = l
      end
    end

    def parentof(node)
      return (node == nil ? nil : node.parent)
    end

    def leftof(node)
      return (node == nil ? nil : node.left)
    end

    def rightof(node)
      return (node == nil ? nil : node.right)
    end

    def colorof(node)
      if node != nil
        node.color
      end
    end

    def setcolor(node, color)
      if node != nil
        node.color = color
      end 
    end

    def compare_key(key1,key2)
      if !key1.integer? || !key2.integer?
        raise "#{key1} type is #{key1.class}, #{key2} type is #{key2.class}, but need type Integer"
      end
      if @compare_proc != nil
        return @cmp_proc.call(key1, key2)
      else
        if key1 > key2
          return 1
        elsif key1 < key2
          return -1
        elsif key1 == key2
          return 0
        end
      end
    end

  end
end