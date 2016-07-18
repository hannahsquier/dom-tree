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
        open_tag = "<#{render_type(child)}#{render_attribs(child)}>\n"
        html <<  ("  " * depth) << open_tag
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


  def render_attribs(tag)
    attrib_string = ""
    if tag.classes == {}
      return ""
    else
      tag.attributes.each do |key, value|
        attrib_string << " #{key}=\"#{value}\""
      end
    end
    attrib_string
  end
end

d = DOMReader.new('./small_html.txt')
tree = d.build_tree
puts DOMWriter.new(tree).render_html