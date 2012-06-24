require 'spec_helper'

describe 'IsTaggable::Mixin', :with_active_record do

  before(:all) do
    class TaggableEntity < ActiveRecord::Base
      def self.tag_kinds; [:tag, :language]; end
      include IsTaggable::Mixin
    end
  end

  subject { TaggableEntity.new }

  describe "#<kind>_list" do
    it "should be defined #<kind>_list method for each of tag_kinds" do
      subject.should respond_to(:tag_list)
      subject.should respond_to(:language_list)
    end

    it "should return [] for a new instance" do
      subject.tag_list.should == []
    end

    it "should return instance of IsTaggable::List array subclass" do
      subject.tag_list.should be_instance_of(IsTaggable::List)
    end

    it "should return [list of tags of kind <kind>] if tags were assigned to an instance" do
      subject.tags << Tag.new(:name => 'tag1', :kind => 'tag')
      subject.tags << Tag.new(:name => 'tag2', :kind => 'tag')
      subject.tags << Tag.new(:name => 'tag3', :kind => 'language')
      subject.save
      subject.tag_list.should == ['tag1', 'tag2']
      subject.language_list.should == ['tag3']
    end
  end

  describe "#<kind>_list =" do
    context "str" do
      it "should extract tag names from str and assign them to the list" do
        subject.tag_list = "abc def"
        subject.tag_list.should == ['abc', 'def']
      end

      it "should not save tags in database" do
        subject.tag_list = 'tag'
        Tag.where(:name => 'tag', :kind => 'tag').should_not exist
      end
    end

    context "[list of tag names]" do
      it "should assign list of tag names to the list" do
        subject.tag_list = ['abc', 'def']
        subject.tag_list.should == ['abc', 'def']
      end

      it "should not save tags in database" do
        subject.tag_list = ['tag']
        Tag.where(:name => 'tag', :kind => 'tag').should_not exist
      end
    end
  end

  describe "#tags" do
    it "should return list of associated Tags objects" do
      subject.tags.klass.should == Tag
    end
  end

  describe "#taggings" do
    it "should return list of associated Tagging objects" do
      subject.taggings.klass.should == Tagging
    end
  end

  context "on after_save event" do
    it "should save tags" do
      subject.tag_list = 'tag'
      subject.save
      Tag.where(:name => 'tag', :kind => 'tag').should exist
    end
  end

  context "on after_destroy event" do
    it "should destroy dependent Tagging objects" do
      taggable_entity = TaggableEntity.create(:tag_list => 't1 t2')
      Tagging.count.should == 2
      taggable_entity.destroy
      Tagging.count.should == 0
    end
  end
end
