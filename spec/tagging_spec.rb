require 'spec_helper'

describe 'Tagging', :with_active_record do

  before(:all) do
    class TaggableEntity < ActiveRecord::Base; end
  end

  before(:each) do
    @tag = Tag.create(:name => 'abc')
    @taggable = TaggableEntity.create
    @tagging = Tagging.new(:tag => @tag, :taggable => @taggable)
  end

  describe ".tag" do
    it "should return associated Tag object" do
      @tagging.tag.should == @tag
    end
  end

  describe  ".taggable" do
    it "should return associated taggable entitiy" do
      @tagging.taggable.should == @taggable
    end
  end

end
