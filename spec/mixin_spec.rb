require 'spec_helper'


describe 'IsTaggable::Mixin', :with_active_record do

  before(:all) do
    class TaggableEntity < ActiveRecord::Base
      def self.tag_kinds; [:tag, :language]; end
      include IsTaggable::Mixin
    end
  end

  subject { TaggableEntity.new }

  it "should have #<kind>_list method for each of tag_kinds" do
    subject.should respond_to(:tag_list)
    subject.should respond_to(:language_list)
  end

  describe "#<kind>_list" do
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

  describe "#<kind>_list=" do
  end

  describe "#tags" do
  end

end
