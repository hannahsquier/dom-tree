require_relative 'dom_reader'

class TreeSearcher
  def initialize(tree)
    @tree = tree
  end

  def search_by(attrib, query)
    case attrib
      when :class
        search_by_class(query)
      when :id
        search_by_id(query)
      when :text
        search_by_text(query)
    end
  end

  def search_by_class(query, node=@tree, result=[])
    return result if node.children.empty?

    node.children.each do |child|
       next if child.is_a?(String)
       result << child if child.classes.include?(query)
       result = search_by_class(query, child, result)
    end
    result
  end


  def search_by_id(query, node=@tree, result=[])
    return result if node.children.empty?

    node.children.each do |child|
       next if child.is_a?(String)
       result << child if child.id == query
       result = search_by_id(query, child, result)
    end
    result
  end

  def search_by_text(query, node=@tree, result=[])
    return result if  node.is_a?(String) || node.children.empty?

    node.children.each do |child|

       result << node if child == query
       result = search_by_text(query, child, result)
    end
    result
  end

end

d = DOMReader.new('./test.html')
tree = d.build_tree
ts = TreeSearcher.new(tree)

p ts.search_by(:text, 'One h1')
