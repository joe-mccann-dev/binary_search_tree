class Node
  include Comparable
  
  def <=> (other_node)
    data <=> other_node.data unless other_node.nil?
  end

  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    arr = array.sort
    arr.uniq!
    @root = build_tree(arr)
  end

  def build_tree(array)
    return if array.size.zero?
  
    mid_index = (array.size - 1) / 2
    left = build_tree(array[0...mid_index])
    right = build_tree(array[(mid_index + 1)...array.size])
    root = Node.new(array[mid_index], left, right)
  end

  def insert(value, root = @root)
    if root.nil?
      root = root.new(value)
    elsif value < root.data
      root.left_child = insert(value, root.left_child)
    else
      root.right_child = insert(value, root.right_child)
    end
    root
  end


  def delete(value, root = @root)
    return root if root.nil?
    
    puts "hello"
    if value < root.data
      root.left_child = delete(value, root.left_child)
    elsif value > root.data
      root.right_child = delete(value, root.right_child)
    else
      if root.left_child.nil? && root.right_child.nil? # no children (root is a leaf)
        root = nil
      elsif root.left_child.nil? # root has child on the right
        root = root.right_child
      elsif root.right_child.nil? # root has one child on the left
        root = root.left_child
      else # root has two children
        temp = find_min(root.right_child)
        root.data = temp.data
        root.right_child = delete(temp.data, root.right_child)
      end 
    end
    root
  end

  # finds smallest root in the given tree
  def find_min(node)
    return nil if node.nil?

    return find_min(node.left_child) unless node.left_child.nil?

    node
  end
end
