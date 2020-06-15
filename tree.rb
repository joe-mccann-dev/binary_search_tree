# frozen_string_literal: true

# creates trees. manages nodes within tree
class Tree
  attr_accessor :root

  def initialize(array = nil)
    @root = build_tree(array) unless array.nil?
  end

  def build_tree(array)
    return if array.size.zero?

    arr = array.sort
    arr.uniq!
    mid_index = (arr.size - 1) / 2
    left = build_tree(arr[0...mid_index])
    right = build_tree(arr[(mid_index + 1)...arr.size])
    Node.new(arr[mid_index], left, right)
  end

  def insert(value, node = @root)
    if node.nil?
      node = Node.new(value)
      @root = node if @root.nil?
    elsif value < node.data
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end
    node
  end

  # removes node if node has no children
  # handles cases where node has only one child
  # if node has two children, finds max value of L subtree.
  # copies that value into node to delete; removes max value or L subtree (temp)
  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    elsif node.left_child.nil? && node.right_child.nil? # node is a leaf
      node = nil
    elsif node.left_child.nil? # node has child on the right
      node = node.right_child
    elsif node.right_child.nil? # node has one child on the left
      node = node.left_child
    else # node has two children
      temp = find_max(node.left_child)
      node.data = temp.data
      node.left_child = delete(temp.data, node.left_child)
    end
    node
  end

  # finds largest node in left subtree
  def find_max(node)
    return nil if node.nil?
    return find_max(node.right_child) unless node.right_child.nil?

    node
  end

  def find_node(value, node = @root)
    return nil if node.nil?
    return node if value == node.data

    if value < node.data
      find_node(value, node.left_child)
    else
      find_node(value, node.right_child)
    end
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  # iterative solution -- returns array of values if no block given
  # def level_order_iterative(node = @root, queue = [], display_array = [])
  #   return if node.nil?

  #   queue << node
  #   until queue.empty?
  #     node = queue.shift
  #     result = yield(node) if block_given?
  #     display_array << node.data unless block_given?
  #     queue << node.left_child unless node.left_child.nil?
  #     queue << node.right_child unless node.right_child.nil?
  #   end
  #   block_given? ? result : display_array
  # end

  def level_order(node = @root, array = [], level = 0, &block)
    return level_order_block(queue = [@root], &block) if block_given?

    until level > height + 1
      result = push_level_to_array(node, level, array)
      level += 1
    end
    result
  end

  # yields to node when level_order is called with a block
  def level_order_block(queue = [@root], &block)
    node = queue.shift
    return if node.nil?

    queue << node.left_child unless node.left_child.nil?
    queue << node.right_child unless node.left_child.nil?
    result = yield(node)
    level_order_block(queue, &block)
    result
  end

  # returns array of values at each level
  def push_level_to_array(node = @root, level = height, array = [])
    return array if node.nil?

    if level == 1
      array << node.data
    else
      push_level_to_array(node.left_child, level - 1, array)
      push_level_to_array(node.right_child, level - 1, array)
    end
  end

  # visits nodes in preoder <node><left><right>
  def preorder(node = @root, display_array = [], &block)
    return if node.nil?

    if block_given?
      preorder(node.left_child, &block)
      preorder(node.right_child, &block)
    else
      display_array << node.data
      preorder(node.left_child, display_array)
      preorder(node.right_child, display_array)
    end
    block_given? ? yield(node) : display_array
  end

  # visits nodes in order <left><node><right>
  def inorder(node = @root, display_array = [], &block)
    return if node.nil?

    if block_given?
      inorder(node.left_child, &block)
      inorder(node.right_child, &block)
    else
      inorder(node.left_child, display_array)
      display_array << node.data
      inorder(node.right_child, display_array)
    end
    block_given? ? yield(node) : display_array
  end

  def postorder(node = @root, display_array = [], &block)
    return if node.nil?

    if block_given?
      postorder(node.left_child, &block)
      postorder(node.right_child, &block)
    else
      postorder(node.left_child, display_array)
      postorder(node.right_child, display_array)
      display_array << node.data
    end
    block_given? ? yield(node) : display_array
  end

  def balanced?
    left = @root.left_child
    right = @root.right_child
    if height(left) - height(right) > 1 || height(right) - height(left) > 1
      return false
    end

    true
  end

  def rebalance!
    return warn 'Tree is already balanced.' if balanced?

    initialize(level_order)
  end
end
