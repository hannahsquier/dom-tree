require_relative "dom_reader"

class DOMWriter

  def initialize(tree)
    @tree = tree
  end


  def render_html
    full_html = render_node(@tree)
    puts full_html
  end

  private

  def render_node(node, html="")
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

puts DOMWriter.new(tree).render_html