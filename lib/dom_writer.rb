require_relative "dom_reader"

class DOMWriter

  def initialize(tree)
    @tree = tree
  end

  def write_to_file(path="./rendered_html.html")
    File.write(path, render_node)
    puts render_node
    puts "Your file is located in #{path}"
  end

  private

  def render_node(node=@tree, html="")
    return if node.children == []
    depth = node.depth
    node.children.each do |child|
      if child.is_a?(Tag)
        render_tag(html, child, depth)
      elsif
        render_text(html, child, depth)
      end
    end
    html
  end

  def render_tag(html="", child, depth)
    open_tag = "<#{render_type(child)}#{render_attribs(child)}>\n"
    html <<  ("  " * depth) << open_tag
    render_node(child, html)
    html << "  " * depth  << "</#{child.type}>\n"
  end

  def render_text(html="", child, depth)
    html << "  " * depth << child <<"\n"
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
