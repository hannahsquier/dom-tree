require 'dom_reader'

describe DOMReader do

  let(:small_html) { DOMReader.new('./small_html.txt') }
  let(:large_html) { DOMReader.new('./test.html') }
  let(:mult_attr_tag) { "<p class='foo bar' id='baz'>" }
  let(:one_attr_tag) { "<div id = \"bim\">" }
  let(:no_attr_tag) {"<html>"}
  let(:close_tag) { "</div>" }
  let(:tag_node) { Tag.new("test", [], nil, nil, [], 0) }

  describe "#initialize" do
    it "creates a string version of the file at the path passed in" do
      expect(small_html.instance_variable_get(:@text)).to be_a(String)
    end

    it "initializes document tree correctly" do
      expect(small_html.tree).to be_a(Tag)
      expect(small_html.tree.type).to eq("doc")
      expect(small_html.tree.classes).to eq([])
      expect(small_html.tree.id).to eq(nil)
      expect(small_html.tree.parent).to eq(nil)
      expect(small_html.tree.children).to eq([])
      expect(small_html.tree.depth).to eq(0)
    end
  end

  describe "#build_tag" do
    it "creates a Tag struct for html string tag with no attributes" do
      tag = small_html.build_tag(no_attr_tag)
      expect(tag.type).to eq("html")
      expect(tag.classes).to eq([])
      expect(tag.id).to eq(nil)
      expect(tag.parent).to eq(nil)
      expect(tag.children).to eq([])
      expect(tag.depth).to eq(0)
    end

    it "creates a Tag for html string tag with one id attribute" do
      tag = small_html.build_tag(one_attr_tag)
      expect(tag.type).to eq("div")
      expect(tag.classes).to eq([])
      expect(tag.id).to eq('bim')
      expect(tag.parent).to eq(nil)
      expect(tag.children).to eq([])
      expect(tag.depth).to eq(0)
    end

    it "creates a Tag for html string tag with one id attribute and multiple class attributes" do
      tag = small_html.build_tag(mult_attr_tag)
      expect(tag.type).to eq("p")
      expect(tag.classes).to eq(['foo', 'bar'])
      expect(tag.id).to eq('baz')
      expect(tag.parent).to eq(nil)
      expect(tag.children).to eq([])
      expect(tag.depth).to eq(0)
    end
  end

  describe "#tag?" do
    it "can correctly identify different types of tags as tags" do
      expect(small_html.tag?(mult_attr_tag)).to eq true
      expect(small_html.tag?(close_tag)).to eq true
      expect(small_html.tag?(one_attr_tag)).to eq true
    end
  end

   describe "#close_tag?" do
    it "can correctly identify a close tag" do
      expect(small_html.close_tag?(close_tag)).to eq true
    end

        it "returns false if passed an open tag" do
      expect(small_html.close_tag?(mult_attr_tag)).to eq false
    end
  end

  describe "#create_child_tag" do
    it "calls build_tag" do
      expect(small_html).to receive(:build_tag).and_return(tag_node)
      small_html.create_child_tag("<text>", tag_node)
    end
  end


end