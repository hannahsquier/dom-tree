#Save RegEx as Constants

TAG = /<([^<>]+)>/
CLOSE_TAG = /<\/([^<>]+)>/
ATTRIBS = /(\w+=["|'][\w|\s|\d|:|\-|.|\/]+["|'])/

Tag = Struct.new(:type, :classes, :id, :parent, :children, :depth, :attributes)


class DOMReader

  attr_reader :tree

  def initialize(file)
    @text = File.open(file) { |f| f.read }
    @tree = Tag.new("doc", [], nil, nil, [], 0, {})
  end

  def build_tree
    current_text = @text.start_with?('<!') ? @text[15..-1] : @text
    current_tag = @tree

    until current_text.strip.empty?
      tag_index = (TAG =~ current_text)

      inner_text = current_text[0...tag_index].strip
      current_tag.children << inner_text unless inner_text == ""

      current_text = current_text[tag_index..-1]
      if tag?(current_text) && !close_tag?(current_text)
        current_tag = create_child_tag(current_text, current_tag)
        current_tag.depth = current_tag.parent.depth + 1

      elsif close_tag?(current_text)
        current_tag = current_tag.parent
      end

      tag_length = current_text.match(TAG)[0].length
      current_text = current_text[tag_length..-1]

    end
    @tree
  end

  def tag?(current_text)
    (TAG =~ current_text.strip) == 0
  end

  def close_tag?(current_text)
    (CLOSE_TAG =~ current_text.strip) == 0
  end

  def create_child_tag(current_text, current_tag)
    tag_text = current_text.match(TAG)[0]
    child_tag = build_tag(tag_text)
    child_tag.parent = current_tag
    current_tag.children << child_tag
    child_tag
  end

  def build_tag(tag_text)
    type = tag_text.match(/<\w+( |>)/).to_a[0][1..-2]
    classes = tag_text.match(/(class(| )=(| )('|"))(.+?)(("|'))/).to_a[5]
    classes = classes ? classes.split(' ') : []
    id = tag_text.match(/(id(| )=(| )('|"))(\w+?)(("|'))/).to_a[5]
    tag = Tag.new(type, classes, id, nil, [], 0, {})
    add_other_attributes(tag, tag_text)
  end

  def add_other_attributes(tag, tag_text)
    attrib_matches = tag_text.scan(ATTRIBS)

    attrib_matches.each do |match|
      match = match[0].gsub("'","").gsub("\"","").split('=')
      tag.attributes[match[0]] = match[1]
    end
    tag
  end


end

d = DOMReader.new('./small_html.txt')
d.build_tree
#p d.tree

