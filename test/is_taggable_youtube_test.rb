require 'test_helper'

Expectations do
#  two tags in youtube style comment
  expect ["one", "two"] do
    IsTaggable.configure_tag_list(:youtube)
    n = Comment.new :tag_list => "one two"
    IsTaggable.configure_tag_list
    n.tag_list
  end

# three tags in youtube style comment
  expect ["is_taggable", "has", "tag's"] do
    IsTaggable.configure_tag_list(:youtube)
    n = Comment.new :tag_list => "is_taggable has tag's"
    IsTaggable.configure_tag_list
    n.tag_list
  end

# youtube tag with comma delimiter in comment
  expect ["is_taggable", "has 'tags' by default"] do
    IsTaggable.configure_tag_list(:youtube)
    n = Comment.new :tag_list => "is_taggable, has 'tags' by default"
    IsTaggable.configure_tag_list
    n.tag_list
  end
  
# standart tag with saving and two tags in post
  expect ["something", "new"] do
    IsTaggable.configure_tag_list(:youtube)
    p = Post.new :tag_list => "something cool"
    IsTaggable.configure_tag_list
    p.save!
    p.tag_list = "something new"
    p.save!
    p.tags.reload
    p.instance_variable_set("@tag_list", nil)
    p.tag_list
  end


  expect "english, french" do
    IsTaggable.configure_tag_list(:standard, :output_delimiter => ', ')
    p = Post.new :language_list => "english french"
    output = p.language_list.to_s
    IsTaggable.configure_tag_list
    output
  end


# should clean up strings with arbitrary spaces around commas
  expect ["spaces", "should", "not", "matter"] do
    IsTaggable.configure_tag_list(:youtube)
    p = Post.new
    p.tag_list = "spaces,should,  not,matter"
    p.save!
    p.tags.reload
    IsTaggable.configure_tag_list
    p.tag_list
  end

# ignoring of blank and one symbol tags
  expect ["blank", "topics", "should be ignored","one symbol too"] do
    p = Post.new
    IsTaggable.configure_tag_list(:youtube)
    p.tag_list = "blank, topics, should be ignored,,a, one symbol too,"
    IsTaggable.configure_tag_list
    p.tag_list
  end

  expect 2 do
    p = Post.new :language_list => "english french"
    p.save!
    p.tags.length
  end

end
