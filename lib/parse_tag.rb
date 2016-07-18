require 'pry'

P_TAG = "<p class='foo bar' id='baz' name='fozzie'>"
DIV_TAG = "<div id = 'bim'>"
IMG_TAG = "<img src='http://www.example.com' title='funny things'>"

Tag = Struct.new(:type, :classes, :id, :name, :inside, :parent, :children, :depth)


html_string = "<div>  div text before  <p>    p text  </p>  <div>    more div text  </div>  div text after</div>"


class ScriptParser
  attr_reader :root, :html
  def initialize(html_string)
    @html = html_string
    @root = Tag.new('doc', [], nil, nil, '', nil, [], 0)
    parse_script
    render(@root)
  end

  def parse_tag(tag)
    # goal: capture any alphanumeric characters of any length between "<" " "
    type = tag.match(/<\w+( |>)/).to_a[0][1..-2] if tag.match(/<\w+( |>)/).to_a[0]
    classes = tag.match(/(class=('|"))(.+?)(("|'))/).to_a[3]
    classes = classes.split(' ') if classes
    id = tag.match(/(id=('|"))(\w+?)(("|'))/).to_a[3]
    name = tag.match(/(name=('|"))(\w+?)(("|'))/).to_a[3]
    inside = # for tags that require, any content
    Tag.new(type, classes, id, name, '', nil, [], 0)
  end

  def parse_script


    current_tag = @root
    inside_opening_tag = true
    inside_closing_tag = false

    @html.each_char.with_index do |char, i|

      if char == "<" && @html[i+1] != '/'
        current_tag.children << current_tag.inside.strip
        current_tag.inside = ""

        child_tag = parse_tag(@html[i..-1])
        current_tag.children << child_tag

        child_tag.parent = current_tag
        current_tag = child_tag
        current_tag.depth = current_tag.parent.depth + 1
        inside_opening_tag = true

      elsif inside_opening_tag && char == '>'
        inside_opening_tag = false

      elsif inside_closing_tag && char == '>'
        inside_closing_tag = false

      elsif char == "/" && @html[i-1] == '<'
        current_tag = current_tag.parent
        inside_closing_tag = true


      elsif inside_closing_tag == false && inside_opening_tag == false && char != '>' && char != '<'
        current_tag.inside << char
      end

    end
    @root
  end


  # alternatively: get a regex that captures anything surrounded by opening & closing angle brackets

  # split, and get everything in between using
  # two arrays - tags in order, contents in order
  # use a stack

  def render_open_tag(tag)
    tag_string = "<"
    tag_string << tag.type
    tag_string << " name= " << tag.name unless tag.name = ""
    tag_string << " id= " << tag.id unless tag.id = ""
    tag_string << " class= " << tag.classes.join(" ") unless tag.classes = []
    tag_string << ">"
  end

  def render(parent, rendered_html = "")
     if parent.is_a?(String)
      rendered_html << parent
      return
    elsif parent.children  == []
      rendered_html << render_open_tag(parent)
    end





    parent.children.each do |child|
       next if child == ""

      if  child.is_a?(Tag)
        rendered_html << render_open_tag(child)
      end
      tag = render(child, rendered_html)
      tag << "</#{child.type}>"
    end
    puts rendered_html
  end
end

# Finally, output the string again.
# It doesn't have to have pretty spacing like it does here...
# outputter( data_structure )

# <div>
#   div text before
#   <p>  # < signifies begin child tag creation
#       # </ signifies end child tag creation
#     p text
#   </p>
#   <div>
#     more div text
#   </div>
#   div text after # if not in a child tag, any text is added to :inside
# </div>

# as we iterate, keep track of:
#tag we are inside of
#parent tag


#parent has child if new tag opens before parent closes
#parent's inside is when parent is the only opened tag and there is text
#



sp = ScriptParser.new(html_string)
# puts ScriptParser.new(html_string).html[36..45]
# sp.children.each do |child|
#   p child.childre
# end

# queue = [@doc]

# def render
# while item = queue.shift
#   item.children.reverse_each { |type| queue.unshift(type) } if item.children != []
#   p item.type
# end
# end

