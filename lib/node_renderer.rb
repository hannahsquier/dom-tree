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
    if !node.id && node.classes.empty?
      puts "None."
    else

      puts "id: #{node.id}" if node.id

      node.classes.each do |class1|
        puts "class: #{class1}"
      end
    end
    puts "-------------Subtags-------------"
    puts "Total: #{child_count} subtags"

    type_counter.each do |type, count|
       puts "#{type}: #{count}"
    end
  end

  def render_html
    full_html = render_node(@tree, @html)
    puts full_html
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

  def render_node(node, html)
    return if node.children == []
    depth = node.depth
    node.children.each do |child|
      if child.is_a?(Tag)
        type = render_type(child)
        classes = render_classes(child)
        id = render_id(child)
        html <<  ("  " * depth) << "<#{type}#{classes}#{id}>\n"
        render_node(child, html)
        html << "  " * depth  << "</#{child.type}>\n"

      elsif
        html << "  " * depth << child <<"\n"
      end
    end
    html
  end

  def render_type(tag)
    tag.type ? tag.type : ""
  end

  def render_id(tag)
    tag.id ? " id=\"#{tag.id}\"" : ""
  end

  def render_classes(tag)
    if tag.classes.empty?
      return ""
    else
      classes = " class=\"#{tag.classes.shift}"
      tag.classes.each do |tag_class|
        classes << " #{tag_class}"
      end
      classes << "\""
    end
  end
end

d = DOMReader.new('./test.html')
tree = d.build_tree
renderer = NodeRenderer.new(tree)
grandchild = tree.children[0].children[1].children[0]

renderer.render_html
