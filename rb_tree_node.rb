# :nodoc: namespace
module Xunch
  class RBTree

# A node in the red-black tree.
#
# Nodes should only be manipulated directly by the RedBlackTree class.
    class Node
      attr_accessor :key
      attr_accessor :value

      attr_accessor :color
      attr_accessor :left
      attr_accessor :right
      attr_accessor :parent

      # Creates a new node.
      #
      # New tree nodes are red by default.
      def initialize(key, value, parent)
        @color = :black
        @key = key
        @value = value
        @parent = parent
      end

      # node to string
      def to_s
        "#{@key}=#{@value},#{@color}"
      end
      
      def inspect
        "#{@key}=#{@value},#{@color}"
      end
      
      # True for black nodes.
      def black?
        @color == :black
      end

      # True for red nodes.
      def red?
        @color == :red
      end

    end   # class RBTree::Node

    class ImmutableNode
      attr_reader :key
      attr_reader :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def inspect
        "#{@key}=#{@value}"
      end

      def to_s
        "#{@key}=#{@value}"
      end

    end   # class RBTree::ImmutableNode
  end   # namespace RBTree
end