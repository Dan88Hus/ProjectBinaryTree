
class Node
  
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# Data structure that holds nodes and organizes them in the form of a balanced binary search tree
class Tree
  attr_accessor :root

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = build_tree(@arr, 0, @arr.length - 1)
  end

  def build_tree(arr, start, last)
    return nil if start > last

    mid = (start + last) / 2
    #print "#{start} start, last #{last} , mid is #{mid} "
    p arr
    
    root = Node.new(arr[mid])
    root.left = build_tree(arr, start, mid - 1)
    
    root.right = build_tree(arr, mid + 1, last)
    root
  end

  def insert(value, node = @root)
    return if value == node.data
    

    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif node.right.nil?
      node.right = Node.new(value)
    else
      insert(value, node.right)
    end
  end

  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def delete(value, node = @root)
    return node if node.nil?

    if node.data < value
      node.right = delete(value, node.right)
      return node
    elsif node.data > value
      node.left = delete(value, node.left)
      return node
    else

      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end

      temp = min_value_node(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end
    node
  end

  def find(value, node = @root)
    return nil if node.nil?

    if node.data < value
      find(value, node.right)
    elsif node.data > value
      find(value, node.left)
    else
      node
    end
  end

  def level_order(node = @root, values = [])
    return nil if node.nil?

    queue = []
    queue.append(node)
    until queue.empty?
      current = queue.shift
      queue.append(current.left) unless current.left.nil?
      queue.append(current.right) unless current.right.nil?
      values.append(current.data)
    end
    values
  end

  def inorder(node = @root, values = [])
    return nil if node.nil?

    inorder(node.left, values) unless node.left.nil?
    values.append(node.data)
    inorder(node.right, values) unless node.right.nil?
    values
  end

  def preorder(node = @root, values = [])
    return nil if node.nil?

    values.append(node.data)
    
    preorder(node.left, values) unless node.left.nil?
    preorder(node.right, values) unless node.right.nil?
    values
  end

  def postorder(node = @root, values = [])
    return nil if node.nil?

    postorder(node.left, values) unless node.left.nil?
    postorder(node.right, values) unless node.right.nil?
    values.append(node.data)
    values
    
  end

  def leaf(node)
    node.left.nil? && node.right.nil?
  end

  def find_leafs(node, leaf_arr = [])
    find_leafs(node.left, leaf_arr) unless node.left.nil?
    find_leafs(node.right, leaf_arr) unless node.right.nil?
    leaf_arr.append(node.data) if leaf(node)
    leaf_arr
  end

  def height(value)
    node = find(value)
    return 0 if leaf(node)

    leaf_arr = find_leafs(node)
    depth_array = []
    leaf_arr.each do |leaf|
      depth_array.append(depth(leaf, node))
    end
    depth_array.max
  end

  def depth(value, node = @root, depth = 0)
    return nil if node.nil?

    if node.data < value
      depth += 1
      depth(value, node.right, depth)
    elsif node.data > value
      depth += 1
      depth(value, node.left, depth)
    else
      depth
    end
  end
# 10th assignment is balanced
  def balanced?(node = @root)
    return nil if node.nil?

    if node.right.nil?
			puts "right is nil"
      return false if height(node.left.data) > 1

    elsif node.left.nil?
			puts "left is nil"
      return false if height(node.right.data) > 1

    elsif (height(node.right.data) - height(node.left.data)).abs > 1
			puts "difference between elements are greater than 1 so its Unbalanced"
      return false

    end
    puts " its balanced"
  end

  def rebalance
    rebalance_array = inorder
    print rebalance_array
    puts
    @root = build_tree(rebalance_array, 0, rebalance_array.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new(Array.new(5) { rand(1..10) })
tree.pretty_print
puts "True or false, the tree is balanced?: #{tree.balanced?}"
print "Elements in order: #{tree.inorder}"
puts
print "Elements in preorder: #{tree.preorder}"
puts
print "Elements in postorder: #{tree.postorder}"
puts
#print "Height of array : #{tree.height(3)}"
# print tree.depth(9)

puts "True or false, the tree is balanced?: #{tree.balanced?}"

puts 'adding 5 elements between 20 and 50 to unbalance the tree'
5.times { tree.insert(rand(20..50)) }

puts tree.pretty_print
puts "calling rebalance methods"
tree.rebalance
tree.pretty_print 

print "Elements in order: #{tree.inorder}"
puts
print "Elements in preorder: #{tree.preorder}"
puts
print "Elements in postorder: #{tree.postorder}"
puts
