require_relative 'dom_reader'

class NodeRenderer

  def initialize(tree)
    @tree = tree
    @html = ""
  end

  def render_stats(node=@tree)
    child_count = children_count(node)
    type_counter = count_children_type(node)
    puts "================================="
    puts "Stats for #{node.type} (depth=#{node.depth})"
    puts "================================="
    puts "------------Attributes-----------"
    if node.classes.empty? && node.attributes == {}
      puts "None."
    else
      node.attributes.each do |attrib_name, attrib_value|
         puts "#{attrib_name}: #{attrib_value}"
      end
    end
    puts "-------------Subtags-------------"
    puts "Total: #{child_count} subtags"
    type_counter.each do |type, count|
       puts "#{type}: #{count}"
    end
  end

  private

  def count_children_type(node=@tree, child_type_counter=Hash.new(0))
    return count if node.children.empty?
    node.children.each do |child|
       next if child.is_a?(String)
       child_type_counter[child.type] += 1
       child_type_counter = count_children_type(child, child_type_counter)
    end
    child_type_counter
  end

  def children_count(node=@tree)
    child_type_counter = count_children_type(node)
    child_type_counter.values.inject(:+)
  end


end

d = DOMReader.new('./small_html.txt')
tree = d.build_tree
renderer = NodeRenderer.new(tree)
# grandchild = tree.children[0].children[1].children[0]
renderer.render_stats(tree.children[0])
