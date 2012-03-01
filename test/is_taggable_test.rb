require 'test_helper'

Expectations do
  expect Tag do
    Post.new.tags.build
  end

  expect Tagging do
    Post.new.taggings.build
  end
  
  expect ["one", "two"] do
    n = Comment.new :tag_list => "one two"
    n.tag_list
  end

  expect ["is_taggable", "has 'tags' by default"] do
    IsTaggable.configure_tag_list(:standard, :delimiter => ',')
    n = Comment.new :tag_list => "is_taggable, has 'tags' by default"
    IsTaggable.configure_tag_list # puts things back to avoid breaking following tests
    n.tag_list
  end
  
  expect ["something cool", "something else cool"] do
    IsTaggable.configure_tag_list(:standard, :delimiter => ',')
    p = Post.new :tag_list => "something cool, something else cool"
    IsTaggable.configure_tag_list # puts things back to avoid breaking following tests
    p.tag_list
  end

  expect ["something", "new"] do
    p = Post.new :tag_list => "something cool"
    p.save!
    p.tag_list = "something new"
    p.save!
    p.tags.reload
    p.instance_variable_set("@tag_list", nil)
    p.tag_list
  end

  expect ["something", "something"] do
    p = Post.new :tag_list => "something something"
    p.tag_list
  end

  expect ["something"] do
    p = Post.new :tag_list => "something something"
    p.save
    p.tag_list
  end
  
  expect ["english", "french"] do
    p = Post.new :language_list => "english french"
    p.save!
    p.tags.reload
    p.instance_variable_set("@language_list", nil)
    p.language_list
  end

  expect ["english", "french"] do
    p = Post.new :language_list => "english french"
    p.language_list
  end

  expect "english french" do
    p = Post.new :language_list => "english french"
    p.language_list.to_s
  end
  
  expect "english, french" do
    IsTaggable.configure_tag_list(:standard, :output_delimiter => ', ')
    p = Post.new :language_list => "english french"
    output = p.language_list.to_s
    IsTaggable.configure_tag_list
    output
  end

  expect "english french german" do
    IsTaggable.configure_tag_list(:standard, :delimiter => /[, ]/, :output_delimiter => ' ')
    p = Post.new :language_list => "english,french, german"
    output = p.language_list.to_s
    IsTaggable.configure_tag_list
    output
  end

  # added - should clean up strings with arbitrary spaces around commas
  expect ["spaces", "should", "not", "matter"] do
    IsTaggable.configure_tag_list(:standard, :delimiter => ',')
    p = Post.new
    p.tag_list = "spaces,should,  not,matter"
    p.save!
    p.tags.reload
    IsTaggable.configure_tag_list
    p.tag_list
  end

  expect ["blank", "topics", "should be ignored"] do
    p = Post.new
    IsTaggable.configure_tag_list(:standard, :delimiter => ',')
    p.tag_list = "blank, topics, should be ignored, "
    p.save!
    p.tags.reload
    IsTaggable.configure_tag_list
    p.tag_list
  end

  expect 2 do
    p = Post.new :language_list => "english french"
    p.save!
    p.tags.length
  end
end
