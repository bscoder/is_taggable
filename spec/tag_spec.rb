require 'spec_helper'

describe 'Tag', :with_active_record do

  before(:all) do
    @tag1 = Tag.create!(:name => 'french', :kind => 'language') 
    @tag2 = Tag.create!(:name => 'german', :kind => 'language') 
    @tag3 = Tag.create!(:name => 'x', :kind => 'y') 
  end

  context "on after_destroy event" do
    it "should destroy dependent Tagging objects" do
      Tagging.create!(:tag => @tag1, :taggable => @tag2)  # tag as taggable object - weird but possible
      Tagging.count.should == 1
      @tag1.destroy
      Tagging.all.should be_empty
    end
  end

  describe ".create" do
    it "should not save without name" do
      Tag.create(:name => '').should_not be_persisted
    end

    it "should save when provided with name" do
      Tag.create(:name => 'x').should be_persisted
    end

    it "should save duplicate tags of different kinds" do
      Tag.create(:name => 'x', :kind => 'y')
      Tag.create(:name => 'x', :kind => 'z').should be_persisted
    end

    it "should not save duplicate tags of different kinds" do
      Tag.create(:name => 'x', :kind => 'y')
      Tag.create(:name => 'x', :kind => 'y').should_not be_persisted
    end
  end

  describe ".of_kind(<kind>)" do
    it "should find tags of kind <kind>" do
      Tag.of_kind("language").should == [@tag1, @tag2]
    end
  end

  describe ".with_name_like_and_kind(<name>, <kind>)" do
    it "should find tags with name ==  <name> and of kind <kind>" do
      Tag.with_name_like_and_kind('french', 'language').should == [@tag1]
    end

    it "should be case insensitive" do
      Tag.with_name_like_and_kind('FRENCH', 'language').should == [@tag1]
    end
  end

  describe ".find_or_initialize_with_name_like_and_kind(<name>, <kind>)" do
    it "should find existing tag if possible" do
      Tag.find_or_initialize_with_name_like_and_kind('french', 'language').should == @tag1
    end

    it "should be case insensitive" do
      Tag.find_or_initialize_with_name_like_and_kind('FRench', 'language').should == @tag1
    end

    it "should build a new tag with name = <name> and kind = <kind> if needed" do
      tag = Tag.find_or_initialize_with_name_like_and_kind('spanish', 'language')
      tag.should be_new_record
      tag.name.should == 'spanish'
      tag.kind.should == 'language'
    end
  end

  describe "#taggings" do
    it "should return list of associated Tagging objects" do
      Tag.new.taggings.klass.should == Tagging
    end
  end

end
